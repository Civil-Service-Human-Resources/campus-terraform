variable "rg_name" {
    type = string
    description = "(optional) describe your variable"
}

variable "web_app_name" {
    type = string
    description = "(optional) describe your variable"
}

variable "webapp_sku_tier" {
    type = string
    description = "(optional) describe your variable"
}

variable "webapp_sku_name" {
    type = string
    description = "(optional) describe your variable"
}

variable "web_app_capacity" {
    type = string
    description = "(optional) describe your variable"
}

variable "application_settings" {
    type = map
    description = "(optional) describe your variable"
}

variable "container_reg_name" {
    default = ""
}

variable "container_reg_rg" {
    default = ""
}

variable "start_command" {
    default = ""
}

variable "docker_image" {
    type = string
    description = "(optional) describe your variable"
}

variable "docker_tag" {
    type = string
    description = "(optional) describe your variable"
}

variable "app_domain_prefix" {
    type = string
    description = "(optional) describe your variable"
}

variable "domain" {
    type = string
    description = "(optional) describe your variable"
}

variable "dns_zone_resource_group" {
    type = string
    description = "(optional) describe your variable"
}

variable "app_service_rg_name" {
    type = string
    description = ""
}

variable "app_service_rg_location" {
    type = string
    description = ""
}


variable "tags" {
    type = map
}
