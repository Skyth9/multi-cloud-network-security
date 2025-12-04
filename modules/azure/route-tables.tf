# VPN GW RT
resource "azurerm_route_table" "fw-vm-rt" {
  name                = "${var.naming_prefix}-fw-vm-rt"
  location            = azurerm_resource_group.rg-hub.location
  resource_group_name = azurerm_resource_group.rg-hub.name

  route {
    name                   = "spoke-through-fw"
    address_prefix         = "10.21.0.0/24"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = azurerm_network_interface.vm-fw-nic.ip_configuration[0].private_ip_address
  }
}

resource "azurerm_subnet_route_table_association" "fw-rt-assoc" {
  subnet_id      = azurerm_subnet.hub-vpn.id
  route_table_id = azurerm_route_table.fw-vm-rt.id
}

# PROD VM
resource "azurerm_route_table" "prod-rt" {
  name                = "${var.naming_prefix}-prod-rt"
  location            = azurerm_resource_group.rg-spoke.location
  resource_group_name = azurerm_resource_group.rg-spoke.name

  route {
    name                   = "def"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = azurerm_network_interface.vm-fw-nic.ip_configuration[0].private_ip_address
  }
}

resource "azurerm_subnet_route_table_association" "prod-rt-assoc" {
  subnet_id      = azurerm_subnet.s1-prod.id
  route_table_id = azurerm_route_table.prod-rt.id
}

# DEV VM
resource "azurerm_route_table" "dev-rt" {
  name                = "${var.naming_prefix}-dev-rt"
  location            = azurerm_resource_group.rg-spoke.location
  resource_group_name = azurerm_resource_group.rg-spoke.name

  route {
    name                   = "def"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = azurerm_network_interface.vm-fw-nic.ip_configuration[0].private_ip_address
  }
}

resource "azurerm_subnet_route_table_association" "dev-rt-assoc" {
  subnet_id      = azurerm_subnet.s1-dev.id
  route_table_id = azurerm_route_table.prod-rt.id
}
