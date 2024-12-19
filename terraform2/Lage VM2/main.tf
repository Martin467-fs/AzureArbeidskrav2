resource "azurerm_ssh_public_key" "example" {
  name                = var.ssh_public_key_name
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  public_key          = file("${path.root}/.ssh/id_rsa.pub")
}

# Create a virtual machine
resource "azurerm_linux_virtual_machine" "vm" {
  name                = var.virtual_machine_name
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  size                = var.virtual_machine_size
  admin_ssh_key {
    username   = var.username
    public_key = file("${path.root}/.ssh/id_rsa.pub")
  }
  admin_username      = var.username
  admin_password      = var.password

  network_interface_ids = [
    var.InterIDweb
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

  provisioner "file" {
  source      = "${path.root}/Lage VM2/000-default.conf"
  destination = "/home/${var.username}/000-default.conf"

  connection {
    type = "ssh"
    host = var.webpublicIP
    user = var.username
    private_key = file("${path.root}/.ssh/id_rsa")
  }
  }

  provisioner "file" {
  source      = "${path.root}/Lage VM2/index.py"
  destination = "/home/${var.username}/index.py"

    connection {
    type = "ssh"
    host = var.webpublicIP
    user = var.username
    private_key = file("${path.root}/.ssh/id_rsa")
    }
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
  "commandToExecute": "sudo apt-get update && sudo apt-get install apache2 -y && sudo apt-get install -y python3-pymysql && sudo a2dismod mpm_event && sudo a2enmod mpm_prefork && sudo a2enmod cgi && sudo mv /home/${var.username}/index.py /var/www/html/index.py && sudo rm /etc/apache2/sites-available/000-default.conf && sudo mv /home/${var.username}/000-default.conf /etc/apache2/sites-available/000-default.conf && sudo systemctl restart apache2 && sudo chmod +x /var/www/html/index.py"
 }
SETTINGS
}

output "vm_username" {
  value = azurerm_linux_virtual_machine.vm.admin_username
}