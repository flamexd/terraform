resource "azurerm_public_ip" "iso-lb-public-ip" {
  name                = "iso-lb-public-ip"
  count               = var.iso_segment_count
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
}

resource "azurerm_lb" "iso" {
  name                = "${var.environment}-iso-lb"
  count               = var.iso_segment_count
  location            = var.location
  resource_group_name = var.resource_group_name

  frontend_ip_configuration {
    name                 = "frontendip"
    public_ip_address_id = azurerm_public_ip.iso-lb-public-ip[0].id
  }
}

resource "azurerm_lb_backend_address_pool" "iso-backend-pool" {
  name                = "iso-backend-pool"
  count               = var.iso_segment_count
  resource_group_name = var.resource_group_name
  loadbalancer_id     = azurerm_lb.iso[0].id
}

resource "azurerm_lb_probe" "iso-https-probe" {
  name                = "iso-https-probe"
  count               = var.iso_segment_count
  resource_group_name = var.resource_group_name
  loadbalancer_id     = azurerm_lb.iso[0].id
  protocol            = "TCP"
  port                = 443
}

resource "azurerm_lb_rule" "iso-https-rule" {
  name                = "iso-https-rule"
  count               = var.iso_segment_count
  resource_group_name = var.resource_group_name
  loadbalancer_id     = azurerm_lb.iso[0].id

  frontend_ip_configuration_name = "frontendip"
  protocol                       = "TCP"
  frontend_port                  = 443
  backend_port                   = 443

  backend_address_pool_id = azurerm_lb_backend_address_pool.iso-backend-pool[0].id
  probe_id                = azurerm_lb_probe.iso-https-probe[0].id
}

resource "azurerm_lb_probe" "iso-http-probe" {
  name                = "iso-http-probe"
  count               = var.iso_segment_count
  resource_group_name = var.resource_group_name
  loadbalancer_id     = azurerm_lb.iso[0].id
  protocol            = "TCP"
  port                = 80
}

resource "azurerm_lb_rule" "iso-http-rule" {
  name                = "iso-http-rule"
  count               = var.iso_segment_count
  resource_group_name = var.resource_group_name
  loadbalancer_id     = azurerm_lb.iso[0].id

  frontend_ip_configuration_name = "frontendip"
  protocol                       = "TCP"
  frontend_port                  = 80
  backend_port                   = 80

  backend_address_pool_id = azurerm_lb_backend_address_pool.iso-backend-pool[0].id
  probe_id                = azurerm_lb_probe.iso-http-probe[0].id
}

