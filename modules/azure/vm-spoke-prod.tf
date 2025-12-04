# This is a Linux VM, which will play the FW role

resource "azurerm_linux_virtual_machine" "vm-spoke-prod" {
  name                  = "${var.naming_prefix}-vm-prod"
  location              = azurerm_resource_group.rg-spoke.location
  resource_group_name   = azurerm_resource_group.rg-spoke.name
  size                  = "Standard_B1s"
  admin_username        = var.az_user
  admin_password        = var.az_pass
  network_interface_ids = [azurerm_network_interface.vm-prod-nic.id, ]
  # vm_agent_platform_updates_enabled = "true"
  disable_password_authentication = false

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  boot_diagnostics {

  }
}

resource "azurerm_network_interface" "vm-prod-nic" {
  name                = "${var.naming_prefix}-vm-prod-nic"
  location            = azurerm_resource_group.rg-spoke.location
  resource_group_name = azurerm_resource_group.rg-spoke.name
  ip_forwarding_enabled = true

  ip_configuration {
    name                          = "vm-prod-nic-conf"
    subnet_id                     = azurerm_subnet.s1-prod.id
    private_ip_address_allocation = "Dynamic"
  }
}