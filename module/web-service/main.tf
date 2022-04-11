# Docker recgistry

data "azurerm_container_registry" "container_reg" {
  name = var.container_reg_name
  resource_group_name = var.container_reg_rg
}

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
  client_cert_enabled     = true
  client_cert_mode = "Required"
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

# Hostname

resource "azurerm_app_service_custom_hostname_binding" "app_service_custom_hostname" {
  hostname            = "${var.app_domain_prefix}.${var.domain}"
  app_service_name    = azurerm_app_service.app_service.name
  resource_group_name = azurerm_app_service.app_service.resource_group_name
  depends_on = [
    azurerm_dns_txt_record.app_txt_record,
    azurerm_dns_cname_record.app_cname_record
  ]
}

# URL and DNS

resource "azurerm_dns_txt_record" "app_txt_record" {
  name                = "asuid.mycustomhost.contoso.com"
  zone_name           = var.domain
  resource_group_name = var.dns_zone_resource_group
  ttl                 = 3600

  record {
    value = azurerm_app_service.app_service.custom_domain_verification_id
  }

  tags = var.tags
}

resource "azurerm_dns_cname_record" "app_cname_record" {
  name                = var.app_domain_prefix
  zone_name           = var.domain
  resource_group_name = var.dns_zone_resource_group
  ttl                 = 3600
  record = azurerm_app_service.app_service.default_site_hostname
}

# Certificate

resource "azurerm_app_service_managed_certificate" "web_app_managed_cert" {
  custom_hostname_binding_id = azurerm_app_service_custom_hostname_binding.app_service_custom_hostname.id

}

resource "azurerm_app_service_certificate_binding" "web_app_service_cert_binding" {
  hostname_binding_id = azurerm_app_service_custom_hostname_binding.app_service_custom_hostname.id
  certificate_id      = azurerm_app_service_managed_certificate.web_app_managed_cert.id
  ssl_state           = "SniEnabled"

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
