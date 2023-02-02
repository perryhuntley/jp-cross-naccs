module "nsg" {
  source              = "git::git@git.signintra.com:dct/azure/terraform-azurerm-nsg.git"
  location            = data.azurerm_resource_group.rg_prod.location
  resource_group_name = data.azurerm_resource_group.rg_prod.name
  security_group_name = "${var.topic}-${var.stage}-nsg-${var.application}-${module.map.region_map[var.location]}"

  custom_rules = [
    {
      name                                       = "AllowRDP"
      priority                                   = "121"
      direction                                  = "Inbound"
      access                                     = "Allow"
      protocol                                   = "Tcp"
      destination_port_range                     = "3389"
      source_address_prefix                      = ["10.236.68.192/28"]
      
      destination_application_security_group_ids = [module.vm.asg]
    },
    
    {
      name                   = "BlockAny"
      priority               = "2000"
      direction              = "Inbound"
      access                 = "Deny"
      protocol               = "Tcp"
      source_port_ranges     = "*"
      destination_port_range = "*"
      description            = "BlockAny"
    },
  ]

  dynamic_rules = [
  
    {
      name                                       = "RPC_Communication"
      priority                                   = "125"
      direction                                  = "Inbound"
      access                                     = "Allow"
      protocol                                   = "Tcp"
      destination_port_range                     = "135,49152-65535"
      source_address_prefixes                    = ["10.236.24.233"]
      destination_application_security_group_ids = [module.vm.asg]
    },

   {
      name                                       = "LPR/RAW_Printing"
      priority                                   = "130"
      direction                                  = "Inbound"
      access                                     = "Allow"
      protocol                                   = "Tcp"
      destination_port_range                     = "515,9100"
      source_address_prefixes                    = ["10.0.0.0/8"]
      destination_application_security_group_ids = [module.vm.asg]
    }, 

    {
      name                                       = "HTTPS"
      priority                                   = "135"
      direction                                  = "Inbound"
      access                                     = "Allow"
      protocol                                   = "Tcp"
      destination_port_range                     = "443"
      source_address_prefixes                    = ["10.0.0.0/8"]
      destination_application_security_group_ids = [module.vm.asg]
    }, 

    {
      name                                       = "SMTP"
      priority                                   = "140"
      direction                                  = "Inbound"
      access                                     = "Allow"
      protocol                                   = "Tcp"
      destination_port_range                     = "25,465,587"
      source_address_prefixes                    = ["10.229.213.0/24","10.215.177.0/24"]
      destination_application_security_group_ids = [module.vm.asg]
    }, 
 
    
  ]

  tags = local.tags
}
