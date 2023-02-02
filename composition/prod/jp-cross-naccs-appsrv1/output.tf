output "subscription_id" {
  value = local.subscription_id_full
}

output "network_security_group_name" {
  value = module.nsg.network_security_group_name
}

output "rg_name" {
  value =  data.azurerm_resource_group.rg_prod.name
}

output "location" {
  value = data.azurerm_resource_group.rg_prod.location 
}

# output "grafana_folder_id" {
#   value = module.vm.grafana_folder_id
# }

# output "grafana_notification_uid" {
#   value = module.vm.grafana_notification_uid
# }
