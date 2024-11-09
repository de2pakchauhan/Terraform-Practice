resource "azurerm_public_ip" "lb_publicip" {
  name                = "PublicIPForLB"
  location            = "eastasia"
  resource_group_name = "dc_res"
  allocation_method   = "Static"
}

resource "azurerm_lb" "loadbalancer" {
  name                = "TestLoadBalancer"
  location            = "eastasia"
  resource_group_name = "dc_res"

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.lb_publicip.id
  }
}

resource "azurerm_lb_rule" "lb_rule" {
  loadbalancer_id                = azurerm_lb.loadbalancer.id
  name                           = "LBRule"
  protocol                       = "Tcp"
  frontend_port                  = 8080
  backend_port                   = 80
  frontend_ip_configuration_name = "PublicIPAddress"
  backend_address_pool_ids = [azurerm_lb_backend_address_pool.backend_pool.id]
  probe_id = azurerm_lb_probe.lb_probe.id
}

resource "azurerm_lb_probe" "lb_probe" {
  loadbalancer_id = azurerm_lb.loadbalancer.id
  name            = "LBprobe"
  protocol        = "Http"
  port            = 80
  request_path    = "/"
}

resource "azurerm_lb_backend_address_pool" "backend_pool" {
  loadbalancer_id = azurerm_lb.loadbalancer.id
  name            = "BackEndAddressPool"
}

data "azurerm_network_interface" "network_interface_1" {
  name                = "dc-vm1-nic"
  resource_group_name = "dc_res"
}

data "azurerm_network_interface" "network_interface_2" {
  name                = "dc-vm2-nic"
  resource_group_name = "dc_res"
}

resource "azurerm_network_interface_backend_address_pool_association" "vm1_lb_association" {
  network_interface_id    = data.azurerm_network_interface.network_interface_1.id
  ip_configuration_name   = "dcvm1ip"
  backend_address_pool_id = azurerm_lb_backend_address_pool.backend_pool.id
}

resource "azurerm_network_interface_backend_address_pool_association" "vm2_lb_association" {
  network_interface_id    =data.azurerm_network_interface.network_interface_2.id
  ip_configuration_name   = "dcvm2ip"
  backend_address_pool_id = azurerm_lb_backend_address_pool.backend_pool.id
}