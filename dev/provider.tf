terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.9.0"
    }
  }
}
provider "azurerm" {
  subscription_id = "37c760d9-a81e-41e2-beb8-b9f0fd0a4615"

  features {}
}



