terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.12"
    }
  }
}

data "azurerm_client_config" "current" {}

locals {
  resource_groups = var.resourcegroupnames
}

module "hub_rg" {
  source    = "c:\\dev\\repo\\modules\\rg"
  resource_groups = local.resource_groups
  prefix    = "rg_hub"
  orgname   = var.orgname
  enviro    = var.enviro
  prjname   = var.prjname
  prjnum    = var.prjnum
  location  = var.location
}

module "hub_firewall" {
  source                            = "c:\\dev\\repo\\modules\\firewall"
  firewall_name                     = format("%s%s%s%s", "fw_hub_", var.prjname, var.enviro, var.prjnum)
  enviro                            = var.enviro
  fwsku                             = "Premium"
  prjname                           = var.prjname
  prjnum                            = var.prjnum
  location                          = var.location
  rgname                            = lookup(module.hub_rg.rgnames, "Connectivity", "fail")
  AzureFirewall_Public_IP_ID        = module.azfw_public_ip.public_ip_id
  AzureFirewallSubnet_ID            = module.azfw_subnet.subnet_id
  dns_servers                       = ["8.8.8.8"]
  ThreatIntelligence_Mode           = "Alert"
  ThreatIntelligence_IP_Whitelist   = ["8.8.8.8", "1.1.1.1"]
  ThreatIntelligence_FQDN_Whitelist = ["www.google.com", "kiloroot.com"]
}

module "hub_law" {
  source           = "c:\\dev\\repo\\modules\\law"
  wsname           = format("%s%s%s%s", "law-hub-", var.prjname, var.enviro, var.prjnum)
  rgname           = lookup(module.hub_rg.rgnames, "Security", "fail")
  location         = var.location
  lawSKU           = "PerGB2018"
  logRetentionDays = 30
}

module "FirewallRuleCollectionGroup" {
  source     = "c:\\dev\\repo\\modules\\hubfirewallrulecollectiongroup"
  enviro     = var.enviro
  prjname    = var.prjname
  prjnum     = var.prjnum
  location   = var.location
  rgname     = lookup(module.hub_rg.rgnames, "NetSec", "fail")
  fwp_hub_id = module.hub_firewall.fwp_id
  web_categories_blacklist = var.web_categories_blacklist
  fqdnblacklist     = var.fqdnblacklist
}

module "azfw_hub_gateway_routetable" {
  source           = "c:\\dev\\repo\\modules\\routetable"
  tablename        = format("%s%s%s%s", "rt_table_snet_hub_gateway", var.prjname, var.enviro, var.prjnum)
  location         = var.location
  rgname           = lookup(module.hub_rg.rgnames, "Connectivity", "fail")
  AssocSubnet_id   = module.gateway_subnet.subnet_id
  disable_bgp_rt_prop = false
}

module "azfw_hub_gateway_route" {
  source                         = "c:\\dev\\repo\\modules\\route"
  routename                      = format("%s%s%s%s", "rt_azfw_default_", var.prjname, var.enviro, var.prjnum)
  rgname                         = lookup(module.hub_rg.rgnames, "Connectivity", "fail")
  address_prefix                 = "192.168.50.0/24"
  next_hop_type                  = "VirtualAppliance"
  next_hop_ip_address            = module.hub_firewall.fw_private_ip_address
  rt_table_name                  = module.azfw_hub_gateway_routetable.rt_table_name
}

module "hub_bastion" {
  source                = "c:\\dev\\repo\\modules\\bastion"
  name                  = "hub"
  enviro                = var.enviro
  orgname               = var.orgname
  prjname               = var.prjname
  prjnum                = var.prjnum
  location              = var.location
  bastionrgname         = lookup(module.hub_rg.rgnames, "Connectivity", "fail")
  nsgrgname             = lookup(module.hub_rg.rgnames, "NetSec", "fail")
  AzureBastionSubnet_ID = module.bastion_subnet.subnet_id
  Bastion_Public_IP_ID  = module.bastion_public_ip.public_ip_id
}