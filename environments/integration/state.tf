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
  subscription_id = var.sub_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
}
