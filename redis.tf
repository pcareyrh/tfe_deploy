
# NOTE: the Name used for Redis needs to be globally unique
resource "azurerm_redis_cache" "pcarey-redis-tfe" {
  name                = "pcarey-redis-tfe"
  location            = var.location
  resource_group_name = var.resource_group_name
  capacity            = 3
  family              = "C"
  sku_name            = "Standard"
  enable_non_ssl_port = true
  minimum_tls_version = "1.2"
  public_network_access_enabled = false

  redis_configuration {
  }

  tags = local.common_tags
  depends_on = [azurerm_resource_group.pcarey-rg]
}