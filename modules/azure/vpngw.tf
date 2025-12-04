# PIP 1
resource "azurerm_public_ip" "vpngw-pip-1" {
  name                = "${var.naming_prefix}-vpngw-pip-1"
  location            = azurerm_resource_group.rg-hub.location
  resource_group_name = azurerm_resource_group.rg-hub.name

  allocation_method = "Static"
  zones = ["1"]
}

#PIP2
resource "azurerm_public_ip" "vpngw-pip-2" {
  name                = "${var.naming_prefix}-vpngw-pip-2"
  location            = azurerm_resource_group.rg-hub.location
  resource_group_name = azurerm_resource_group.rg-hub.name

  allocation_method = "Static"
  zones = ["1"]
}

#VPNGW
resource "azurerm_virtual_network_gateway" "vpngw" {
  name                = "${var.naming_prefix}-vpngw"
  location            = azurerm_resource_group.rg-hub.location
  resource_group_name = azurerm_resource_group.rg-hub.name

  type     = "Vpn"
  vpn_type = "RouteBased"

  active_active = true
  enable_bgp    = true
  sku           = "VpnGw1AZ"


  ip_configuration {
    name                          = "primary"
    public_ip_address_id          = azurerm_public_ip.vpngw-pip-1.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.hub-vpn.id
  }

  ip_configuration {
    name                          = "secondary"
    public_ip_address_id          = azurerm_public_ip.vpngw-pip-2.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.hub-vpn.id
  }
  
  bgp_settings{
    # The range for private ASNs is 64512 to 65535
    # MS reserved ASNs from 65515 to 65520 for internal use.
    asn = 65001
    # BGP peering address - 169.254.21.* and 169.254.22.*
   
    peering_addresses {
      ip_configuration_name = "primary"
      apipa_addresses       = ["169.254.21.1"]
    }

    peering_addresses {
      ip_configuration_name = "secondary"
      apipa_addresses       = ["169.254.22.1"]
    }
    
  }
  

}


# LNG
resource "azurerm_local_network_gateway" "aws-peer-1" {
  name                = "${var.naming_prefix}-aws-peer-1"
  resource_group_name = azurerm_resource_group.rg-hub.name
  location            = azurerm_resource_group.rg-hub.location

  gateway_address = "169.254.0.1"
  address_space   = ["169.254.21.2/32"] # because we use BGP

  bgp_settings {
    asn                 = 65002
    bgp_peering_address = "169.254.21.2"
  }
}

resource "azurerm_local_network_gateway" "aws-peer-2" {
  name                = "${var.naming_prefix}-aws-peer-2"
  resource_group_name = azurerm_resource_group.rg-hub.name
  location            = azurerm_resource_group.rg-hub.location

  gateway_address = "169.254.0.2"
  address_space   = ["169.254.22.2/32"] # because we use BGP

  bgp_settings {
    asn                 = 65002
    bgp_peering_address = "169.254.22.2"
  }
}

# -----------------------------------------
# IPSec S2S Connection ( BGP enabled )
# -----------------------------------------

resource "azurerm_virtual_network_gateway_connection" "ipsec" {
  name                = "${var.naming_prefix}-s2s-bgp-conn-aws-1"
  location            = azurerm_resource_group.rg-hub.location
  resource_group_name = azurerm_resource_group.rg-hub.name

  type                       = "IPsec"
  virtual_network_gateway_id = azurerm_virtual_network_gateway.vpngw.id
  local_network_gateway_id   = azurerm_local_network_gateway.aws-peer-1.id

  shared_key = var.shared_key

  enable_bgp = true

  ipsec_policy {
    ike_encryption      = "AES256"
    ike_integrity       = "SHA256"
    dh_group            = "DHGroup14"
    ipsec_encryption    = "AES256"
    ipsec_integrity     = "SHA256"
    pfs_group           = "PFS14"
    sa_lifetime         = 3600
  }
}

resource "azurerm_virtual_network_gateway_connection" "ipsec2" {
  name                = "${var.naming_prefix}-s2s-bgp-conn-aws-2"
  location            = azurerm_resource_group.rg-hub.location
  resource_group_name = azurerm_resource_group.rg-hub.name

  type                       = "IPsec"
  virtual_network_gateway_id = azurerm_virtual_network_gateway.vpngw.id
  local_network_gateway_id   = azurerm_local_network_gateway.aws-peer-2.id

  shared_key = var.shared_key

  enable_bgp = true

  ipsec_policy {
    ike_encryption      = "AES256"
    ike_integrity       = "SHA256"
    dh_group            = "DHGroup14"
    ipsec_encryption    = "AES256"
    ipsec_integrity     = "SHA256"
    pfs_group           = "PFS14"
    sa_lifetime         = 3600
  }
}