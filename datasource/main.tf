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

  subscription_id = "2e28c82c-17d7-4303-b27a-4141b3d4088f"
}

# terraform backend
terraform {
  backend "azurerm" {
    resource_group_name  = "storage-resource-group" # Can be passed via `-backend-config=`"resource_group_name=<resource group name>"` in the `init` command.
    storage_account_name = "saanvikit"              # Can be passed via `-backend-config=`"storage_account_name=<storage account name>"` in the `init` command.
    container_name       = "tfstate"                # Can be passed via `-backend-config=`"container_name=<container name>"` in the `init` command.
    key                  = "data.terraform.tfstate" # Can be passed via `-backend-config=`"key=<blob key name>"` in the `init` command.
  }
}

# Create a storage account
resource "azurerm_storage_account" "sa" {
  name                     = var.storageaccountname
  resource_group_name      = data.azurerm_resource_group.rg1.name
  location                 = data.azurerm_resource_group.rg1.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  tags = var.tags
}

# Create a public ip
resource "azurerm_public_ip" "pip" {
  name                = var.pip_name
  resource_group_name = data.azurerm_resource_group.rg1.name
  location            = data.azurerm_resource_group.rg1.location
  allocation_method   = "Static"

  tags = var.tags
}

# Create a NIC
resource "azurerm_network_interface" "nic" {
  name                = var.nic_name
  location            = data.azurerm_resource_group.rg1.location
  resource_group_name = data.azurerm_resource_group.rg1.name

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = data.azurerm_subnet.snet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.pip.id
  }

  tags = var.tags
}

# Create a NSG 
resource "azurerm_network_security_group" "nsg" {
  name                = var.nsg_name
  location            = data.azurerm_resource_group.rg1.location
  resource_group_name = data.azurerm_resource_group.rg1.name

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
  subnet_id                 = data.azurerm_subnet.snet.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

# Create a windows VM
resource "azurerm_windows_virtual_machine" "vm" {
  name                = var.virtual_machine_name
  resource_group_name = data.azurerm_resource_group.rg1.name
  location            = data.azurerm_resource_group.rg1.location
  size                = var.virtual_machine_size
  admin_username      = var.adminUser
  admin_password      = data.azurerm_key_vault_secret.example.value
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
  location             = data.azurerm_resource_group.rg1.location
  resource_group_name  = data.azurerm_resource_group.rg1.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = 10
}

resource "azurerm_virtual_machine_data_disk_attachment" "example" {
  managed_disk_id    = azurerm_managed_disk.disk.id
  virtual_machine_id = azurerm_windows_virtual_machine.vm.id
  lun                = "10"
  caching            = "ReadWrite"
}