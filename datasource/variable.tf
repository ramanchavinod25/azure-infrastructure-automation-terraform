variable "resource_group_name" {
  type    = string
  default = "test-resource-group"
}

variable "storageaccountname" {
  type    = string
  default = "terraformsa20241104"
}

variable "tags" {
  type = map(string)
  default = {
    "Project"     = "SAANVIK IT"
    "Environment" = "Development"
  }
}

variable "virtual_network_name" {
  type    = string
  default = "test-virtualnetwork"
}

variable "subnet_name" {
  type    = string
  default = "default"
}

variable "pip_name" {
  type    = string
  default = "terraform-pip"
}

variable "nic_name" {
  type    = string
  default = "terraform-nic"
}

variable "nsg_name" {
  type    = string
  default = "terraform-nsg"
}

variable "virtual_machine_name" {
  type    = string
  default = "terraform-vm"
}

variable "virtual_machine_size" {
  type    = string
  default = "Standard_D2s_V3"
}

variable "adminUser" {
  type    = string
  default = "azureuser"
}

variable "keyvault_name" {
  type    = string
  default = "testkv123567"
}

variable "keyvault_Secret" {
  type    = string
  default = "VMPassword"
}