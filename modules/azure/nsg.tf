# Create Network Security Group and rules
resource "azurerm_network_security_group" "sub1_nsg" {
  name                = "${var.naming_prefix}-sub1_nsg-nsg"
  location            = azurerm_resource_group.rg-hub.location
  resource_group_name = azurerm_resource_group.rg-hub.name

  security_rule {
    name                       = "RDP"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "172.30.3.0/24"
    destination_address_prefix = "172.21.0.0/24"
  }
  security_rule {
    name                       = "web"
    priority                   = 1100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "172.30.0.0/24"
    destination_address_prefix = "172.21.0.0/24"
  }
  security_rule {
    name                       = "appgw-app"
    priority                   = 1100
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "172.30.0.0/24"
  }
}

# Connect the security group to the network interface
/*
resource "azurerm_network_interface_security_group_association" "vm1-nsg-assoc" {
  network_interface_id      = azurerm_network_interface.vm1-nic.id
  network_security_group_id = azurerm_network_security_group.vm1_nsg.id
}
*/

resource "azurerm_subnet_network_security_group_association" "onprem-nsg-assoc" {
  network_security_group_id = azurerm_network_security_group.sub1_nsg.id
  subnet_id                 = azurerm_subnet.s1-prod.id
}

###################################
/*
resource "azurerm_network_security_group" "endpoint-sub-nsg" {
  name                = "${local.naming_prefix}-endpoint-sub-nsg"
  location            = var.rg-location
  resource_group_name = var.rg-name
}

resource "azurerm_subnet_network_security_group_association" "endpoint-nsg-assoc" {
  network_security_group_id = azurerm_network_security_group.endpoint-sub-nsg.id
  subnet_id                 = azurerm_subnet.s2-pe.id
}

###################################

resource "azurerm_network_security_group" "appout-sub-nsg" {
  name                = "${local.naming_prefix}-appout-sub-nsg"
  location            = var.rg-location
  resource_group_name = var.rg-name
}

resource "azurerm_subnet_network_security_group_association" "appout-nsg-assoc" {
  network_security_group_id = azurerm_network_security_group.appout-sub-nsg.id
  subnet_id                 = azurerm_subnet.s2-app-out.id
}
*/