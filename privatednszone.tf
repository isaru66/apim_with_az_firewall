resource "azurerm_private_dns_zone" "apim" {
  name                = "azure-api.net"
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_private_dns_a_record" "apim_main" {
  name                = azurerm_api_management.api.name
  zone_name           = azurerm_private_dns_zone.apim.name
  resource_group_name = azurerm_resource_group.example.name
  ttl                 = 300
  records = [
    azurerm_api_management.api.private_ip_addresses[0]
  ]
}

resource "azurerm_private_dns_a_record" "apim_portal" {
  name                = "${azurerm_api_management.api.name}.portal"
  zone_name           = azurerm_private_dns_zone.apim.name
  resource_group_name = azurerm_resource_group.example.name
  ttl                 = 300
  records = [
    azurerm_api_management.api.private_ip_addresses[0]
  ]
}

resource "azurerm_private_dns_a_record" "apim_developer" {
  name                = "${azurerm_api_management.api.name}.developer"
  zone_name           = azurerm_private_dns_zone.apim.name
  resource_group_name = azurerm_resource_group.example.name
  ttl                 = 300
  records = [
    azurerm_api_management.api.private_ip_addresses[0]
  ]
}

resource "azurerm_private_dns_a_record" "apim_management" {
  name                = "${azurerm_api_management.api.name}.management"
  zone_name           = azurerm_private_dns_zone.apim.name
  resource_group_name = azurerm_resource_group.example.name
  ttl                 = 300
  records = [
    azurerm_api_management.api.private_ip_addresses[0]
  ]
}

resource "azurerm_private_dns_a_record" "apim_scm" {
  name                = "${azurerm_api_management.api.name}.scm"
  zone_name           = azurerm_private_dns_zone.apim.name
  resource_group_name = azurerm_resource_group.example.name
  ttl                 = 300
  records = [
    azurerm_api_management.api.private_ip_addresses[0]
  ]
}

# Example: Link the DNS zone to a virtual network
resource "azurerm_private_dns_zone_virtual_network_link" "apim_link_hub" {
  name                  = "apim-vnet-link-hub"
  resource_group_name   = azurerm_resource_group.example.name
  private_dns_zone_name = azurerm_private_dns_zone.apim.name
  virtual_network_id    = azurerm_virtual_network.hub.id
  registration_enabled  = false
}

resource "azurerm_private_dns_zone_virtual_network_link" "apim_link" {
  name                  = "apim-vnet-link-spoke"
  resource_group_name   = azurerm_resource_group.example.name
  private_dns_zone_name = azurerm_private_dns_zone.apim.name
  virtual_network_id    = azurerm_virtual_network.spoke.id
  registration_enabled  = false
}