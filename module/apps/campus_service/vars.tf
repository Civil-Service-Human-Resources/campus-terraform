variable "env" {
  default = ""
  description = "Shorthand deployment environment, for Azure names"
}

variable "secrets_kv_name" {
  default = ""
  description = "Key vault name for the secrets in the environment"
}

variable "secrets_kv_rg_name" {
  default = ""
  description = "Resource group name for the environment Key Vault"
}

variable "sku_tier" {
  default = ""
  description = "SKU tier for the campus service API"
}

variable "sku_size" {
  default = ""
  description = "SKU size for the campus service API"
}

variable "sku_capacity" {
  default = ""
  description = "Horizontal scale"
}

variable "docker_tag_env" {
  default = ""
  description = "Environment for the docker tag"
}

variable "campus_service_docker_tag" {
  default = ""
  description = "Docker tag to indicate the version of the code to deploy"
}

variable "app_settings" {
  default = ""
  description = "Application settings"
}

variable "acr_rg" {
  default = ""
  description = "Resource group for the container registry"
}

variable "acr_name" {
  default = ""
  description = "Container Registry name"
}

variable "app_dns_zone_name" {
  default = ""
}

variable "app_dns_zone_rg_name" {
  default = ""
}

variable "content_cache_capacity" {
  default = ""
  description = "Horizontal scale for the redis content cache"
}

variable "content_cache_family" {
  default = ""
  description = "Redis content cache family"
}

variable "content_cache_sku" {
  default = ""
  description = "SKU for the redis content cache"
}

variable "tags" {
  type = map
}
