resource "azurerm_linux_virtual_machine_scale_set" "pcarey-vmss" {
  name                = var.vm_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.vm_sku
  instances           = var.vm_count
  admin_username      = var.vm_admin_username
  disable_password_authentication = true


  admin_ssh_key {
    username   = var.vm_admin_username
    #    public_key = var.ssh_tfe_key
    public_key = file("~/.ssh/id_rsa.pub")
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  boot_diagnostics {
        storage_account_uri = azurerm_storage_account.pcarey-storage.primary_blob_endpoint
    }

  network_interface {
    name    = "vmss_nic"
    primary = true

    ip_configuration {
      name      = "pcarey_int_ip"
      primary   = true
      subnet_id = azurerm_subnet.pcarey-subnet.id
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.pcarey-lb-backend.id]
    }
  }

  tags = local.common_tags
  depends_on = [azurerm_resource_group.pcarey-rg]
}
