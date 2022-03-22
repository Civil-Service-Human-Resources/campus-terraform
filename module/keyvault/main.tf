resource "azurerm_resource_group" "kv_rg" {
  name     = var.kv_rg_name
  location = "UK West"
  tags     = var.tags
}

data "azuread_group" "secure_dev_group" {
  display_name     = var.deploy_group_name
  security_enabled = true
}

data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "kv" {
  name                = var.kv_name
  location            = azurerm_resource_group.kv_rg.location
  resource_group_name = azurerm_resource_group.kv_rg.name
  sku_name            = "standard"
  tenant_id           = data.azurerm_client_config.current.tenant_id

  tags = var.tags
}

resource "azurerm_key_vault_access_policy" "app_kv_ap" {
  key_vault_id = azurerm_key_vault.kv.id
  object_id = data.azuread_group.secure_dev_group.object_id
  tenant_id = data.azurerm_client_config.current.tenant_id

  secret_permissions = [
    "Get",
    "List", "Set", "Delete", "Recover", "Restore", "Purge"
  ]
}
