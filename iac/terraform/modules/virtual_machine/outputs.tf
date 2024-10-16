output "private_ip_address" {
  value = azurerm_linux_virtual_machine.linux_virtual_machine.private_ip_address
  sensitive = true
}

output "linux_virtual_machine_name" {
  value = azurerm_linux_virtual_machine.linux_virtual_machine.name
}