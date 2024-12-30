provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

terraform {
  backend "azurerm" {
    container_name       = "<CONTAINER_NAME>"
    key                  = "<KEY>"
    resource_group_name  = "<RESOURCE_GROUP_NAME>"
    storage_account_name = "<STORAGE_ACCOUNT_NAME>"
  }
}
 
resource "azurerm_resource_group" "VM01-staging-rg-uks" {
  name     = "${var.resource_prefix}-rg-uks"
  location = var.location
  tags = {
    "vm-group" = var.tags_vmgroup
  }
}

resource "azurerm_public_ip" "VM01-staging-pip-uks" {
  name                = "${var.resource_prefix}-ip"
  resource_group_name = azurerm_resource_group.VM01-staging-rg-uks.name
  location            = azurerm_resource_group.VM01-staging-rg-uks.location
  allocation_method   = "Static"

  tags = {
    vm-group = var.tags_vmgroup
  }

  ip_tags = {}
  zones   = ["1"]

}

resource "azurerm_network_security_group" "VM01-staging-nsg-uks" {
  name                = "${var.resource_prefix}-nsg"
  resource_group_name = azurerm_resource_group.VM01-staging-rg-uks.name
  location            = azurerm_resource_group.VM01-staging-rg-uks.location

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    vm-group = var.tags_vmgroup
  }

  security_rule {
    name                       = "RDP"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

}


resource "azurerm_network_interface_security_group_association" "example" {
  network_interface_id      = azurerm_network_interface.VM01-staging-ni-uks.id
  network_security_group_id = azurerm_network_security_group.VM01-staging-nsg-uks.id
}


resource "azurerm_virtual_network" "VM01-staging-vnet-uks" {
  name                = "${var.resource_prefix}-vnet"
  resource_group_name =azurerm_resource_group.VM01-staging-rg-uks.name
  location            = azurerm_resource_group.VM01-staging-rg-uks.location

  address_space = var.address_space

  tags = {
    "vm-group" = var.tags_vmgroup
  }
}


resource "azurerm_subnet" "VM01-staging-subnet-uks" {
  name                 = "default"
  resource_group_name  = azurerm_resource_group.VM01-staging-rg-uks.name
  virtual_network_name = azurerm_virtual_network.VM01-staging-vnet-uks.name
  address_prefixes     = var.subnet_prefix
}


resource "azurerm_network_interface" "VM01-staging-ni-uks" {
  name                = "${var.resource_prefix}_z1"
  location            = azurerm_resource_group.VM01-staging-rg-uks.location
  resource_group_name = azurerm_resource_group.VM01-staging-rg-uks.name

  lifecycle {
    create_before_destroy = true
  }

  ip_configuration {
    name                          = "ipconfig1"
    public_ip_address_id          = azurerm_public_ip.VM01-staging-pip-uks.id
    private_ip_address_allocation = "Dynamic"
    private_ip_address_version    = "IPv4"
    subnet_id                     = azurerm_subnet.VM01-staging-subnet-uks.id
  }

  tags = {
    vm-group = "VM01"
  }
  accelerated_networking_enabled = true
}

resource "azurerm_windows_virtual_machine" "VM01-staging-vm-uks" {
  name                = "${var.resource_prefix}-vm-uks"
  resource_group_name = azurerm_resource_group.VM01-staging-rg-uks.name
  location            = azurerm_resource_group.VM01-staging-rg-uks.location
  size                = var.vm_size
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  network_interface_ids = [
    azurerm_network_interface.VM01-staging-ni-uks.id,
  ]

  os_disk {
    caching              = var.vm_os_disk_caching
    storage_account_type = var.vm_os_disk_storage_account_type
  }

  source_image_reference {
    publisher = var.vm_source_image_publisher
    offer     = var.vm_source_image_offer
    sku       = var.vm_source_image_sku
    version   = var.vm_source_image_version
  }
}

 