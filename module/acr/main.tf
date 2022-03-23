resource "azurerm_container_registry" "app_container_registry" {
  name = var.acr_name
  resource_group_name = var.acr_rg_name
  location = var.acr_rg_location
  sku = "Standard"
  admin_enabled = true
  public_network_access_enabled = true
  tags = var.tags
}
