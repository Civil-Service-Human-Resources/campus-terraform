resource "azurerm_resource_group" "rg" {
  location =  "UK West"
  name     = "rg-campus-monitoring-${var.env}"
  tags = var.tags
}

resource "azurerm_log_analytics_workspace" "appi_ws" {
  depends_on = [
    azurerm_resource_group.rg
  ]
  name                = "ws-appi-campus-${var.env}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  tags = var.tags
}

resource "azurerm_application_insights" "appi" {
  depends_on = [
    azurerm_resource_group.rg
  ]
  name                = "appi-campus-${var.env}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  workspace_id        = azurerm_log_analytics_workspace.appi_ws.id
  application_type    = "other"
  tags = var.tags
}

output "appi_conn_string" {
  value = azurerm_application_insights.appi.connection_string
}
