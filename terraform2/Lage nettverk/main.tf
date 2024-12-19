resource "azurerm_virtual_network" "Nettverk" {
name                = var.virtual_network_name
address_space       = ["10.0.0.0/24"]
location            = var.resource_group_location
resource_group_name = var.resource_group_name
}

resource "azurerm_subnet" "Subnet" {
name                 = var.subnet_name
resource_group_name  = var.resource_group_name
virtual_network_name = azurerm_virtual_network.Nettverk.name
address_prefixes     = ["10.0.0.0/26"]
}
  
resource "azurerm_network_interface" "Interface" {
name                = var.network_interface_name
location            = var.resource_group_location
resource_group_name = var.resource_group_name

 ip_configuration {
   name                          = var.ip_configuration_name
   subnet_id                     = azurerm_subnet.Subnet.id
   private_ip_address_allocation = "Static"
   private_ip_address            = "10.0.0.5"
   public_ip_address_id          = azurerm_public_ip.publicIP.id

 }
}

# Create a public IP address
resource "azurerm_public_ip" "publicIP" {
name                = var.public_ip_name
location            = var.resource_group_location
resource_group_name = var.resource_group_name
allocation_method   = "Static"
}

resource "azurerm_public_ip" "publicIPnat" {
name                = var.public_ip_name_nat
location            = var.resource_group_location
resource_group_name = var.resource_group_name
allocation_method   = "Static"
}

# Create a network security group and rules
resource "azurerm_network_security_group" "nsg" {
name                = var.network_security_group_name
location            = var.resource_group_location
resource_group_name = var.resource_group_name

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
network_interface_id      = azurerm_network_interface.Interface.id
network_security_group_id = azurerm_network_security_group.nsg.id
}


output "subnetID" {
    value = azurerm_subnet.Subnet.id
}

output "subnet_prefix" {
  value = azurerm_subnet.Subnet.address_prefixes
}

output "NetIntername" {
    value = var.network_interface_name
}

output "IPconfig_navn" {
    value = var.ip_configuration_name
}

output "PublicIPNavn" {
    value = var.public_ip_name
}

output "PrivatIP_navn" {
  value = var.private_ip_navnlb
}

output "netInterID" {
    value = azurerm_network_interface.Interface.id
}

output "vnetID" {
    value = azurerm_virtual_network.Nettverk.id
}

output "PrivatIP" {
  value = azurerm_network_interface.Interface.private_ip_address
}

output "PublicIPNATgate" {
  value = azurerm_public_ip.publicIPnat.id
}

# Output the public IP of the virtual machine
output "public_ip_address" {
  value = azurerm_public_ip.publicIP.ip_address
}