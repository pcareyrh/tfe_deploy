resource "azurerm_virtual_network" "pcarey-vnet" {
    name                = var.vnet_name
    address_space       = ["10.0.0.0/16"]
    location            = var.location
    resource_group_name = var.resource_group_name

    tags = local.common_tags
    depends_on = [azurerm_resource_group.pcarey-rg]
}

resource "azurerm_subnet" "pcarey-subnet" {
    name                 = var.subnet_name
    resource_group_name  = var.resource_group_name
    virtual_network_name = azurerm_virtual_network.pcarey-vnet.name
    address_prefixes       = ["10.0.2.0/24"]
    service_endpoints    = ["Microsoft.Storage", "Microsoft.Sql"]
    enforce_private_link_endpoint_network_policies = true
}

resource "azurerm_public_ip" "pcarey-publicip" {
    name                         = var.publicip_name
    location                     = var.location
    resource_group_name          = var.resource_group_name
    allocation_method            = "Static"

    tags = local.common_tags
    depends_on = [azurerm_resource_group.pcarey-rg, azurerm_virtual_network.pcarey-vnet]
}

resource "azurerm_private_endpoint" "priv-endpoint-psql" {
  name                = "pcarey-psql-priv-endpoint"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = azurerm_subnet.pcarey-subnet.id

  private_service_connection {
    name                           = "pcarey-privateserviceconnection"
    private_connection_resource_id = azurerm_postgresql_server.pcarey-ptfe-psql.id
    subresource_names              = [ "postgresqlServer" ]
    is_manual_connection           = false
  }
}

resource "azurerm_private_endpoint" "priv-endpoint-redis" {
  name                = "pcarey-redis-priv-endpoint"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = azurerm_subnet.pcarey-subnet.id

  private_service_connection {
    name                           = "pcarey-redis-privateserviceconnection"
    private_connection_resource_id = azurerm_redis_cache.pcarey-redis-tfe.id
    subresource_names              = [ "redisCache" ]
    is_manual_connection           = false
  }
}

resource "azurerm_lb" "pcarey-tfe-lb" {
  name                = "TFELoadBalancer"
  location            = var.location
  resource_group_name = var.resource_group_name

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.pcarey-publicip.id
  }

  tags = local.common_tags
  depends_on = [azurerm_resource_group.pcarey-rg, azurerm_virtual_network.pcarey-vnet]
}

resource "azurerm_lb_backend_address_pool" "pcarey-lb-backend" {
# resource_group_name = var.resource_group_name
 loadbalancer_id     = azurerm_lb.pcarey-tfe-lb.id
 name                = "BackEndAddressPool"
}
/* Used for legacy VM setup.
resource "azurerm_network_interface_backend_address_pool_association" "pcarey-lb-assoc" {
  network_interface_id    = azurerm_network_interface.pcarey-nic.id
  ip_configuration_name   = "myNicConfiguration"
  backend_address_pool_id = azurerm_lb_backend_address_pool.pcarey-lb-backend.id
}

resource "azurerm_network_interface" "pcarey-nic" {
    name                        = var.nic_name
    location                    = var.location
    resource_group_name         = var.resource_group_name

    ip_configuration {
        name                          = "myNicConfiguration"
        subnet_id                     = azurerm_subnet.pcarey-subnet.id
        private_ip_address_allocation = "Dynamic"
        #public_ip_address_id          = azurerm_public_ip.pcarey-publicip.id
    }

    tags = {
        environment = "Terraform Demo"
    }
}
 
# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "pcarey-nic-to-sg" {
    network_interface_id      = azurerm_network_interface.pcarey-nic.id
    network_security_group_id = azurerm_network_security_group.pcarey-basic-sg.id
}
*/
resource "azurerm_network_security_group" "pcarey-basic-sg" {
    name                = var.sg_name
    location            = var.location
    resource_group_name = var.resource_group_name

    security_rule {
        name                       = "SSH"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }

    security_rule {
        name                       = "http"
        priority                   = 1002
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "80"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }

    security_rule {
        name                       = "https"
        priority                   = 1003
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "443"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }

    security_rule {
        name                       = "console"
        priority                   = 1004
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "32846"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }

    security_rule {
        name                       = "replicate"
        priority                   = 1005
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "8800"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }

    tags = local.common_tags
    depends_on = [azurerm_resource_group.pcarey-rg, azurerm_virtual_network.pcarey-vnet]
}