resource "azurerm_linux_virtual_machine" "linux_jumphost" {
  name                = "lin-jumphost-vm"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  size                = "Standard_B2ms"
  admin_username      = "azureuser"

  network_interface_ids = [
    azurerm_network_interface.linux_jumphost_nic.id,
  ]

  admin_ssh_key {
    username   = "azureuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    name                 = "linuxjumphostosdisk"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }
}

resource "azurerm_public_ip" "linux_jumphost_public_ip" {
  name                = "lin-jumphost-public-ip"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_interface" "linux_jumphost_nic" {
  name                = "lin-jumphost-nic"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.hub-subnet-1.id
    private_ip_address_allocation = "Dynamic"
  }
}

data "http" "my_ip" {
  url = "https://api.ipify.org"
}

resource "azurerm_network_security_group" "linux_jumphost_nsg" {
  name                = "lin-jumphost-nsg"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  security_rule {
    name                       = "Allow-SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = data.http.my_ip.response_body
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface_security_group_association" "linux_jumphost_nic_nsg" {
  network_interface_id      = azurerm_network_interface.linux_jumphost_nic.id
  network_security_group_id = azurerm_network_security_group.linux_jumphost_nsg.id
}