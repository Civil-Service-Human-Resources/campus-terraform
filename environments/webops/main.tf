locals {
  tags = {
    platform = "campus"
    env = "webops"
  }
}

resource "azurerm_resource_group" "rg_webops" {
  name = "rg-campus-webops"
  location = "UK West"
}

module "acr" {
  source = "../../module/acr"
  acr_name = "acrCampus"
  acr_rg_name = azurerm_resource_group.rg_webops.name
  acr_rg_location = azurerm_resource_group.rg_webops.location
  tags = local.tags
}

module "deploy_group" {
  source = "../../module/ad_group"
  group_name = "Campus deploy group"
}
