module "Nettverk" {
    source = "../Lage nettverk"
}

resource "azurerm_ssh_public_key" "example" {
  name                = var.ssh_public_key_name
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  public_key          = file("~/terraform2/.ssh/id_rsa.pub")
}

# Create a public IP address
resource "azurerm_public_ip" "publicIP" {
name                = module.Nettverk.PublicIPNavn
location            = var.resource_group_location
resource_group_name = var.resource_group_name
allocation_method   = "Static"
}

# Create a virtual machine
resource "azurerm_linux_virtual_machine" "vm" {
  name                = var.virtual_machine_name
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  size                = var.virtual_machine_size
  admin_ssh_key {
    username   = var.username
    public_key = file("~/terraform2/.ssh/id_rsa.pub")
  }
  admin_username      = var.username
  admin_password      = var.password

  network_interface_ids = [
    module.Nettverk.netInterID
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

# Enable virtual machine extension and install Apache2
resource "azurerm_virtual_machine_extension" "my_vm_extension" {
  name                 = "Apache2"
  virtual_machine_id   = azurerm_linux_virtual_machine.vm.id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"

  settings = <<SETTINGS
 {
  "commandToExecute": "sudo apt-get update && sudo apt-get install apache2 -y && sudo systemctl restart apache2"
 }
SETTINGS
}

# Output the public IP of the virtual machine
output "public_ip_address" {
  value = azurerm_public_ip.publicIP.ip_address
}

output "PublicIPID" {
    value = azurerm_public_ip.publicIP.id
}

