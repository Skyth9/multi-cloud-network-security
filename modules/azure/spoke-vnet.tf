# =============== VNETs ===============
resource "azurerm_virtual_network" "S1" {
  name                = "${var.naming_prefix}-spoke-vnet"
  location            = azurerm_resource_group.rg-spoke.location
  resource_group_name = azurerm_resource_group.rg-spoke.name
  address_space       = ["10.21.0.0/24"]
}

# =============== SUBNETs ===============
resource "azurerm_subnet" "s1-prod" {
  name                 = "${var.naming_prefix}-subnet-prod"
  resource_group_name  = azurerm_resource_group.rg-spoke.name
  virtual_network_name = azurerm_virtual_network.S1.name
  address_prefixes     = ["10.21.0.0/25"]
}

resource "azurerm_subnet" "s1-dev" {
  name                 = "${var.naming_prefix}-subnet-dev"
  resource_group_name  = azurerm_resource_group.rg-spoke.name
  virtual_network_name = azurerm_virtual_network.S1.name
  address_prefixes     = ["10.21.0.128/25"]
}