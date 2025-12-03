# This is a Linux VM, which will play the FW role

resource "azurerm_linux_virtual_machine" "vm-fw" {
  name                  = "${var.naming_prefix}-vm-fw"
  location              = azurerm_resource_group.rg-hub.location
  resource_group_name   = azurerm_resource_group.rg-hub.name
  size                  = "Standard_B1s"
  admin_username        = var.az_user
  admin_password        = var.az_pass
  network_interface_ids = [azurerm_network_interface.vm-fw-nic.id, ]
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

resource "azurerm_public_ip" "vm-fw1-pip" {
  name                = "${var.naming_prefix}-vm-fw1-pip"
  location            = azurerm_resource_group.rg-hub.location
  resource_group_name = azurerm_resource_group.rg-hub.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_interface" "vm-fw-nic" {
  name                = "${var.naming_prefix}-vm-fw-nic"
  location            = azurerm_resource_group.rg-hub.location
  resource_group_name = azurerm_resource_group.rg-hub.name
  ip_forwarding_enabled = true

  ip_configuration {
    name                          = "vm-fw-nic-conf"
    subnet_id                     = azurerm_subnet.hub-fw.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm-fw1-pip.id
  }
}