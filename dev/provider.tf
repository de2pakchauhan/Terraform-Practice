terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.0.1"
    }
  }
}
provider "azurerm" {
  subscription_id = "419f9566-7081-4ef4-9f4c-1fafefc458a7"

  features {}
}



