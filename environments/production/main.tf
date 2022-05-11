locals {
  env = "prod"
  kv_name = "kvCampusSecrets${local.env}"
  kv_rg_name = "rg-campus-kv-${local.env}"
  tags = {
    platform = "campus"
    env = local.env
  }
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
  secrets = []
  tags = local.tags
}

module "campus_ui" {
  source = "../../module/apps/campus_ui_prod"
  env = local.env
  tags = local.tags
}

module "campus_service" {
  source = "../../module/apps/campus_service_prod"
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
  content_cache_capacity = 1
  content_cache_family = "C"
  content_cache_sku = "Basic"
  tags = local.tags
}
