output "public_ip_gw" {
  description = "Ip publica para VNGW"
  value = azurerm_public_ip.public_ip_test.ip_address
}