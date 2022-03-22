variable "acr_name" {
    type = string
    description = "Name of the Container Registry"
}

variable "acr_rg_name" {
    type = string
    description = "Resource group name for the Container Registry"
}

variable "acr_rg_location" {
    type = string
    description = "Resource group location for the Container Registry"
}

variable "tags" {
    type = map
}
