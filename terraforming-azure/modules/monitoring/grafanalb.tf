resource "azurerm_public_ip" "grafana-lb-public-ip" {
  name                    = "grafana-lb-public-ip"
  location                = var.location
  resource_group_name     = var.resource_group_name
  allocation_method       = "Static"
  sku                     = "Standard"
  idle_timeout_in_minutes = 30
}

resource "azurerm_lb" "grafana" {
  name                = "${var.env_name}-grafana-lb"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "frontendip"
    public_ip_address_id = azurerm_public_ip.grafana-lb-public-ip.id
  }
}

resource "azurerm_lb_backend_address_pool" "grafana-backend-pool" {
  name                = "grafana-backend-pool"
  resource_group_name = var.resource_group_name
  loadbalancer_id     = azurerm_lb.grafana.id
}

resource "azurerm_lb_probe" "grafana-http-probe" {
  name                = "grafana-http-probe"
  resource_group_name = var.resource_group_name
  loadbalancer_id     = azurerm_lb.grafana.id
  protocol            = "TCP"
  port                = 3000
}

resource "azurerm_lb_rule" "grafana-http-rule" {
  name                = "grafana-http-rule"
  resource_group_name = var.resource_group_name
  loadbalancer_id     = azurerm_lb.grafana.id

  frontend_ip_configuration_name = "frontendip"
  protocol                       = "TCP"
  frontend_port                  = 80
  backend_port                   = 3000
  idle_timeout_in_minutes        = 30

  backend_address_pool_id = azurerm_lb_backend_address_pool.grafana-backend-pool.id
  probe_id                = azurerm_lb_probe.grafana-http-probe.id
}