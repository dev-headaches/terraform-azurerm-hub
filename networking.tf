locals {
ipsplitlist = split(".", var.vnet_hub_address_space)
lastoctet = (split("/", local.ipsplitlist[3]))[0]
vnetcider = (split("/", local.ipsplitlist[3]))[1]

bastion_subnet_octet = sum([tonumber(local.lastoctet), 64])
gateway_subnet_octet = sum([tonumber(local.bastion_subnet_octet), 64])

vnet_address_space_prefix = format("%s.%s.%s.%s/%s", local.ipsplitlist[0], local.ipsplitlist[1], local.ipsplitlist[2], local.lastoctet, local.vnetcider)
azfw_subnet_prefix = format("%s.%s.%s.%s/26", local.ipsplitlist[0], local.ipsplitlist[1], local.ipsplitlist[2], local.lastoctet)
bastion_subnet_prefix = format("%s.%s.%s.%s/26", local.ipsplitlist[0], local.ipsplitlist[1], local.ipsplitlist[2], local.bastion_subnet_octet)
gateway_subnet_prefix = format("%s.%s.%s.%s/27", local.ipsplitlist[0], local.ipsplitlist[1], local.ipsplitlist[2], local.gateway_subnet_octet)
}



module "vnet_hub" {
  source   = "app.terraform.io/roman2025/vnet/azurerm"
  version = ">= 0.0.1"
  enviro   = var.enviro
  name     =  "hub"
  prjnum   = var.prjnum
  location = var.location
  rgname   = lookup(module.hub_rg.rgnames, "Connectivity", "fail")
  orgname  = var.orgname
  address_space = [local.vnet_address_space_prefix]
  dns_servers = var.vnet_hub_dns_servers
}

module "bastion_public_ip" {
  source            = "app.terraform.io/roman2025/pip/azurerm"
  version           = ">= 0.0.2"
  name              = "bast"
  enviro            = var.enviro
  orgname           = var.orgname
  prjnum            = var.prjnum
  location          = var.location
  rgname            = lookup(module.hub_rg.rgnames, "Connectivity", "fail")
  allocation_method = "Static"
  sku               = "Standard"
}

module "azfw_public_ip" {
  source            = "app.terraform.io/roman2025/pip/azurerm"
  version           = ">= 0.0.2"
  name              = "azfw"
  enviro            = var.enviro
  orgname           = var.orgname
  prjnum            = var.prjnum
  location          = var.location
  rgname            = lookup(module.hub_rg.rgnames, "Connectivity", "fail")
  allocation_method = "Static"
  sku               = "Standard"
}

module "azfw_subnet" {
  source   = "app.terraform.io/roman2025/subnet/azurerm"
  version = ">= 0.0.1"
  name     = "AzureFirewallSubnet"
  rgname   = lookup(module.hub_rg.rgnames, "Connectivity", "fail")
  virtual_network_name = module.vnet_hub.vnet_name
  address_prefixes      = [local.azfw_subnet_prefix]
  service_endpoints = []
}

module "bastion_subnet" {
  source   = "app.terraform.io/roman2025/subnet/azurerm"
  version = ">= 0.0.1"
  name     = "AzureBastionSubnet"
  rgname   = lookup(module.hub_rg.rgnames, "Connectivity", "fail")
  virtual_network_name = module.vnet_hub.vnet_name
  address_prefixes      = [local.bastion_subnet_prefix]
  service_endpoints = []
}

module "gateway_subnet" {
  source   = "app.terraform.io/roman2025/subnet/azurerm"
  version = ">= 0.0.1"
  name     = "GatewaySubnet"
  rgname   = lookup(module.hub_rg.rgnames, "Connectivity", "fail")
  virtual_network_name = module.vnet_hub.vnet_name
  address_prefixes      = [local.gateway_subnet_prefix]
  service_endpoints = []
}