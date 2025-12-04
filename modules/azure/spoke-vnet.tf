# =============== VNETs ===============
resource "azurerm_virtual_network" "spoke-vnet" {
  name                = "${var.naming_prefix}-spoke-vnet"
  location            = azurerm_resource_group.rg-spoke.location
  resource_group_name = azurerm_resource_group.rg-spoke.name
  address_space       = ["10.21.0.0/24"]
}

# =============== SUBNETs ===============
resource "azurerm_subnet" "s1-prod" {
  name                 = "${var.naming_prefix}-subnet-prod"
  resource_group_name  = azurerm_resource_group.rg-spoke.name
  virtual_network_name = azurerm_virtual_network.spoke-vnet.name
  address_prefixes     = ["10.21.0.0/25"]
  default_outbound_access_enabled = false
}

resource "azurerm_subnet" "s1-dev" {
  name                 = "${var.naming_prefix}-subnet-dev"
  resource_group_name  = azurerm_resource_group.rg-spoke.name
  virtual_network_name = azurerm_virtual_network.spoke-vnet.name
  address_prefixes     = ["10.21.0.128/25"]
  default_outbound_access_enabled = false
}