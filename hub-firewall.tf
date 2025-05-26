

resource "azurerm_public_ip" "azfirewall" {
  name                = "azfirewall-pip"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_firewall" "azfirewall" {
  name                = "azfirewall"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard" # required for Standard for DNS Proxy

  ip_configuration {
    name                 = "AzureFirewallSubnet"
    subnet_id            = azurerm_subnet.hub-subnet-2.id
    public_ip_address_id = azurerm_public_ip.azfirewall.id
  }
}
resource "azurerm_monitor_diagnostic_setting" "azfirewall" {
  name                       = "azfirewall-diagnostics"
  target_resource_id         = azurerm_firewall.azfirewall.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.hub.id

  enabled_log {
    category = "AzureFirewallApplicationRule"
  }
  enabled_log {
    category = "AzureFirewallNetworkRule"
  }
  enabled_log {
    category = "AzureFirewallDnsProxy"
  }

  metric {
    category = "AllMetrics"
    enabled  = false
  }
}

resource "azurerm_firewall_policy" "azfirewall_policy" {
  name                = "fw-manager"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  sku                 = "Standard"
}

resource "azurerm_firewall_policy_rule_collection_group" "example" {
  name               = "example-fwpolicy-rcg"
  firewall_policy_id = azurerm_firewall_policy.azfirewall_policy.id
  priority           = 500
  application_rule_collection {
    name     = "allow-apim-to-blob-dsl"
    priority = 500
    action   = "Deny"
    rule {
      name = "app_rule_collection1_rule1"
      protocols {
        type = "Http"
        port = 80
      }
      protocols {
        type = "Https"
        port = 443
      }
      source_addresses  = ["10.100.2.0/24"]
      destination_fqdns = ["apigblstorageprdsg1.blob.core.windows.net"]
    }
  }

}