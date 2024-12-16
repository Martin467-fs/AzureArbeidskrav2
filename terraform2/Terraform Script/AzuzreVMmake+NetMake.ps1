# Configure the Azure Provider
provider "azurerm" {
  subscription_id = "a8d9ce0d-259f-474d-8d48-10f4d89ba7de"
features {}
}

resource "azurerm_resource_group" "Gruppe1" {
name     = "SkyTjenRG1"
location = "Norway East"
}

resource "azurerm_virtual_network" "Nettverk1" {
name                = "SkyTjenVNet1"
address_space       = ["10.0.0.0/24"]
location            = azurerm_resource_group.Gruppe1.location
resource_group_name = azurerm_resource_group.Gruppe1.name
}

resource "azurerm_subnet" "Subnet1" {
name                 = "SkyTjenSubnet1"
resource_group_name  = azurerm_resource_group.Gruppe1.name
virtual_network_name = azurerm_virtual_network.Nettverk1.name
address_prefixes     = ["10.0.0.0/26"]
}

resource "azurerm_subnet" "Subnet2" {
  name                 = "SkyTjenSubnet2"
  resource_group_name  = azurerm_resource_group.Gruppe1.name
  virtual_network_name = azurerm_virtual_network.Nettverk1.name
  address_prefixes     = ["10.0.0.64/26"]
}

resource "azurerm_network_interface" "Interface1" {
name                = "SkyTjenNIC1"
location            = azurerm_resource_group.Gruppe1.location
resource_group_name = azurerm_resource_group.Gruppe1.name

ip_configuration {
  name                          = "SkyTjenIP1"
  subnet_id                     = azurerm_subnet.Subnet1.id
  private_ip_address_allocation = "Dynamic"
}
}


resource "azurerm_ssh_public_key" "example" {
  name                = "SkyVM1_ssh_key"
  resource_group_name = azurerm_resource_group.Gruppe1.name
  location            = azurerm_resource_group.Gruppe1.location
  public_key          = file("~/terraform2/Lage nettverk/.ssh/id_rsa.pub")
}

# Create a network interface
resource "azurerm_network_interface" "nic" {
name                = "myNIC"
location            = azurerm_resource_group.Gruppe1.location
resource_group_name = azurerm_resource_group.Gruppe1.name

ip_configuration {
  name                          = "myNICConfiguration"
  subnet_id                     = azurerm_subnet.Subnet1.id
  private_ip_address_allocation = "Dynamic"
  public_ip_address_id          = azurerm_public_ip.publicIP.id
}
}

# Create a public IP address
resource "azurerm_public_ip" "publicIP" {
name                = "myPublicIP"
location            = azurerm_resource_group.Gruppe1.location
resource_group_name = azurerm_resource_group.Gruppe1.name
allocation_method   = "Static"
}

# Create a network security group and rules
resource "azurerm_network_security_group" "nsg" {
name                = "myNSG"
location            = azurerm_resource_group.Gruppe1.location
resource_group_name = azurerm_resource_group.Gruppe1.name

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
}

# Associate the NSG with the NIC
resource "azurerm_network_interface_security_group_association" "nsg_association" {
network_interface_id      = azurerm_network_interface.nic.id
network_security_group_id = azurerm_network_security_group.nsg.id
}

# Create a virtual machine
resource "azurerm_linux_virtual_machine" "vm" {
name                = "SkyVM1"
resource_group_name = azurerm_resource_group.Gruppe1.name
location            = azurerm_resource_group.Gruppe1.location
size                = "Standard_DS1_v2"
admin_ssh_key {
  username   = "azureuser"
  public_key = file("~/terraform2/Lage nettverk/.ssh/id_rsa.pub")
}
admin_username      = "azureuser"
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