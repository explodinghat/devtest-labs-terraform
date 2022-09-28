terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.24.0"
    }
  }
}

provider "azurerm" {
  features {}
}
resource "azurerm_resource_group" "devtest-fromterraform-rg" {
  name     = "devtest-fromterraform-rg"
  location = "UK West"
}

resource "azurerm_dev_test_lab" "dev" {
  name                = "devtest-fromterraform"
  location            = azurerm_resource_group.devtest-fromterraform-rg.location
  resource_group_name = azurerm_resource_group.devtest-fromterraform-rg.name

  tags = {
    "Terraform" = "true"
  }
}

resource "azurerm_dev_test_virtual_network" "devtest-fromterraform-vnet" {
  name                = "devtest-fromterraform-vnet"
  lab_name            = azurerm_dev_test_lab.dev.name
  resource_group_name = azurerm_resource_group.devtest-fromterraform-rg.name

  subnet {
    use_public_ip_address           = "Allow"
    use_in_virtual_machine_creation = "Allow"
  }
}

resource "azurerm_dev_test_policy" "devtest-fromterraform-policy" {
  name                = "LabVmCount"
  policy_set_name     = "default"
  lab_name            = azurerm_dev_test_lab.dev.name
  resource_group_name = azurerm_resource_group.devtest-fromterraform-rg.name
  fact_data           = ""
  threshold           = "999"
  evaluator_type      = "MaxValuePolicy"

  tags = {
    "Acceptance" = "Test"
  }
}

