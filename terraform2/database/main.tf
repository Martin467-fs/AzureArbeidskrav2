module "Nettverk" {
    source = "../Lage nettverk"
}

module "LoadBalancer" {
  source = "../LoadBalancer"
    publicIPnavnlb = module.Nettverk.PublicIPNavn
    privIPlb = module.Nettverk.PrivatIP
    subnetIDlb = module.Nettverk.subnetID
}

resource "azurerm_network_interface" "Interfacedb" {
  count = 2
  name = "${var.nicname}${count.index}"
  resource_group_name    = var.resource_group_name
  location               = var.resource_group_location

   ip_configuration {
    name = "${module.Nettverk.NetIntername}${count.index}"
    subnet_id = module.Nettverk.subnetID
    private_ip_address_allocation = "Static"
    private_ip_address = "${"10.0.0."}${count.index + 6}"
   }
}

resource "azurerm_linux_virtual_machine" "vmdb" {
  count = 2
  name = "${var.servername}${count.index}"
  resource_group_name    = var.resource_group_name
  location               = var.resource_group_location
  size = "Standard_B1s"
    admin_ssh_key {
    username   = var.usernamedb
    public_key = file("~/terraform2/.ssh/id_rsa.pub")
  }
  admin_username      = var.usernamedb
  admin_password      = var.passworddb

  network_interface_ids = [
    azurerm_network_interface.Interfacedb[count.index].id
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

resource "azurerm_virtual_machine_extension" "example" {
  count             = 2
  name                 = "${"mariadb"}${count.index}"
  virtual_machine_id   = azurerm_linux_virtual_machine.vmdb[count.index].id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"

  settings = <<SETTINGS
    {
        "commandToExecute": "sudo apt-get update && sudo apt-get install -y mariadb-server && sudo systemctl start mariadb && sudo systemctl enable mariadb"
    }
  SETTINGS
}

resource "azurerm_network_interface_backend_address_pool_association" "example1" {
  network_interface_id    = azurerm_network_interface.Interfacedb[0].id
  ip_configuration_name   = "testconfiguration1"
  backend_address_pool_id = module.LoadBalancer.bpepoolid
}
resource "azurerm_network_interface_backend_address_pool_association" "example2" {
  network_interface_id    = azurerm_network_interface.Interfacedb[1].id
  ip_configuration_name   = "testconfiguration2"
  backend_address_pool_id = module.LoadBalancer.bpepoolid
}

output "nicid" {
  value = azurerm_network_interface.Interfacedb[0].id
}

output "nicid2" {
  value = azurerm_network_interface.Interfacedb[1].id
}