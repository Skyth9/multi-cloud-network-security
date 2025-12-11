# Create Network Security Group and rules
################################### PROD ###################################
resource "azurerm_network_security_group" "prod_nsg" {
  name                = "${var.naming_prefix}-prod-nsg"
  location            = azurerm_resource_group.rg-hub.location
  resource_group_name = azurerm_resource_group.rg-hub.name

  security_rule {
    name                       = "appgw-in"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "172.21.1.0/26"
    destination_address_prefix = "10.21.0.0/25"
  }
  security_rule {
    name                       = "bstn-in"
    priority                   = 1100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges     = ["22","3389"]
    source_address_prefix      = "172.21.0.192/26"
    destination_address_prefix = "172.21.0.0/25"
  }
  
}

resource "azurerm_subnet_network_security_group_association" "prod_nsg-assoc" {
  network_security_group_id = azurerm_network_security_group.prod_nsg.id
  subnet_id                 = azurerm_subnet.s1-prod.id
}

################################### DEV ###################################
resource "azurerm_network_security_group" "dev_nsg" {
  name                = "${var.naming_prefix}-dev-nsg"
  location            = azurerm_resource_group.rg-hub.location
  resource_group_name = azurerm_resource_group.rg-hub.name

  security_rule {
    name                       = "appgw-in"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "172.21.1.0/26"
    destination_address_prefix = "10.21.0.128/25"
  }
  security_rule {
    name                       = "bstn-in"
    priority                   = 1100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges     = ["22","3389"]
    source_address_prefix      = "172.21.0.192/26"
    destination_address_prefix = "172.21.0.128/25"
  }
  
}

resource "azurerm_subnet_network_security_group_association" "dev_nsg-assoc" {
  network_security_group_id = azurerm_network_security_group.dev_nsg.id
  subnet_id                 = azurerm_subnet.s1-dev.id
}

################################### VM-FW ###################################
resource "azurerm_network_security_group" "vm-fw_nsg" {
  name                = "${var.naming_prefix}-vm-fw-nsg"
  location            = azurerm_resource_group.rg-hub.location
  resource_group_name = azurerm_resource_group.rg-hub.name

  security_rule {
    name                       = "ssh"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "176.12.30.85/32"
    destination_address_prefix = "172.21.255.0/24"
  }

  security_rule {
    name                       = "azure-spokes"
    priority                   = 1100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "10.21.0.0/16"
    destination_address_prefix = "*"
  }
  
  
}

resource "azurerm_subnet_network_security_group_association" "vm-fw-assoc" {
  network_security_group_id = azurerm_network_security_group.vm-fw_nsg.id
  subnet_id                 = azurerm_subnet.hub-vm-fw.id
}
