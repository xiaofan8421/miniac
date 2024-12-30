
output "instance_ip_pair" {
  description = "Private/Public IP Pair of the Azure instance"
  value = {
    (azurerm_virtual_machine.example.name) = {
      private_ip = azurerm_network_interface.example.private_ip_address
      public_ip  = azurerm_public_ip.example.ip_address
    }
  }
}