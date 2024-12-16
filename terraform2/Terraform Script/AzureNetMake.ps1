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