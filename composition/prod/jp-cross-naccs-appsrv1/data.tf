locals {
  subscription_id_full    = data.azurerm_subscription.current.id
  subscription_name_short = lower(replace(data.azurerm_subscription.current.display_name, "-", ""))
  subscription_hash       = substr(lower(md5(local.subscription_name_short)), 0, 6)
  key_vault_password      = "cloud-${local.subscription_hash}-kv-${module.map.region_map[var.location]}"
  loc                     = module.map.region_map[var.location]
  env_prefix              = "cloud-gisprod${local.loc}"

  tags = {
    topic         = var.topic
    application   = var.application
    heritage      = var.heritage
    contact       = var.contact
    costcenter    = var.costcenter
    executionitem = var.executionitem
    stage         = var.stage
    operatedby    = var.operatedby
  }
}

data "azurerm_subscription" "current" {}

data "azurerm_resource_group" "rg_prod" {
  name = "${var.topic}-${var.stage}-rg-${module.map.region_map[var.location]}"
}

data "azurerm_subnet" "app_sub" {
  name                 = "${local.env_prefix}-sn-app-${module.map.region_map[var.location]}"
  virtual_network_name = "${local.env_prefix}-vnet-${module.map.region_map[var.location]}"
  resource_group_name  = "${local.env_prefix}-rg-spoke-${module.map.region_map[var.location]}"
}




# chef data
data "azurerm_key_vault" "vault_toolbox" {
  name                = "cloud-0e842b-kv-weu"
  resource_group_name = "cloud-toolbox-rg-security-weu"
  provider            = azurerm.toolbox
}

data "azurerm_key_vault_secret" "chef_validation_key" {
  name         = "schenker-chef-validation-key"
  key_vault_id = data.azurerm_key_vault.vault_toolbox.id
  provider     = azurerm.toolbox
}
