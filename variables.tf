variable "location-db" {
  default = "West US 2"
}

variable "location-app" {
  default = "West Central US"
}

variable "location" {
  default = "West US"
}

variable "prefix" {
  default = "sportfitness"
}

variable "db_admin_login" {
  type        = string
  description = "Usuário administrador do banco de dados MySQL"
  sensitive   = true
}

variable "db_admin_password" {
  type        = string
  description = "Senha do administrador do banco de dados MySQL"
  sensitive   = true
}