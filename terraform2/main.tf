# Configure the Azure Provider
provider "azurerm" {
    subscription_id = "00000000-0000-0000-0000-000000000000"
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
    webpublicIP = module.Nettverk.public_ip_address
    InterIDweb = module.Nettverk.netInterID
}

module "Database" {
    depends_on = [module.LoadBalancer]
    source = "./database"

    publicIPnavndb = module.Nettverk.PublicIPNavn
    privIPdb = module.Nettverk.PrivatIP
    subnetIDdb = module.Nettverk.subnetID
    Internamedb = module.Nettverk.NetIntername
    bpepooliddb = module.LoadBalancer.bpepoolid
    publicIPnatid = module.Nettverk.PublicIPNATgate
}

module "LoadBalancer" {
    depends_on = [module.Nettverk]
    source = "./LoadBalancer"

    privateIPnavnlb = module.Nettverk.PrivatIP_navn
    subnetIDlb = module.Nettverk.subnetID
}

output "publ_ipadd" {
    value = module.Nettverk.public_ip_address
}

output "db_username" {
    value = module.Database.db_username
}

output "admin_username {
    value = module.Webserver.vm_username
}