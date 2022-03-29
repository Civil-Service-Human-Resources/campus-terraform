terraform {
  required_version = "~> 0.13.0"
  required_providers {

    azuread = {
      version = "~> 2.15.0"
    }
  }
  backend "azurerm" {}
}

provider "azurerm" {
  version = "~> 2.94"
  features {}
}
