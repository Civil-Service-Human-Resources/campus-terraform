remote_state {
  backend = "azurerm"
  config = {
    storage_account_name  = get_env(STORAGE_ACCOUNT_NAME)
    resource_group_name = get_env(RESOURCE_GROUP_NAME)
    container_name        = get_env(CONTAINER_NAME)
    key                   = "${path_relative_to_include()}.${get_env(KEY_SUFFIX)}"
  }
}

generate "provider" {
  path = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
    provider "azurerm" {
      version = "~> 2.94"
      features {}
    }

    provider "azuread" {
      version = "~> 2.15.0"
    }
  EOF
}

inputs = {
  acr_name = "acrCampus"
  acr_rg_name = "rg-campus-webops"
  deploy_group_name = "Campus deploy group"
}
