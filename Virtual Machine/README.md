# Terraform Azure VM Setup

## Overview
This terraform project scaffolds an azure virtual machine environment with network security configured.


## Architecture Diagram

```mermaid
graph TD;
  subgraph VMSolution_Resource_Group
    azurerm_virtual_network.VM01-staging-vnet-uks["Virtual Network"]
    azurerm_subnet.VM01-staging-subnet-uks["Subnet"]
    azurerm_public_ip.VM01-staging-pip-uks["Public IP"]
    azurerm_network_interface.VM01-staging-ni-uks["Network Interface"]
    azurerm_network_security_group.VM01-staging-nsg-uks["Network Security Group"]
    azurerm_network_interface_security_group_association.example["Network Interface Security Group Association"]
     azurerm_windows_virtual_machine.example["Windows Virtual Machine"]
  end

  azurerm_virtual_network.VM01-staging-vnet-uks --> azurerm_subnet.VM01-staging-subnet-uks
  azurerm_subnet.VM01-staging-subnet-uks --> azurerm_network_interface.VM01-staging-ni-uks
  azurerm_public_ip.VM01-staging-pip-uks --> azurerm_network_interface.VM01-staging-ni-uks
  azurerm_network_interface.VM01-staging-ni-uks --> azurerm_network_interface_security_group_association.example
  azurerm_network_security_group.VM01-staging-nsg-uks --> azurerm_network_interface_security_group_association.example
  azurerm_network_interface.VM01-staging-ni-uks --> azurerm_windows_virtual_machine.example
```

## Pre-requisite

Before you begin, ensure you have the following:

1. An active Azure subscription.
2. Terraform installed on your local machine. You can download it from [here](https://www.terraform.io/downloads.html).
3. Azure CLI installed on your local machine. You can download it from [here](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli).
4. Git installed on your local machine. You can download it from [here](https://git-scm.com/downloads).

## Installation

To be able to use this solution, follow these steps:

1. Clone the repository:
    ```sh
    git clone https://github.com/froxtrox/TerraformNetworkingSolutionSamples.git
    ```

2. Create a blob storage container for safe storage of the Terraform backend:

    Open a command line prompt with Azure CLI installed, and execute the following scripts:
    ```sh
    az group create -l <your_azure_location> -n <your_resource_group_name>
    az storage account create -n <your_storage_account_name> -g <your_resource_group_name>
    az storage container create -n <your_container_name> --account-name <your_storage_account_name>
    ```

3. Navigate to the project directory:
    ```sh
    cd TerraformNetworkingSolutionSamples/Virtual Machine
    ```

4. Configure the Terraform backend:

    Open the `main.tf` file in the project directory and populate the following section with your Azure storage details using the values from step 2:
    ```hcl
    terraform {
      backend "azurerm" {
        container_name       = "<CONTAINER_NAME>"
        key                  = "<KEY>"
        resource_group_name  = "<RESOURCE_GROUP_NAME>"
        storage_account_name = "<STORAGE_ACCOUNT_NAME>"
      }
    }
    ```
5. Configure the `terraform.tfvars` file to set the following values:

    ```hcl
    subscription_id = "<YOUR_SUBSCRIPTION_ID>"
    prefix          = "<RESOURCE_PREFIX>"
    tags_vmgroup    = "<TAGS_VM_GROUP>"
    location        = "<LOCATION>"
    admin_username  = "<ADMIN_USERNAME>"
    admin_password  = "<ADMIN_PASSWORD>"
    vm_size         = "<VM_SIZE>"
    os_disk_name    = "<OS_DISK_NAME>"
    ```

## Usage

1. Authenticate with Azure and initialize Terraform:
    ```sh
    az login
    terraform init
    ```

2. Plan and apply the Terraform configuration:
    ```sh
    terraform plan
    terraform apply
    ```
