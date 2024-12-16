# Configure the Azure Provider
provider "azurerm" {
    subscription_id = "a8d9ce0d-259f-474d-8d48-10f4d89ba7de"
  features {}
}

# Create a resource group
resource "azurerm_resource_group" "rg" {
  name     = "SkyVM1_rg"
  location = "Norway East"
}

resource "azurerm_ssh_public_key" "example" {
  name                = "SkyVM1_ssh_key"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  public_key          = file("~/terraform2/.ssh/id_rsa.pub")
}

# Create a virtual network
resource "azurerm_virtual_network" "vnet" {
  name                = "SkyVM1_vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Create a subnet
resource "azurerm_subnet" "subnet" {
  name                 = "SkyVM1_subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Create a network interface
resource "azurerm_network_interface" "nic" {
  name                = "SkyVM1_nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "SkyVM1_nic_config"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.publicIP.id
  }
}

# Create a public IP address
resource "azurerm_public_ip" "publicIP" {
  name                = "SkyVM1_publicIP"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
}

# Create a network security group and rules
resource "azurerm_network_security_group" "nsg" {
  name                = "SkyVM1_nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "AllowSSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "AllowHTTP"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Associate the NSG with the NIC
resource "azurerm_network_interface_security_group_association" "nsg_association" {
  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

# Create a virtual machine
resource "azurerm_linux_virtual_machine" "vm" {
  name                = "SkyVM1"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_DS1_v2"
  admin_ssh_key {
    username   = "azureuser1"
    public_key = file("~/terraform2/.ssh/id_rsa.pub")
  }
  admin_username      = "azureuser1"
  admin_password      = "P@ssw0rd1234"

  network_interface_ids = [
    azurerm_network_interface.nic.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}

# Output the public IP of the virtual machine
output "public_ip_address" {
  value = azurerm_public_ip.publicIP.ip_address
}