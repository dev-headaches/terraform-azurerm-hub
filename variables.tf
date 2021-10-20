variable "enviro" {
  type        = string
  description = "define the environment ex. dev,tst,prd,stg"
}

variable "prjname" {
  type        = string
  description = "define the project name ex. prj02"
}

variable "prjnum" {
  type        = string
  description = "define the project number for TFstate file ex. 4858"
}

variable "location" {
  type        = string
  description = "location of your resource group"
}

variable "orgname" {
  type        = string
}

variable "vnet_hub_address_spaces" {
  type        = list
}
variable "vnet_hub_dns_servers" {
  type        = list
}
variable "azfw_subnet_prefixes" {
  type        = list
}
variable "bastion_subnet_prefixes" {
  type        = list
}
variable "gateway_subnet_prefixes" {
  type        = list
}

variable "resourcegroupnames" {
  type = list
  default = ["Connectivity", "NetSec", "Security", "MGMT"]
}

variable "web_categories_blacklist" {
  type    = list(any)
  default = ["ChildAbuseImages", "CriminalActivity", "Cults", "Gambling", "HateAndIntolerance", "IllegalDrug", "IllegalSoftware", "LingerieAndSwimsuits", "Nudity", "PornographyAndSexuallyExplicit", "SelfHarm", "Uncategorized", "Violence"]

  description = "list which can included any of the following" #example all categories: ["AdvertisementsAndPopUps", "AlcoholAndTobacco", "Arts", "Business", "Chat", "ChildAbuseImages", "ChildInappropriate", "ComputersAndTechnology", "CriminalActivity", "Cults", "DatingAndPersonals", "DownloadSites", "Education", "Entertainment", "Finance", "ForumsAndNewsgroups", "Gambling", "Games", "General", "Government", "GreetingCards", "Hacking", "HateAndIntolerance", "HealthAndMedicine", "IllegalDrug", "IllegalSoftware", "ImageSharing", "InformationSecurity", "InstantMessaging", "JobSearch", "LeisureAndRecreation", "LingerieAndSwimsuits", "Marijuana", "NatureAndConservation", "News", "NonProfitsAndNgos", "Nudity", "PeerToPeer", "PersonalSites", "PornographyAndSexuallyExplicit", "PrivateIPAddresses", "ProfessionalNetworking", "RealEstate", "Religion", "RestaurantsAndDining", "SchoolCheating", "SearchEnginesAndPortals", "SelfHarm", "SexEducation", "Shopping", "SocialNetworking", "Sports", "StreamingMediaAndDownloads", "Tasteless", "Translators", "Transportation", "Travel", "Uncategorized", "Violence", "Weapons", "WebBasedEmail", "WebRepositoryAndStorage"]
}

variable "fqdnblacklist" {
  type    = list(any)
  default = ["yahoo.com", "ipchicken.com", "kiloroot.com", "*.yahoo.com", "*.ipchicken.com", "*.kiloroot.com"]
}