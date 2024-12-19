# Load Balancer
resource "azurerm_lb" "lb" {
  name                = var.load_balancer_name
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = var.privateIPnavnlb
    private_ip_address = var.privIPlb
    subnet_id          = var.subnetIDlb
  }
}

resource "azurerm_lb_backend_address_pool" "bpepool" {
  loadbalancer_id     = azurerm_lb.lb.id
  name                = var.BackEnd_AddressPool_Name
}

resource "azurerm_lb_probe" "probe" {
  loadbalancer_id     = azurerm_lb.lb.id
  name                = "tcp-probe"
  protocol            = "Tcp"
  port                = 3306
}

resource "azurerm_lb_rule" "lb_rule" {
  loadbalancer_id                = azurerm_lb.lb.id
  name                           = "LBRule"
  protocol                       = "Tcp"
  frontend_port                  = 3306
  backend_port                   = 3306
  frontend_ip_configuration_name  = var.privateIPnavnlb
  backend_address_pool_ids      = [azurerm_lb_backend_address_pool.bpepool.id]
  probe_id                     = azurerm_lb_probe.probe.id
}

/*
resource "azurerm_lb_outbound_rule" "lb_outbound_rule" {
  loadbalancer_id     = azurerm_lb.lb.id
  name                = "LBOUT"
  protocol            = "Tcp"
  backend_address_pool_id = azurerm_lb_backend_address_pool.bpepool.id
  frontend_ip_configuration {
    name = var.privateIPnavnlb
  }
}
*/

output "bpepoolid" {
  value = azurerm_lb_backend_address_pool.bpepool.id
}

