terraform {
  required_version = "~> 0.13.0"
  required_providers {
    azurerm = {
      version = "~> 2.94"
      features = {}
    }

    azuread = {
      version = "~> 2.15.0"
    }
  }
  backend "azurerm" {}
}
