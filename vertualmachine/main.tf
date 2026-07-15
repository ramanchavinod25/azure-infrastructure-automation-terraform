# Azure Provider source and version being used
# Terraform provider version
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.0.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
provider "azurerm" {
  features {}
}
 
}



# Create a resource group
resource "azurerm_resource_group" "rg1" {
  name     = var.resource_group_name_01
  location = var.location
  tags     = var.tags
}

resource "azurerm_resource_group" "rg2" {
  name     = var.resource_group_name_02
  location = var.location
  tags     = var.tags
}

# Create a storage account
resource "azurerm_storage_account" "sa" {
  name                     = var.storageaccountname
  resource_group_name      = azurerm_resource_group.rg1.name
  location                 = azurerm_resource_group.rg1.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  tags = var.tags
}

# Create a Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = var.virtual_network_name
  address_space       = var.virtual_network_address
  location            = azurerm_resource_group.rg2.location
  resource_group_name = azurerm_resource_group.rg2.name
  tags                = var.tags
}

# Create a Subnet under the VNET
resource "azurerm_subnet" "snet" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.rg2.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.subnet_address
}

# Create a public ip
resource "azurerm_public_ip" "pip" {
  name                = var.pip_name
  resource_group_name = azurerm_resource_group.rg1.name
  location            = azurerm_resource_group.rg1.location
  allocation_method   = "Static"

  tags = var.tags
}

# Create a NIC
resource "azurerm_network_interface" "nic" {
  name                = var.nic_name
  location            = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = azurerm_subnet.snet.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = var.tags
}

# Create a NSG 
resource "azurerm_network_security_group" "nsg" {
  name                = var.nsg_name
  location            = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name

  security_rule {
    name                       = "RDP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "HTTP"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = var.tags
}

# NSG and Subnet Association
resource "azurerm_subnet_network_security_group_association" "example" {
  subnet_id                 = azurerm_subnet.snet.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

# Create a windows VM
resource "azurerm_windows_virtual_machine" "vm" {
  name                = var.virtual_machine_name
  resource_group_name = azurerm_resource_group.rg1.name
  location            = azurerm_resource_group.rg1.location
  size                = var.virtual_machine_size
  admin_username      = var.adminUser
  admin_password      = var.adminPassword
  network_interface_ids = [
    azurerm_network_interface.nic.id,
  ]

  os_disk {
    name                 = "${var.virtual_machine_name}-osdisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-Datacenter"
    version   = "latest"
  }
}

resource "azurerm_managed_disk" "disk" {
  name                 = "${var.virtual_machine_name}-disk1"
  location             = azurerm_resource_group.rg1.location
  resource_group_name  = azurerm_resource_group.rg1.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = 10
}

resource "azurerm_virtual_machine_data_disk_attachment" "vm-data-disk" {
  managed_disk_id    = azurerm_managed_disk.disk.id
  virtual_machine_id = azurerm_windows_virtual_machine.vm.id
  lun                = "10"
  caching            = "ReadWrite"
}
