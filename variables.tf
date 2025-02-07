variable "lngw_address_space" {
  description = "Lista de address spaces permitidos dentro de la vpn"
  type        = list(any)
}

variable "dns_servers" {
  description = "Servers DNS"
  type        = list(any)

}

variable "address_space" {
  description = "Address space de la red virtual"
  type        = string
  
}

variable "prefix_1" {
  description = "Prefix de la subred 1"
  type        = string
  
}

variable "prefix_2" {
  description = "Prefix de la subred 1"
  type        = string
  
}

variable "extrenal_prefix" {
  description = "Prefix de la subred 1"
  type        = string
  
}

variable "gw_address_public" {
  description = "Direccion publica del gateway"
  type        = string
  
}

variable "admin_password" {
  description = "Password de la maquina virtual"
  type        = string
  
}

locals {
  region = "eastus"
  environment = "Sub IAC"
  creator = "Terraform"
  team = "Telecom"

  tags = {
    Enviroment = local.environment
    Creator = local.creator
    Team = local.team
  }
}