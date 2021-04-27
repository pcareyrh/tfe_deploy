resource "random_string" "tfe_pg_password" {
  length  = 20
  special = true
}

resource "azurerm_postgresql_server" "pcarey-ptfe-psql" {
  name                = "pcarey-ptfe-psql"
  location            = var.location
  resource_group_name = var.resource_group_name

  #administrator_login          = "psqladmin"
  #administrator_login_password = var.pgpass

  sku_name   = "GP_Gen5_4"
  version    = "11"
  #storage_mb = 640000

  administrator_login          = var.db_user
  administrator_login_password = random_string.tfe_pg_password.result

  backup_retention_days        = 7
  geo_redundant_backup_enabled = false
  auto_grow_enabled            = true

  public_network_access_enabled    = false
  ssl_enforcement_enabled          = true
  ssl_minimal_tls_version_enforced = "TLS1_2"

  tags = local.common_tags
  depends_on = [azurerm_resource_group.pcarey-rg]

}


resource "azurerm_postgresql_database" "pcarey-ptfe-psql-db" {
  name                = var.db_name
  resource_group_name = var.resource_group_name
  server_name         = azurerm_postgresql_server.pcarey-ptfe-psql.name
  charset             = "UTF8"
  collation           = "English_United States.1252"
}