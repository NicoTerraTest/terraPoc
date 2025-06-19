terraform {
  required_version = ">= 0.12"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.96"
    }
  }

  backend "azurerm" {
  }

}


provider "azurerm" {
  features {}
  subscription_id = "28b840cb-341d-43f8-8079-f7e295b7adac"
  alias           = "infranet"
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}
