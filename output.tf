output "app_service_url" {
  description = "URL principal de acesso ao App Service"
  value       = "https://${azurerm_linux_web_app.app.default_hostname}"
}

output "database_fqdn" {
  description = "Endereço FQDN do banco de dados"
  value       = azurerm_mysql_flexible_server.mysql.fqdn
}

output "database_name" {
  description = "Nome do banco de dados"
  value       = azurerm_mysql_flexible_database.database.name
}

output "resource_names" {
  description = "Nome de todos os recursos criados no Azure"
  value = {
    resource_group     = azurerm_resource_group.rg.name
    storage_account    = azurerm_storage_account.storage.name
    storage_container  = azurerm_storage_container.container.name
    mysql_server       = azurerm_mysql_flexible_server.mysql.name
    app_service_plan   = azurerm_service_plan.plan.name
    app_service        = azurerm_linux_web_app.app.name
    container_app_job  = azurerm_container_app_job.backup_job.name
  }
}