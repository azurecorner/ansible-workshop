output "resource_group_name" {
  value = azurerm_resource_group.resource_group.name
}

# output "public_ip_address" {
#   value = azurerm_linux_virtual_machine.linux_virtual_machine
#   sensitive = true
# }