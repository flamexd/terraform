output "pks-master-app-sec-group" {
  value = azurerm_application_security_group.pks-master.id
}

output "pks-api-app-sec-group" {
  value = azurerm_application_security_group.pks-api.id
}

# Subnets

output "pks_subnet_name" {
  value = azurerm_subnet.pks.name
}

output "pks_subnet_cidr" {
  value = azurerm_subnet.pks.address_prefix
}

output "pks_subnet_gateway" {
  value = cidrhost(azurerm_subnet.pks.address_prefix, 1)
}

output "services_subnet_name" {
  value = azurerm_subnet.pks_services.name
}

output "services_subnet_cidr" {
  value = azurerm_subnet.pks_services.address_prefix
}

output "services_subnet_gateway" {
  value = cidrhost(azurerm_subnet.pks_services.address_prefix, 1)
}

# Deprecated

output "pks_subnet_cidrs" {
  value = [azurerm_subnet.pks.address_prefix]
}

output "services_subnet_cidrs" {
  value = [azurerm_subnet.pks_services.address_prefix]
}

