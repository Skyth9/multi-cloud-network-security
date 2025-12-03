# =============== VNETs ===============
resource "azurerm_virtual_network" "HUB" {
  name                = "${var.naming_prefix}-hub-vnet"
  location            = azurerm_resource_group.rg-hub.location
  resource_group_name = azurerm_resource_group.rg-hub.name
  address_space       = ["172.21.0.0/16"]
  //dns_servers         = ["10.0.0.4", "10.0.0.5"]
}

# =============== SUBNETs ===============
resource "azurerm_subnet" "hub-appgw" {
  name                 = "${var.naming_prefix}-subnet-appgw"
  resource_group_name = azurerm_resource_group.rg-hub.name
  virtual_network_name = azurerm_virtual_network.HUB.name
  address_prefixes     = ["172.21.1.0/26"]
  default_outbound_access_enabled = false
}

resource "azurerm_subnet" "hub-fw" {
  name                 = "AzureFirewallSubnet"
  resource_group_name = azurerm_resource_group.rg-hub.name
  virtual_network_name = azurerm_virtual_network.HUB.name
  address_prefixes     = ["172.21.0.64/26"]
  default_outbound_access_enabled = false
}

resource "azurerm_subnet" "hub-fw-mgmt" {
  name                 = "AzureFirewallManagementSubnet"
  resource_group_name = azurerm_resource_group.rg-hub.name
  virtual_network_name = azurerm_virtual_network.HUB.name
  address_prefixes     = ["172.21.0.128/26"]
  default_outbound_access_enabled = false
}

resource "azurerm_subnet" "hub-vpn" {
  name                 = "GatewaySubnet"
  resource_group_name = azurerm_resource_group.rg-hub.name
  virtual_network_name = azurerm_virtual_network.HUB.name
  address_prefixes     = ["172.21.0.0/26"]
  default_outbound_access_enabled = false
}

resource "azurerm_subnet" "hub-bstn" {
  name                 = "AzureBastionSubnet"
  resource_group_name = azurerm_resource_group.rg-hub.name
  virtual_network_name = azurerm_virtual_network.HUB.name
  address_prefixes     = ["172.21.0.128/26"]
  default_outbound_access_enabled = false
}