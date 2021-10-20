module "vnet_hub" {
  source   = "c:\\dev\\repo\\modules\\vnet"
  enviro   = var.enviro
  name     =  "hub"
  prjnum   = var.prjnum
  location = var.location
  rgname   = lookup(module.hub_rg.rgnames, "Connectivity", "fail")
  orgname  = var.orgname
  address_space = var.vnet_hub_address_spaces
  dns_servers = var.vnet_hub_dns_servers
}

module "bastion_public_ip" {
  source   = "c:\\dev\\repo\\modules\\pip"
  enviro   = var.enviro
  name     = "bast"
  prjname  = var.prjname
  prjnum   = var.prjnum
  location = var.location
  rgname   = lookup(module.hub_rg.rgnames, "Connectivity", "fail")
  orgname  = var.orgname
  allocation_method = "Static"
  sku      = "Standard"
}

module "azfw_subnet" {
  source   = "c:\\dev\\repo\\modules\\subnet"
  name     = "AzureFirewallSubnet"
  rgname   = lookup(module.hub_rg.rgnames, "Connectivity", "fail")
  virtual_network_name = module.vnet_hub.vnet_name
  address_prefixes      = var.azfw_subnet_prefixes
  service_endpoints = []
}

module "bastion_subnet" {
  source   = "c:\\dev\\repo\\modules\\subnet"
  name     = "AzureBastionSubnet"
  rgname   = lookup(module.hub_rg.rgnames, "Connectivity", "fail")
  virtual_network_name = module.vnet_hub.vnet_name
  address_prefixes      = var.bastion_subnet_prefixes
  service_endpoints = []
}

module "gateway_subnet" {
  source   = "c:\\dev\\repo\\modules\\subnet"
  name     = "GatewaySubnet"
  rgname   = lookup(module.hub_rg.rgnames, "Connectivity", "fail")
  virtual_network_name = module.vnet_hub.vnet_name
  address_prefixes      = var.gateway_subnet_prefixes
  service_endpoints = []
}

module "azfw_public_ip" {
  source   = "c:\\dev\\repo\\modules\\pip"
  enviro   = var.enviro
  name     = "azfw"
  prjname  = var.prjname
  prjnum   = var.prjnum
  location = var.location
  rgname   = lookup(module.hub_rg.rgnames, "Connectivity", "fail")
  orgname  = var.orgname
  allocation_method = "Static"
  sku      = "Standard"
}