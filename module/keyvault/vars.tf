variable "kv_rg_name" {
  default = ""
}

variable "deploy_group_name" {
  default = ""
  description = "The Secure dev group in Azure to apply key vault permissions to"
}

variable "kv_name" {
  default = ""
}

variable "secrets" {
  type = list
}

variable "tags" {
  type = map
}
