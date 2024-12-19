resource "azurerm_network_interface" "Interfacedb" {
  count = 2
  name = "${var.nicname}${count.index}"
  resource_group_name    = var.resource_group_name
  location               = var.resource_group_location

   ip_configuration {
    name = "${var.Internamedb}${count.index}"
    subnet_id = var.subnetIDdb
    private_ip_address_allocation = "Static"
    private_ip_address = "${"10.0.0."}${count.index + 6}"
   }
}

resource "azurerm_storage_account" "mariadb" {
  name                     = var.storage_accountname
  resource_group_name      = var.resource_group_name
  location                = var.resource_group_location
  account_tier            = "Standard"
  account_replication_type = "LRS"
  #allow_blob_public_access = true
/*  blob_properties {
    container_delete_retention_policy {
      days = 7
    }

    delete_retention_policy {
      days = 7
    }
      # Allow public access
  }*/
}

resource "azurerm_storage_container" "install" {
  depends_on = [azurerm_storage_account.mariadb]
  name                  = "install"
  storage_account_name  = var.storage_accountname
  container_access_type = "private"
}

resource "azurerm_storage_blob" "install_script" {
  name                   = "install_mariadb.sh"
  storage_account_name   = var.storage_accountname
  storage_container_name = azurerm_storage_container.install.name
  type                   = "Block"
  source                 = "${path.module}/install_mariadb.sh"
}

resource "azurerm_linux_virtual_machine" "vmdb" {
  count = 2
  name = "${var.servername}${count.index}"
  resource_group_name    = var.resource_group_name
  location               = var.resource_group_location
  size = "Standard_B1s"
    admin_ssh_key {
    username   = var.usernamedb
    public_key = file("${path.root}/.ssh/id_rsa.pub")
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
    name                       = "AllowSQL"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3306"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
    }
}

# Associate the NSG with the NIC
resource "azurerm_network_interface_security_group_association" "nsg_association" {
count                     = 2
network_interface_id      = azurerm_network_interface.Interfacedb[count.index].id
network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_nat_gateway" "natgate" {
  name = "NATgatedb"
  location = var.resource_group_location
  resource_group_name = var.resource_group_name
  sku_name = "Standard"
}

resource "azurerm_nat_gateway_public_ip_association" "natassoci" {
  nat_gateway_id = azurerm_nat_gateway.natgate.id
  public_ip_address_id = var.publicIPnatid
}

resource "azurerm_subnet_nat_gateway_association" "natsubnet" {
  subnet_id      = var.subnetIDdb
  nat_gateway_id = azurerm_nat_gateway.natgate.id
}

resource "azurerm_virtual_machine_extension" "example" {
  depends_on = [azurerm_storage_container.install]
  count             = 2
  name                 = "${"mariadb"}${count.index}"
  virtual_machine_id   = azurerm_linux_virtual_machine.vmdb[count.index].id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"

  settings = <<SETTINGS
    {
      "fileUris": ["https://${var.storage_accountname}.blob.core.windows.net/install/install_mariadb.sh"],
      "commandToExecute": "sudo apt-get update && sudo apt-get install -y mariadb-server && sudo systemctl start mariadb && sudo systemctl enable mariadb && bash install_mariadb.sh"
    }
  SETTINGS

  protected_settings = <<PROTECTED_SETTINGS
    {
      "storageAccountName": "${var.storage_accountname}",
      "storageAccountKey": "${azurerm_storage_account.mariadb.primary_access_key}"
    }
  PROTECTED_SETTINGS
}

resource "azurerm_network_interface_backend_address_pool_association" "example" {
  count                   = 2
  network_interface_id    = azurerm_network_interface.Interfacedb[count.index].id
  ip_configuration_name   = "${var.Internamedb}${count.index}"
  backend_address_pool_id = var.bpepooliddb
}



output "nicid" {
  value = azurerm_network_interface.Interfacedb[0].id
}

output "nicid2" {
  value = azurerm_network_interface.Interfacedb[1].id
}

output "db_username" {
  value = azurerm_linux_virtual_machine.vmdb.admin_username
}
