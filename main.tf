provider "azurerm" {
  features {}
}

# 1. Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "${var.prefix}-rg"
  location = var.location
}

# 2. Storage Account
resource "azurerm_storage_account" "storage" {
  name                     = "${var.prefix}stoacc"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# 3. Blob dentro do Storage Account
resource "azurerm_storage_container" "container" {
  name                  = "${var.prefix}-blob"
  storage_account_id    = azurerm_storage_account.storage.id
  container_access_type = "private"
}

# 4. MySQL Flexible Server
resource "azurerm_mysql_flexible_server" "mysql" {
  name                   = "${var.prefix}-db"
  resource_group_name    = azurerm_resource_group.rg.name
  location               = var.location-db
  administrator_login    = var.db_admin_login
  administrator_password = var.db_admin_password
  sku_name               = "B_Standard_B1s"
  version                = "5.7"
# Configuração de backup do Azure:
  backup_retention_days        = 7      # Quantidade de dias que o backup será guardado 
  geo_redundant_backup_enabled = false  # true se quiser geo-redundância
}

# 5. database dentro do MySQL Flexible Server
resource "azurerm_mysql_flexible_database" "database" {
  name                = "${var.prefix}_db"
  resource_group_name = azurerm_resource_group.rg.name
  server_name         = azurerm_mysql_flexible_server.mysql.name
  charset             = "utf8mb4"
  collation           = "utf8mb4_unicode_ci"
}

# 6. App Plan do App Service
resource "azurerm_service_plan" "plan" {
  name                = "${var.prefix}-plan"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location-app
  os_type             = "Linux"
  sku_name            = "B1"
}

# 7. Web App do Azure com as variáveis de ambiente
resource "azurerm_linux_web_app" "app" {
  name                = "${var.prefix}-app"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location-app
  service_plan_id     = azurerm_service_plan.plan.id

site_config {
  application_stack {
    java_version        = "17"
    java_server         = "TOMCAT"
    java_server_version = "10.1"
  }
}

  app_settings = {
    "WEBSITE_STACK" = "Java"
    "DB_HOST"     = azurerm_mysql_flexible_server.mysql.fqdn
    "DB_USER"     = var.db_admin_login
    "DB_PASSWORD" = var.db_admin_password
    "DB_NAME"     = azurerm_mysql_flexible_database.database.name
  }

  depends_on = [azurerm_mysql_flexible_server.mysql]
}

# 8. Container App Environment (para rodar o Job de backup do banco de dados)
resource "azurerm_container_app_environment" "env" {
  name                       = "${var.prefix}-env"
  location                   = azurerm_resource_group.rg.location
  resource_group_name        = azurerm_resource_group.rg.name
}

# 9. Container App Job agendado (Roda um dump do banco e envia para o Blob todos os dias, às 3h da manhã)

resource "azurerm_container_app_job" "backup_job" {
  name                 = "${var.prefix}-backup-job"
  location             = azurerm_resource_group.rg.location
  resource_group_name  = azurerm_resource_group.rg.name
  container_app_environment_id = azurerm_container_app_environment.env.id

  replica_timeout_in_seconds = 600
  replica_retry_limit        = 1

  # Gatilho de agendamento (Cron diário às 3h da manhã)
  schedule_trigger_config {
    cron_expression = "0 3 * * *"
  }

  template {
    container {
      name   = "backup-do-banco"
      image  = "samueeldaavid/backup-do-banco:latest"
      cpu    = "0.5"
      memory = "1Gi"

      # Variáveis de ambiente

      env {
        name  = "DB_HOST"
        value = azurerm_mysql_flexible_server.mysql.fqdn
      }
      env {
        name  = "DB_USER"
        value = var.db_admin_login
      }
      env {
        name  = "DB_PASSWORD"
        value = var.db_admin_password
      }
      env {
        name  = "DB_NAME"
        value = azurerm_mysql_flexible_database.database.name
      }
      env {
        name  = "STORAGE_ACCOUNT_NAME"
        value = azurerm_storage_account.storage.name
      }
      env {
        name  = "CONTAINER_NAME"
        value = azurerm_storage_container.container.name
      }
      env {
        name  = "STORAGE_CONNECTION_STRING"
        value = azurerm_storage_account.storage.primary_connection_string
      }
    }
  }
}