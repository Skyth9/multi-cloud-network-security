# =============== PEERINGs ===============
resource "azurerm_virtual_network_peering" "HUB-S1" {
  name                      = "HUB-S1"
  resource_group_name = azurerm_resource_group.rg-hub.name
  virtual_network_name      = azurerm_virtual_network.HUB.name
  remote_virtual_network_id = azurerm_virtual_network.S1.id
  allow_forwarded_traffic   = true
}

resource "azurerm_virtual_network_peering" "S1-HUB" {
  name                      = "S1-HUB"
  resource_group_name = azurerm_resource_group.rg-hub.name
  virtual_network_name      = azurerm_virtual_network.S1.name
  remote_virtual_network_id = azurerm_virtual_network.HUB.id
  allow_forwarded_traffic   = true
}