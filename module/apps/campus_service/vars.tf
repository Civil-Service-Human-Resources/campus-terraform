variable "env" {
  default = ""
}

variable "secrets_kv_name" {
  default = ""
}

variable "secrets_kv_rg_name" {
  default = ""
}

variable "sku_tier" {
  default = ""
}

variable "sku_size" {
  default = ""
}

variable "sku_capacity" {
  default = ""
}

variable "docker_tag_env" {
  default = ""
}

variable "app_settings" {
  default = ""
}

variable "acr_rg" {
  default = ""
}

variable "acr_name" {
  default = ""
}

variable "campus_service_docker_tag" {
  default = ""
}

variable "app_dns_zone_name" {
  default = ""
}

variable "app_dns_zone_rg_name" {
  default = ""
}

variable "content_cache_capacity" {
  default = ""
}

variable "content_cache_family" {
  default = ""
}

variable "content_cache_sku" {
  default = ""
}

variable "tags" {
  type = map
}
