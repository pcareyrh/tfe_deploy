resource "azurerm_lb_rule" "http" {
  resource_group_name            = var.resource_group_name
  loadbalancer_id                = azurerm_lb.pcarey-tfe-lb.id
  name                           = "httpRule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "PublicIPAddress"
  backend_address_pool_id        = azurerm_lb_backend_address_pool.pcarey-lb-backend.id
  probe_id                       = azurerm_lb_probe.http.id
}

resource "azurerm_lb_rule" "https" {
  resource_group_name            = var.resource_group_name
  loadbalancer_id                = azurerm_lb.pcarey-tfe-lb.id
  name                           = "httpsRule"
  protocol                       = "Tcp"
  frontend_port                  = 443
  backend_port                   = 443
  frontend_ip_configuration_name = "PublicIPAddress"
  backend_address_pool_id        = azurerm_lb_backend_address_pool.pcarey-lb-backend.id
  probe_id                       = azurerm_lb_probe.https.id

}

resource "azurerm_lb_rule" "ssh" {
  resource_group_name            = var.resource_group_name
  loadbalancer_id                = azurerm_lb.pcarey-tfe-lb.id
  name                           = "sshRule"
  protocol                       = "Tcp"
  frontend_port                  = 22
  backend_port                   = 22
  frontend_ip_configuration_name = "PublicIPAddress"
  backend_address_pool_id        = azurerm_lb_backend_address_pool.pcarey-lb-backend.id
  probe_id                       = azurerm_lb_probe.ssh.id
}

resource "azurerm_lb_rule" "replicate" {
  resource_group_name            = var.resource_group_name
  loadbalancer_id                = azurerm_lb.pcarey-tfe-lb.id
  name                           = "replicateRule"
  protocol                       = "Tcp"
  frontend_port                  = 8800
  backend_port                   = 8800
  frontend_ip_configuration_name = "PublicIPAddress"
  backend_address_pool_id        = azurerm_lb_backend_address_pool.pcarey-lb-backend.id
  probe_id                       = azurerm_lb_probe.replicate.id
}

resource "azurerm_lb_rule" "console" {
  resource_group_name            = var.resource_group_name
  loadbalancer_id                = azurerm_lb.pcarey-tfe-lb.id
  name                           = "consoleRule"
  protocol                       = "Tcp"
  frontend_port                  = 32846
  backend_port                   = 32846
  frontend_ip_configuration_name = "PublicIPAddress"
  backend_address_pool_id        = azurerm_lb_backend_address_pool.pcarey-lb-backend.id
  probe_id                       = azurerm_lb_probe.console.id

}

/*resource "azurerm_lb_rule" "vaultha" {
  resource_group_name            = var.resource_group_name
  loadbalancer_id                = azurerm_lb.pcarey-tfe-lb.id
  name                           = "vaulthaRule"
  protocol                       = "Tcp"
  frontend_port                  = 8201
  backend_port                   = 8201
  frontend_ip_configuration_name = "PublicIPAddress"
}
*/

resource "azurerm_lb_probe" "http" {
  resource_group_name            = var.resource_group_name
  loadbalancer_id                = azurerm_lb.pcarey-tfe-lb.id
  name                           = "httpProbe"
  port                           = 80
}

resource "azurerm_lb_probe" "https" {
  resource_group_name            = var.resource_group_name
  loadbalancer_id                = azurerm_lb.pcarey-tfe-lb.id
  name                           = "httpssProbe"
  port                           = 443

}

resource "azurerm_lb_probe" "ssh" {
  resource_group_name            = var.resource_group_name
  loadbalancer_id                = azurerm_lb.pcarey-tfe-lb.id
  name                           = "sshProbe"
  port                           = 22

}

resource "azurerm_lb_probe" "replicate" {
  resource_group_name            = var.resource_group_name
  loadbalancer_id                = azurerm_lb.pcarey-tfe-lb.id
  name                           = "replicateProbe"
  port                           = 8800

}

resource "azurerm_lb_probe" "console" {
  resource_group_name            = var.resource_group_name
  loadbalancer_id                = azurerm_lb.pcarey-tfe-lb.id
  name                           = "consoleProbe"
  port                           = 32846

}