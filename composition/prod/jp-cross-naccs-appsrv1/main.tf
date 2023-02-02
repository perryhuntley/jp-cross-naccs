module "map" {
  source = "git@git.signintra.com:dct/azure/terraform-subscription-static.git"
}

module "vm" {
  
  # If specific version is needed, please update with version suffix, for example "?ref=1.5.1" OR "?ref=feature/xxx"
  source = "git::git@git.signintra.com:dct/azure/terraform-azurerm-vm.git"
  vm_count = 1

  # VM CONFIG
  win_machine             = true
  
  resource_group_location = data.azurerm_resource_group.rg_prod.location
  resource_group_name     = data.azurerm_resource_group.rg_prod.name
  location_code           = module.map.region_map[var.location]
  # project_name            = "${var.topic}-${var.application}"
  
  vm_name                 = "${var.topic}-${var.stage}-vm-${var.application}-${module.map.region_map[var.location]}"
  computer_name           = "JP0123-NACC3"
  key_vault_password      = local.key_vault_password

  subnet_ids = [
    data.azurerm_subnet.app_sub.id,
  ]

  zones = [  #add more if there is more than one VM.
    1,
  ]

  network_security_group_id = module.nsg.network_security_group_id

  vm_size                 = var.vm_sizes["8vCPU-64GB"]
  storage_os_disk_type    = "Premium_LRS" # typical choice for prod"
  storage_os_disk_size_gb = 128

  
  # SECONDARY DISK CONFIG
  data_disk_attach               = "true"
  storage_data_disk_account_type = ["Premium_LRS"] # typical choice for prod"]
  storage_data_disk_size_gb      = [256]

  # data_disk2_attach               = "true"
  # storage_data_disk2_account_type = [""]
  # storage_data_disk2_size_gb      = []

  
  backup_policy_id = "${local.subscription_id_full}/resourceGroups/${local.env_prefix}-rg-spoke-${local.loc}/providers/Microsoft.RecoveryServices/vaults/${local.env_prefix}-rsv-${local.loc}/backupPolicies/${var.backup_plans["ShortTerm(1month)-00:00-03:00"]}-${upper(module.map.region_map[var.location])}"

  Backupwindows = ["${var.backup_plans["ShortTerm(1month)-00:00-03:00"]}-${upper(module.map.region_map[var.location])}"]

  ## OS CONFIG

  
  source_image_id = "dbschenker-win19/versions/2022.10.24" #p for win16, win19, ubuntu18, ubuntu20, rhel7, rhel8

  patching_schedule = "Windows-Prod-3sun-03_00-06_00-${upper(module.map.region_map[var.location])}"
  

  topic         = var.topic
  application   = var.application
  heritage      = var.heritage
  contact       = var.contact
  costcenter    = var.costcenter
  executionitem = var.executionitem
  stage         = var.stage
  operatedby    = var.operatedby
  # task          =

  # comment below line if Grafana dashboard is not required
  grafana_enabled          = true
  # uncomment below line if Grafana Kits(folder, notification channel, team) are required
  # grafana_kits             = true
  # uncomment below line and change the value if overwrite default dashboard user is required
  # grafana_dashboard_users = ["saint.wang@dbschenker.com"]
  # uncomment below line and change the value if overwrite default alert receive user is required
  # grafana_alert_users     = "saint.wang@dbschenker.com;min.m.zhu@dbschenker.com"
  # uncomment below line and change the value if additional tag is required
  # grafana_tag             = "test"
  # uncomment below line and change the value if you know where to put the dashboard
  # grafana_folder_id        = xxx
  # uncomment below line and change the value if you know where to put the alerts
  # grafana_notification_uid = "xxx"


  chefclient_enabled     = true
  chef_validation_key    = data.azurerm_key_vault_secret.chef_validation_key.value
  chef_policy_name       = "azure-basic"
  chef_policy_group      = "prod"
}


