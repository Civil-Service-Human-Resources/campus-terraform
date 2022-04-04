locals {
  env = "int"
  kv_name = "kvCampusSecrets${local.env}"
  kv_rg_name = "rg-campus-kv-${local.env}"
  tags = {
    platform = "campus"
    env = local.env
  }
  app_dns_zone_name = "integration.learn.civilservice.gov.uk"
  app_dns_zone_rg_name = "lpgdomain"
}

data "azurerm_container_registry" "acr" {
  name                = "acrCampus"
  resource_group_name = "rg-campus-webops"
}

module "monitoring" {
  source = "../../module/monitoring"
  env = local.env
  tags = local.tags
}

module "app_secrets_vault" {
  source = "../../module/keyvault"
  deploy_group_name = var.deploy_group_name
  kv_name = local.kv_name
  kv_rg_name = local.kv_rg_name
  tags = local.tags
}

module "campus_ui" {
  source = "../../module/apps/campus_ui"
  domain = local.app_dns_zone_name
  dns_zone_resource_group = local.app_dns_zone_rg_name
  env = local.env
  tags = local.tags
}

module "campus_service" {
  source = "../../module/apps/campus_service"
  depends_on = [
    module.app_secrets_vault
  ]
  env = local.env
  sku_tier = "Standard"
  sku_size = "S1"
  sku_capacity = 1
  secrets_kv_name = local.kv_name
  secrets_kv_rg_name = local.kv_rg_name
  app_settings = {"APPLICATIONINSIGHTS_CONNECTION_STRING": module.monitoring.appi_conn_string}
  acr_rg = data.azurerm_container_registry.acr.resource_group_name
  acr_name = data.azurerm_container_registry.acr.name
  app_dns_zone_name = local.app_dns_zone_name
  app_dns_zone_rg_name = local.app_dns_zone_rg_name
  content_cache_capacity = 1
  content_cache_family = "C"
  content_cache_sku = "Basic"
  tags = local.tags
}
