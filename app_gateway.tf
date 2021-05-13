locals {
  # Determine the resulting TFE IP
  load_balancer_ip = azurerm_public_ip.pcarey-publicip

  # Application Gateway
  # -------------------
  gateway_ip_configuration_name          = "tfe-ag-gateway-ip-config"
  trusted_root_certificate_name          = "pcarey-trusted-root-cert"
  frontend_ip_configuration_name_public  = "tfe-ag-frontend-ip-config-pub"
  frontend_ip_configuration_name_private = "tfe-ag-frontend-ip-config-priv"
  frontend_ip_configuration_name         = var.publicip_name
  backend_address_pool_name              = "tfe-ag-backend-address-pool"

  # TFE Application Configuration
  app_frontend_port_name          = "tfe-ag-frontend-port-app"
  app_frontend_http_listener_name = "tfe-ag-http-listener-frontend-port-app"
  app_backend_http_settings_name  = "tfe-ag-backend-http-settings-app"
  app_request_routing_rule_name   = "tfe-ag-routing-rule-app"

}

# Application Gateway
# -------------------
resource "azurerm_application_gateway" "tfe_ag" {
  name                = "pcarey-ag"
  resource_group_name = var.resource_group_name
  location            = var.location

  enable_http2 = true

  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 2
  }

  #identity {
    #type         = "UserAssigned"
    #identity_ids = [azurerm_user_assigned_identity.tfe_ag_msi[0].id]
  #}

  gateway_ip_configuration {
    name      = local.gateway_ip_configuration_name
    #subnet_id = var.network_frontend_subnet_id
    subnet_id = azurerm_subnet.tfe_network_frontend_subnet.id
  }

#  ssl_certificate {
#    name                = var.certificate_name
#    key_vault_secret_id = var.certificate_key_vault_secret_id
  #}

#  trusted_root_certificate {
#    name = local.trusted_root_certificate_name
#    data = var.trusted_root_certificate
#  }

  # Public front end configuration
  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name_public
    public_ip_address_id = azurerm_public_ip.pcarey-publicip.id
  }

  backend_address_pool {
    name = local.backend_address_pool_name
  }

  # TFE Application
  frontend_port {
    name = local.app_frontend_port_name
    port = 443
  }

  http_listener {
    name                           = local.app_frontend_http_listener_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.app_frontend_port_name
    protocol                       = "Https"
    ssl_certificate_name           = var.certificate_name
  }

  backend_http_settings {
    name                  = local.app_backend_http_settings_name
    cookie_based_affinity = "Disabled"
    path                  = ""
    protocol              = "Https"
    port                  = 443
    request_timeout       = 60
    host_name             = var.fqdn

    trusted_root_certificate_names = [local.trusted_root_certificate_name]
  }

  request_routing_rule {
    name                       = local.app_request_routing_rule_name
    rule_type                  = "Basic"
    http_listener_name         = local.app_frontend_http_listener_name
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.app_backend_http_settings_name
  }

  # TFE Console
  dynamic "frontend_port" {
    for_each = var.active_active == false ? [1] : []

    content {
      name = local.console_frontend_port_name
      port = 8800
    }
  }

  dynamic "http_listener" {
    for_each = var.active_active == false ? [1] : []

    content {
      name                           = local.console_frontend_http_listener_name
      frontend_ip_configuration_name = local.frontend_ip_configuration_name
      frontend_port_name             = local.console_frontend_port_name
      protocol                       = "Https"
    }
  }

  dynamic "backend_http_settings" {
    for_each = var.active_active == false ? [1] : []

    content {
      name                  = local.console_backend_http_settings_name
      cookie_based_affinity = "Disabled"
      path                  = ""
      protocol              = "Https"
      port                  = 8800
      request_timeout       = 60
      host_name             = "tfe.pcarey.xyz"

    }
  }

  dynamic "request_routing_rule" {
    for_each = var.active_active == false ? [1] : []

    content {
      name                       = local.console_request_routing_rule_name
      rule_type                  = "Basic"
      http_listener_name         = local.console_frontend_http_listener_name
      backend_address_pool_name  = local.backend_address_pool_name
      backend_http_settings_name = local.console_backend_http_settings_name
    }
  }

  tags = local.common_tags
}


