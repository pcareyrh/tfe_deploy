# Public subnet
# -------------
resource "azurerm_subnet" "tfe_network_frontend_subnet" {
  name                = "pcarey-frontend-subnet"
  resource_group_name = var.resource_group_name

  address_prefixes     = [var.network_frontend_subnet_cidr]
  virtual_network_name = azurerm_virtual_network.tfe_network.name
}

# Public subnet network securtiy group
resource "azurerm_network_security_group" "tfe_network_frontend_nsg" {
  name                = "pcarey-frontend-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name

  # Allow inbound traffic to TFE Application
  security_rule {
    name      = "allow-frontend-inbound-https"
    priority  = 125
    direction = "Inbound"
    access    = "Allow"
    protocol  = "Tcp"

    source_address_prefix = var.network_allow_range
    source_port_range     = "*"

    destination_port_range     = "443"
    destination_address_prefix = var.network_frontend_subnet_cidr
  }

  # Allow inbound TFE Console, only used for standalone deployment
  dynamic "security_rule" {
    content {
      name      = "allow-frontend-inbound-console"
      priority  = 150
      direction = "Inbound"
      access    = "Allow"
      protocol  = "Tcp"

      source_address_prefix = var.network_allow_range
      source_port_range     = "*"

      destination_port_range     = "8800"
      destination_address_prefix = var.network_frontend_subnet_cidr
    }
  }

  # Allow Application Gateway traffic
  dynamic "security_rule" {
    content {
      name      = "allow-frontend-inbound-ag"
      priority  = 250
      direction = "Inbound"
      access    = "Allow"
      protocol  = "*"

      source_address_prefix = "GatewayManager"
      source_port_range     = "*"

      destination_port_range     = "65200-65535"
      destination_address_prefix = "*"
    }
  }

  # Allow Azure Load Balancer when private
  dynamic "security_rule" {
    content {
      name      = "allow-frontend-inbound-ag-lb"
      priority  = 300
      direction = "Inbound"
      access    = "Allow"
      protocol  = "*"

      source_address_prefix = "AzureLoadBalancer"
      source_port_range     = "*"

      destination_port_range     = "*"
      destination_address_prefix = "*"
    }
  }

  tags = var.tags
}

# Public subnet network securtiy group association
resource "azurerm_subnet_network_security_group_association" "tfe_network_frontend_nsg_association" {
  subnet_id                 = azurerm_subnet.tfe_network_frontend_subnet.id
  network_security_group_id = azurerm_network_security_group.tfe_network_frontend_nsg.id
}