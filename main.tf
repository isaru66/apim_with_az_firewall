resource "azurerm_resource_group" "example" {
  name     = "rg-${var.resource_prefix}"
  location = "Southeast Asia"
}


resource "random_string" "azurerm_api_management_name" {
  length  = 13
  lower   = true
  numeric = false
  special = false
  upper   = false
}

# Wait for NSG to be created, + 5sec, then creating APIM
resource "time_sleep" "wait_5_seconds" {
  depends_on      = [azurerm_network_security_group.apim_nsg]
  create_duration = "5s"
}

resource "azurerm_api_management" "api" {
  name                = "apim-${random_string.azurerm_api_management_name.result}"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  publisher_email     = var.publisher_email
  publisher_name      = var.publisher_name
  sku_name            = "${var.apim_sku}_${var.apim_instance_count}"

  virtual_network_type = "Internal"
  virtual_network_configuration {
    subnet_id = azurerm_subnet.spoke-subnet-2.id
  }

  depends_on = [
    azurerm_subnet.spoke-subnet-2,
    time_sleep.wait_5_seconds,
  ]
}