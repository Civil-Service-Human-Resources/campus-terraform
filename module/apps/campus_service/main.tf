locals {
  app_rg_name = "rg-${local.app_name_env}"
  app_rg_location = "UK West"
  app_name     = "campus-service"
  app_name_env = "${local.app_name}-${var.env}"
  app_secrets = [
    "redis-access-token-host",
    "redis-access-token-port",
    "redis-access-token-password",
    "csl-learning-catalogue-client-id",
    "csl-learning-catalogue-client-secret",
    "csl-learning-catalogue-identity-url",
    "csl-learning-catalogue-access-token-id",
    "csl-learning-catalogue-base-url",
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

## Secrets

data "azurerm_key_vault_secret" "redis_access_token_host" {
  key_vault_id = data.azurerm_key_vault.secrets_kv.id
  name         = "redis-access-token-host"
}

data "azurerm_key_vault_secret" "redis_access_token_port" {
  key_vault_id = data.azurerm_key_vault.secrets_kv.id
  name         = "redis-access-token-port"
}

data "azurerm_key_vault_secret" "redis_access_token_password" {
  key_vault_id = data.azurerm_key_vault.secrets_kv.id
  name         = "redis-access-token-password"
}

data "azurerm_key_vault_secret" "csl_learning_catalogue_client_id" {
  key_vault_id = data.azurerm_key_vault.secrets_kv.id
  name         = "csl-learning-catalogue-client-id"
}

data "azurerm_key_vault_secret" "csl_learning_catalogue_client_secret" {
  key_vault_id = data.azurerm_key_vault.secrets_kv.id
  name         = "csl-learning-catalogue-client-secret"
}

data "azurerm_key_vault_secret" "csl_learning_catalogue_identity_url" {
  key_vault_id = data.azurerm_key_vault.secrets_kv.id
  name         = "csl-learning-catalogue-identity-url"
}

data "azurerm_key_vault_secret" "csl_learning_catalogue_access_token_id" {
  key_vault_id = data.azurerm_key_vault.secrets_kv.id
  name         = "csl-learning-catalogue-access-token-id"
}

data "azurerm_key_vault_secret" "csl_learning_catalogue_base_url" {
  key_vault_id = data.azurerm_key_vault.secrets_kv.id
  name         = "csl-learning-catalogue-base-url"
}

locals {
  secret_values = {
    REDIS_ACCESS_TOKEN_HOST = "@Microsoft.KeyVault(SecretUri=${var.secrets_kv_name};SecretName=redis-access-token-host;version=)"
    REDIS_ACCESS_TOKEN_PORT
    REDIS_ACCESS_TOKEN_PASSWORD
    CSL_LEARNING_CATALOGUE_CLIENT_ID
    CSL_LEARNING_CATALOGUE_CLIENT_SECRET
    CSL_LEARNING_CATALOGUE_IDENTITY_URL
    CSL_LEARNING_CATALOGUE_ACCESS_TOKEN_ID
    CSL_LEARNING_CATALOGUE_BASE_URL
  }
}

module "campus_service" {
  source                  = "../../web-service"
  rg_name                 = azurerm_resource_group.app_resource_group.name
  web_app_name            = local.app_name_env
  webapp_sku_tier         = var.sku_tier
  webapp_sku_name         = var.sku_size
  web_app_capacity        = var.sku_capacity
  port                    = 3000
  application_settings    = merge(var.app_settings, local.secret_values)
  container_reg_rg        = var.acr_rg
  container_reg_name      = var.acr_name
  start_command           = "node dist/main"
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
