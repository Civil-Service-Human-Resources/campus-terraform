terraform {
  required_version = "~> 0.13.0"
  backend "azurerm" {}
}

provider "azurerm" {
  version = "~> 2.0"
  features {}
}