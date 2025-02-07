variable "lngw_address_space" {
  description = "Lista de address spaces permitidos dentro de la vpn"
  type        = list(any)
}

variable "dns_servers" {
  description = "Servers DNS"
  type        = list(any)

}

variable "address_space" {
  description = "Address space de la vnet"
  type        = list(string)
  
}

variable "address_prefixes" {
  description = "Address prefixes de las subnets"
  type        = list(string)
  
}

variable "source_address_prefix" {
  description = "Address prefixes de las subnets"
  type        = string
}

variable "destination_address_prefix" {
  description = "Address prefixes de las subnets"
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