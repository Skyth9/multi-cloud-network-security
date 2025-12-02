resource "azurerm_resource_group" "rg-hub" {
  name     = "${var.naming_prefix}-rg-hub"
  location = "West Europe"
}

resource "azurerm_resource_group" "rg-spoke" {
  name     = "${var.naming_prefix}-rg-spoke"
  location = "West Europe"
}