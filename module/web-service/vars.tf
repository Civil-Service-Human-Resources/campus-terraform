variable "rg_name" {
    type = string
    description = "Resource group name"
}

variable "web_app_name" {
    type = string
}

variable "webapp_sku_tier" {
    type = string
}

variable "webapp_sku_name" {
    type = string
}

variable "web_app_capacity" {
    type = string
}

variable "application_settings" {
    type = map
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

variable "port" {
    type = number
    description = "Port that the Docker container is running on"
}

variable "app_domain_prefix" {
    type = string
    description = "The base url prefix for the web application"
}

variable "domain" {
    type = string
}

variable "dns_zone_resource_group" {
    type = string
}

variable "app_service_rg_name" {
    type = string
}

variable "app_service_rg_location" {
    type = string
}


variable "tags" {
    type = map
}
