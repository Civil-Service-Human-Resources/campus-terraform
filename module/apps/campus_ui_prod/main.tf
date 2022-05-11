locals {
  app_name     = "campus-ui"
  app_name_env = "${local.app_name}-${var.env}"
}

resource "azurerm_resource_group" "app_resource_group" {
  name     = "rg-${local.app_name_env}"
  location = "West Europe"
  tags = var.tags
}

## Blob storage

resource "azurerm_storage_account" "storage_acc" {
  name                     = "campusui${var.env}"
  account_replication_type = "LRS"
  account_tier             = "Standard"
  location                 = azurerm_resource_group.app_resource_group.location
  resource_group_name      = azurerm_resource_group.app_resource_group.name
  static_website {
    index_document = "index.html"
  }

  tags = var.tags

}


resource "azurerm_storage_container" "storage_container" {
  name                  = "$web"
  storage_account_name  = azurerm_storage_account.storage_acc.name
  container_access_type = "private"
}

## CDN

resource "azurerm_cdn_profile" "cdn" {
  location                 = azurerm_resource_group.app_resource_group.location
  resource_group_name      = azurerm_resource_group.app_resource_group.name
  name                = "cdn-${local.app_name_env}"
  sku                 = "Standard_Microsoft"
  tags = var.tags
}

resource "azurerm_cdn_endpoint" "cdn_endpoint" {
  name                = "cdne-${local.app_name_env}"
  profile_name        = azurerm_cdn_profile.cdn.name
  location                 = azurerm_resource_group.app_resource_group.location
  resource_group_name      = azurerm_resource_group.app_resource_group.name
  origin_host_header = azurerm_storage_account.storage_acc.primary_web_host

  origin {
    name      = "${local.app_name_env}-blob"
    host_name = azurerm_storage_account.storage_acc.primary_web_host
  }

  depends_on = [
    azurerm_cdn_profile.cdn
  ]

  tags = var.tags

  delivery_rule {
    name  = "EnforceHTTPS"
    order = 1

    request_scheme_condition {
      operator     = "Equal"
      match_values = ["HTTP"]
    }

    url_redirect_action {
      redirect_type = "Found"
      protocol      = "Https"
    }
  }

  delivery_rule {
    name  = "Routing"
    order = 2

    url_file_extension_condition {
      operator = "LessThan"
      match_values = [1]
    }

    url_rewrite_action {
      destination    = "/index.html"
      source_pattern = "/"
      preserve_unmatched_path = false
    }
  }
}
