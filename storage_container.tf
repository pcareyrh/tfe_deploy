data "http" "myip" {
  url = "https://ipv4.icanhazip.com"
}

resource "azurerm_storage_account" "pcarey-storage" {
  name                     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = var.account_tier
  account_replication_type = var.storage_replication_type

  network_rules {
      default_action        = "Deny"
      virtual_network_subnet_ids = [azurerm_subnet.pcarey-subnet.id]
      bypass                = ["AzureServices"]
      ip_rules              = [chomp(data.http.myip.body)]
  }

  tags  = local.common_tags
  depends_on = [azurerm_resource_group.pcarey-rg]
}

resource "azurerm_storage_container" "pcarey-storage-container" {
  name                  = "pcarey-container"
  storage_account_name  = azurerm_storage_account.pcarey-storage.name
  container_access_type = "private"
}