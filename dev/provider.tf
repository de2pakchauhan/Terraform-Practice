terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.9.0"
    }
  }
}
provider "azurerm" {
  subscription_id = "36aeb4b35-3ab6-4c41-80ff-9573f82e735d"

  features {}
}



