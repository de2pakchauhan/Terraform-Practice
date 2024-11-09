terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.0.1"
    }
  }
}
provider "azurerm" {
  subscription_id = "5056c5ae-eefd-4968-8139-8c27a5d1303d"

  features {}
}



