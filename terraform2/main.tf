# Configure the Azure Provider
provider "azurerm" {
    subscription_id = "a8d9ce0d-259f-474d-8d48-10f4d89ba7de"
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.resource_group_location
}

module "Nettverk" {
    depends_on = [azurerm_resource_group.rg]
    source = "./Lage nettverk"
}

module "Webserver" {
    depends_on = [module.Nettverk]
    source = "./Lage VM2"
}

module "Database" {
    depends_on = [module.LoadBalancer]
    source = "./database"
}

module "LoadBalancer" {
    depends_on = [module.Nettverk]
    source = "./LoadBalancer"

    publicIPnavnlb = module.Nettverk.PublicIPNavn
    privIPlb = module.Nettverk.PrivatIP
    subnetIDlb = module.Nettverk.subnetID
}
output "test" {
    value = module.Nettverk.subnetID
}