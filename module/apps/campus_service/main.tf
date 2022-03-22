locals {
  app_rg_name = "rg-${local.app_name_env}"
  app_rg_location = "UK West"
  app_name     = "campus-service"
  app_name_env = "${local.app_name}-${var.env}"
  app_secrets = [
    "FILE_STORE_ACCESS_KEY",
    "FILE_STORE_ACCOUNT_NAME",
    "FILE_STORE_CONTAINER_NAME",
    "CONTENT_CACHE_HOST",
    "CONTENT_CACHE_PORT",
    "CONTENT_CACHE_PASSWORD",
    "CSL_CLIENT_ID",
    "CSL_CLIENT_SECRET",
    "CSL_AUTH_URL",
    "CSL_CATALOGUE_URL",
    "CSL_FRONTEND_URL"
  ]
}

resource "azurerm_resource_group" "app_resource_group" {
  name     = local.app_rg_name
  location = local.app_rg_location
  tags     = var.tags
}

data "azurerm_key_vault" "secrets_kv" {
  name                = var.secrets_kv_name
  resource_group_name = var.secrets_kv_rg_name
}

resource "azurerm_key_vault_access_policy" "app_kv_ap" {
  key_vault_id = data.azurerm_key_vault.secrets_kv.id
  tenant_id    = module.campus_service.managed_identity_tenant_id
  object_id    = module.campus_service.managed_identity_object_id
  secret_permissions = [
    "Get",
    "List", "Set", "Delete", "Recover", "Restore", "Purge"
  ]
}

resource "azurerm_key_vault_secret" "app_secrets" {
  key_vault_id = data.azurerm_key_vault.secrets_kv.id
  for_each     = toset(local.app_secrets)
  name         = lower(replace(each.key, "_", "-"))
  value        = ""
  tags         = var.tags
}

locals {
  secret_values = { for v in toset(local.app_secrets) : v => "@Microsoft.KeyVault(VaultName=${var.secrets_kv_name};SecretName=${lower(replace(v, "_", "-"))})" }
}

module "campus_service" {
  source                  = "../../web-service"
  rg_name                 = azurerm_resource_group.app_resource_group.name
  web_app_name            = local.app_name_env
  webapp_sku_tier         = var.sku_tier
  webapp_sku_name         = var.sku_size
  web_app_capacity        = var.sku_capacity
  docker_image            = "${local.app_name}/${var.docker_tag_env}"
  application_settings    = merge(var.app_settings, local.secret_values)
  container_reg_rg        = var.acr_rg
  container_reg_name      = var.acr_name
  docker_tag              = var.campus_service_docker_tag
  start_command           = "npm run start:prod"
  app_domain_prefix       = local.app_name
  domain                  = var.app_dns_zone_name
  dns_zone_resource_group = var.app_dns_zone_rg_name
  tags                    = var.tags
  app_service_rg_location = local.app_rg_location
  app_service_rg_name = local.app_rg_name
}

## filestore

resource "azurerm_storage_account" "storage_acc" {
  name                     = "campus${var.env}"
  account_replication_type = "LRS"
  account_tier             = "Standard"
  location                 = azurerm_resource_group.app_resource_group.location
  resource_group_name      = azurerm_resource_group.app_resource_group.name

  tags = var.tags
}


resource "azurerm_storage_container" "storage_container" {
  name                  = "sc-${local.app_name_env}"
  storage_account_name  = azurerm_storage_account.storage_acc.name
  container_access_type = "private"
}

## Redis content cache

#resource "azurerm_redis_cache" "cache" {
#  name                = "redis-content-${local.app_name_env}"
#  location                 = azurerm_resource_group.app_resource_group.location
#  resource_group_name      = azurerm_resource_group.app_resource_group.name
#  capacity   = var.content_cache_capacity
#  family     = var.content_cache_family
#  sku_name        = var.content_cache_sku
#  enable_non_ssl_port = false
#  minimum_tls_version = "1.2"
#  tags = var.tags
#}
