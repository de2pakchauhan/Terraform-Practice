terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.9.0"
    }
  }
}
provider "azurerm" {
  subscription_id = variable.azure_subscription_id

  features {}
}



