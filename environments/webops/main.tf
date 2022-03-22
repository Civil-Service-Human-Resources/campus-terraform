resource "azurerm_resource_group" "rg_webops" {
  name = var.acr_rg_name
  location = "UK West"
}

module "acr" {
  source = "../../module/acr"
  acr_name = var.acr_name
  acr_rg_name = azurerm_resource_group.rg_webops.name
  acr_rg_location = azurerm_resource_group.rg_webops.location
}

module "deploy_group" {
  source = "../../module/ad_group"
  group_name = var.deploy_group_name
}
