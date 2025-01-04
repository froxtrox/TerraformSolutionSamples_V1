output "resource_group_name" {
  value = azurerm_resource_group.devuks-webrg.name
}

output "public_ip_name" {
  value = azurerm_public_ip.devuks-webip.name
}

output "network_security_group_name" {
  value = azurerm_network_security_group.devuks-webnsg.name
}

output "virtual_network_name" {
  value = azurerm_virtual_network.devuks-webvnet.name
}

output "subnet_name" {
  value = azurerm_subnet.devuks-websubnet.name
}

output "network_interface_name" {
  value = azurerm_network_interface.devuks-webni01.name
}

output "virtual_machine_name" {
  value = azurerm_windows_virtual_machine.devuks-webvm01.name
}

output "virtual_machine_computer_name" {
  value = azurerm_windows_virtual_machine.devuks-webvm01.computer_name
}
