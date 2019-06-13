resource "azurerm_dns_a_record" "monitoring" {
  name                = "monitoring"
  zone_name           = var.dns_zone_name
  resource_group_name = var.resource_group_name
  ttl                 = "60"
  records             = [azurerm_public_ip.grafana-lb-public-ip.ip_address]
}