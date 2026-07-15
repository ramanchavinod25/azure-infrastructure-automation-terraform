# Terraform Data Sources

## Project Overview

This project demonstrates how to use Terraform Data Sources to retrieve information about existing Azure resources and use that information to deploy additional Azure infrastructure.

The project securely retrieves existing Azure resources such as a Resource Group, Virtual Network, Subnet, Azure Key Vault, and Key Vault Secret before provisioning new resources.

---

## Project Files

### datasource.tf

Retrieves information about existing Azure resources:

- Resource Group
- Virtual Network
- Subnet
- Azure Key Vault
- Azure Key Vault Secret

### main.tf

Uses the retrieved data to create:

- Storage Account
- Public IP
- Network Interface (NIC)
- Network Security Group (NSG)
- NSG Association
- Windows Virtual Machine
- Managed Disk
- Data Disk Attachment

Also configures the Azure Storage backend for storing the Terraform state file.

### variable.tf

Defines reusable input variables for the Terraform configuration.

### variable.auto.tfvars

Provides values for the variables used by the Data Sources and infrastructure deployment.

---

## Tools & Technologies

- Microsoft Azure
- Terraform
- AzureRM Provider (v4.0.0)
- Azure Key Vault
- Azure Storage Backend
- Azure CLI
- Visual Studio Code
- Git
- GitHub
- Azure DevOps

---

**Author:** Vinod
