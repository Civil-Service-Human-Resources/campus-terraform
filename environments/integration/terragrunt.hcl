include "root" {
    path = find_in_parent_folders()
}

inputs = {
    campus_service_sku_tier = "Standard"
    campus_service_sku_size = "S1"
    campus_service_sku_capacity = "1"
    campus_service_docker_tag = "develop"
}