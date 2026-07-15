variable "resource_group_name_01" {
  type    = string
  default = "terraform-resource-group-01"
}

variable "resource_group_name_02" {
  type    = string
  default = "terraform-resource-group-02"
}

variable "location" {
  type    = string
  default = "eastus"
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
  default = "terraform-vnet-01"
}

variable "virtual_network_address" {
  type    = list(string)
  default = ["10.0.0.0/24"]
}

variable "subnet_name" {
  type    = string
  default = "terraform-subnet"
}

variable "subnet_address" {
  type    = list(string)
  default = ["10.0.0.0/24"]
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
  default = "Standard_B1s"
}

variable "adminUser" {
  type    = string
  default = "vinod"
}

variable "adminPassword" {
  description = "Administrator password"
  type        = string
  sensitive   = true
}
