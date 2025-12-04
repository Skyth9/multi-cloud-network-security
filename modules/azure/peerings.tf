# =============== PEERINGs ===============
resource "azurerm_virtual_network_peering" "hub-spoke" {
  name                      = "${var.naming_prefix}-hub-spoke"
  resource_group_name = azurerm_resource_group.rg-hub.name
  virtual_network_name      = azurerm_virtual_network.hub-vnet.name
  remote_virtual_network_id = azurerm_virtual_network.spoke-vnet.id
  allow_forwarded_traffic   = true
}

resource "azurerm_virtual_network_peering" "spoke-hub" {
  name                      = "${var.naming_prefix}-spoke-hub"
  resource_group_name = azurerm_resource_group.rg-spoke.name
  virtual_network_name      = azurerm_virtual_network.spoke-vnet.name
  remote_virtual_network_id = azurerm_virtual_network.hub-vnet.id
  allow_forwarded_traffic   = true
}