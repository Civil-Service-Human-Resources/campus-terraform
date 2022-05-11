## App service plan and app

resource "azurerm_app_service_plan" "web_app_service_plan" {
  name                = "sp-${var.web_app_name}"
  location            = var.app_service_rg_location
  resource_group_name = var.app_service_rg_name

  sku {
    tier     = var.webapp_sku_tier
    size     = var.webapp_sku_name
    capacity = var.web_app_capacity
  }

  kind     = "Linux"
  reserved = true

  tags = var.tags
}

resource "azurerm_app_service" "app_service" {
  name                    = var.web_app_name
  resource_group_name     = var.app_service_rg_name
  location                = var.app_service_rg_location
  app_service_plan_id     = azurerm_app_service_plan.web_app_service_plan.id
  client_affinity_enabled = false
#  client_cert_enabled     = true
#  client_cert_mode = "Required"
  https_only              = true

  identity {
    type = "SystemAssigned"
  }

  app_settings = merge({
    DOCKER_REGISTRY_SERVER_URL = ""
    DOCKER_REGISTRY_SERVER_USERNAME = ""
    DOCKER_REGISTRY_SERVER_PASSWORD = ""
    APPLICATIONINSIGHTS_ROLE_NAME = var.web_app_name,
    WEBSITES_PORT = var.port,
    NODE_ENV = "production"
  }, var.application_settings)

  site_config {
    always_on         = true
    app_command_line  = var.start_command
    ftps_state        = "Disabled"
    ip_restriction    = []
    min_tls_version   = "1.2"
    http2_enabled     = false
    acr_use_managed_identity_credentials = true
    health_check_path = "/health"
  }

  tags = var.tags
}


## OUTPUTS

output "app_ip_addresses" {
  value = azurerm_app_service.app_service.outbound_ip_address_list
}

output "managed_identity_object_id" {
  value = azurerm_app_service.app_service.identity[0].principal_id
}

output "managed_identity_tenant_id" {
  value = azurerm_app_service.app_service.identity[0].tenant_id
}
