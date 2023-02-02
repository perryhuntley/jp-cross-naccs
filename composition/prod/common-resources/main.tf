module "map" {
  source = "git@git.signintra.com:dct/azure/terraform-subscription-static.git"
}

module "rg" {
  source   = "git::git@git.signintra.com:dct/azure/terraform-azurerm-rg.git"
  name     = "${var.topic}-${var.stage}-rg-${module.map.region_map[var.location]}"
  location = var.location
  tags     = local.tags
}
