resource "azurerm_resource_group" "rg-vpn-test" {
  name     = "vpn-test"
  location = local.region
  tags = local.tags
}

resource "azurerm_virtual_network" "vnet-vpn-test" {
  name                = "vnet-vpn"
  location            = azurerm_resource_group.rg-vpn-test.location
  resource_group_name = azurerm_resource_group.rg-vpn-test.name
  address_space       = ["192.168.200.0/24"]
  dns_servers         = var.dns_servers
}

resource "azurerm_subnet" "subnet_gw" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.rg-vpn-test.name
  virtual_network_name = azurerm_virtual_network.vnet-vpn-test.name
  address_prefixes     = ["192.168.200.0/26"]
}

resource "azurerm_subnet" "subnet_lan" {
  name                 = "Subnet-1"
  resource_group_name  = azurerm_resource_group.rg-vpn-test.name
  virtual_network_name = azurerm_virtual_network.vnet-vpn-test.name
  address_prefixes     = ["192.168.200.64/26"]
}

resource "azurerm_network_security_group" "nsg_to_vnet_vpn" {
  name                = "VM_Protect"
  location            = azurerm_resource_group.rg-vpn-test.location
  resource_group_name = azurerm_resource_group.rg-vpn-test.name


##### SOLO PARA FINES EDUCACTIVOS y PRACTICOS POR DEFECTO SE CREA UNA REGLA DE SEGURIDAD QUE PERMITE TODO EL TRAFICO
  security_rule {
    name                       = "RDP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "192.168.250.0/24"
    destination_address_prefix = "192.168.200.64/26"
  }
  security_rule {
    name                       = "ICMP"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Icmp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "192.168.250.0/24"
    destination_address_prefix = "192.168.200.64/26"
  }

}

resource "azurerm_subnet_network_security_group_association" "nsg_to_subnet" {
  subnet_id                 = azurerm_subnet.subnet_lan.id
  network_security_group_id = azurerm_network_security_group.nsg_to_vnet_vpn.id
}


resource "azurerm_network_interface" "nic_vm_windows" {
  name                = "nic_vm_windows"
  location            = azurerm_resource_group.rg-vpn-test.location
  resource_group_name = azurerm_resource_group.rg-vpn-test.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet_lan.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "example" {
  name                = "vm-windows-test"
  resource_group_name = azurerm_resource_group.rg-vpn-test.name
  location            = azurerm_resource_group.rg-vpn-test.location
  size                = "Standard_F2"
  admin_username      = "xxxxxxxx"
  admin_password      = var.admin_password
  network_interface_ids = [
    azurerm_network_interface.nic_vm_windows.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}

resource "azurerm_public_ip" "public_ip_test" {
  name                = "public-ip-vpn-test"
  location            = azurerm_resource_group.rg-vpn-test.location
  resource_group_name = azurerm_resource_group.rg-vpn-test.name
  allocation_method = "Dynamic"
  
}

resource "azurerm_virtual_network_gateway" "vngw_test" {
  name                = "vnge_test_forti"
  location            = azurerm_resource_group.rg-vpn-test.location
  resource_group_name = azurerm_resource_group.rg-vpn-test.name

  type     = "Vpn"
  vpn_type = "RouteBased"

  active_active = false
  enable_bgp    = false
  sku           = "Basic"

  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.public_ip_test.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.subnet_gw.id
  }
}


resource "azurerm_local_network_gateway" "lngw_test" {
  name                = "lngw_test_forti"
  resource_group_name = azurerm_resource_group.rg-vpn-test.name
  location            = azurerm_resource_group.rg-vpn-test.location
  gateway_address     = var.gw_address_public
  address_space       = var.lngw_address_space
}


resource "azurerm_virtual_network_gateway_connection" "onpremise_forti" {
  name                = "az_to_forti"
  location            = azurerm_resource_group.rg-vpn-test.location
  resource_group_name = azurerm_resource_group.rg-vpn-test.name

  type                       = "IPsec"
  virtual_network_gateway_id = azurerm_virtual_network_gateway.vngw_test.id
  local_network_gateway_id   = azurerm_local_network_gateway.lngw_test.id

  shared_key = "xxxxxxxxxx"
}