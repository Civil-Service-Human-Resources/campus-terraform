data "azuread_client_config" "current" {}

data "azurerm_subscription" "primary" {
}

data "azuread_group" "group" {
  display_name = var.group_name
  security_enabled = true
}

resource "azurerm_role_assignment" "example" {
  scope                = data.azurerm_subscription.primary.id
  role_definition_name = "Contributor"
  principal_id         = data.azuread_group.group.object_id
}
