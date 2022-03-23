variable "deploy_group_name" {
    default = "Campus deploy group"
    description = "The secure deployment group for campus terraform activities"
}

variable "sub_id" {
    default = ""
    description = "Subscription ID for the Azure user, will default to CLI if blank"
}

variable "client_id" {
    default = ""
    description = "Client ID for the Azure user, will default to CLI if blank"
}

variable "client_secret" {
    default = ""
    description = "Client Secret for the Azure user, will default to CLI if blank"
}

variable "tenant_id" {
    default = ""
    description = "Tenant ID for the Azure user, will default to CLI if blank"
}
