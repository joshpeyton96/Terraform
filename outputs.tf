output "resource_group_name" {
  value = azurerm_resource_group.task2.name
}

output "public_ip_address" {
  value = azurerm_linux_virtual_machine.task2-vm.public_ip_address
}
 
