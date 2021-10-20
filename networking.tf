module "vnet_hub" {
  source   = "app.terraform.io/roman2025/vnet/azurerm"
  version = "0.0.1"
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
  source   = "app.terraform.io/roman2025/pip/azurerm"
  version = "0.0.1"
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
  source   = "app.terraform.io/roman2025/subnet/azurerm"
  version = "0.0.1"
  name     = "AzureFirewallSubnet"
  rgname   = lookup(module.hub_rg.rgnames, "Connectivity", "fail")
  virtual_network_name = module.vnet_hub.vnet_name
  address_prefixes      = var.azfw_subnet_prefixes
  service_endpoints = []
}

module "bastion_subnet" {
  source   = "app.terraform.io/roman2025/subnet/azurerm"
  version = "0.0.1"
  name     = "AzureBastionSubnet"
  rgname   = lookup(module.hub_rg.rgnames, "Connectivity", "fail")
  virtual_network_name = module.vnet_hub.vnet_name
  address_prefixes      = var.bastion_subnet_prefixes
  service_endpoints = []
}

module "gateway_subnet" {
  source   = "app.terraform.io/roman2025/subnet/azurerm"
  version = "0.0.1"
  name     = "GatewaySubnet"
  rgname   = lookup(module.hub_rg.rgnames, "Connectivity", "fail")
  virtual_network_name = module.vnet_hub.vnet_name
  address_prefixes      = var.gateway_subnet_prefixes
  service_endpoints = []
}

module "azfw_public_ip" {
  source   = "app.terraform.io/roman2025/pip/azurerm"
  version = "0.0.1"
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