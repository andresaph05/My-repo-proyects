variable "lngw_address_space" {
  description = "Lista de address spaces permitidos dentro de la vpn"
  type        = list(any)
}

variable "dns_servers" {
  description = "Servers DNS"
  type        = list(any)

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