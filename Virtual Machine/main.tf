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

resource "azurerm_resource_group" "devuks-webrg" {
  name     = "${var.resource_prefix}rg"
  location = var.location

  tags = {
    "vm-group" = var.tags_vmgroup
  }
}

resource "azurerm_public_ip" "devuks-webip" {
  name                = "${var.resource_prefix}ip"
  resource_group_name = azurerm_resource_group.devuks-webrg.name
  location            = azurerm_resource_group.devuks-webrg.location
  allocation_method   = "Static"

  tags = {
    vm-group = var.tags_vmgroup
  }

  ip_tags = {}
  zones   = ["1"]
}

resource "azurerm_network_security_group" "devuks-webnsg" {
  name                = "${var.resource_prefix}nsg"
  resource_group_name = azurerm_resource_group.devuks-webrg.name
  location            = azurerm_resource_group.devuks-webrg.location

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

resource "azurerm_virtual_network" "devuks-webvnet" {
  name                = "${var.resource_prefix}vnet"
  resource_group_name = azurerm_resource_group.devuks-webrg.name
  location            = azurerm_resource_group.devuks-webrg.location

  address_space = var.address_space

  tags = {
    "vm-group" = var.tags_vmgroup
  }
}

resource "azurerm_subnet" "devuks-websubnet" {
  name                 = "default"
  resource_group_name  = azurerm_resource_group.devuks-webrg.name
  virtual_network_name = azurerm_virtual_network.devuks-webvnet.name
  address_prefixes     = var.subnet_prefix
}

resource "azurerm_network_interface" "devuks-webni01" {
  name                = "${var.resource_prefix}ni01"
  location            = azurerm_resource_group.devuks-webrg.location
  resource_group_name = azurerm_resource_group.devuks-webrg.name

  lifecycle {
    create_before_destroy = true
  }

  ip_configuration {
    name                          = "ipconfig1"
    public_ip_address_id          = azurerm_public_ip.devuks-webip.id
    private_ip_address_allocation = "Dynamic"
    private_ip_address_version    = "IPv4"
    subnet_id                     = azurerm_subnet.devuks-websubnet.id
  }

  tags = {
    vm-group = var.tags_vmgroup
  }
  accelerated_networking_enabled = true
}

resource "azurerm_network_interface_security_group_association" "devuks-ni01nsgassoc" {
  network_interface_id      = azurerm_network_interface.devuks-webni01.id
  network_security_group_id = azurerm_network_security_group.devuks-webnsg.id
}

resource "azurerm_windows_virtual_machine" "devuks-webvm01" {
  name                = "${var.resource_prefix}vm01"
  resource_group_name = azurerm_resource_group.devuks-webrg.name
  location            = azurerm_resource_group.devuks-webrg.location
  size                = var.vm_size
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  network_interface_ids = [
    azurerm_network_interface.devuks-webni01.id,
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

