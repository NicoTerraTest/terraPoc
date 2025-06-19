# data "azurerm_virtual_network" "vnet-bastion" {
#   provider            = azurerm.infranet
#   name                = "Az-Vnet-Core-Bastion"
#   resource_group_name = "Az_Rg_Core_InfraNet_Network"
# }

# # Get bastion VNET
# data "azurerm_virtual_network" "vnet-infranet" {
#   provider            = azurerm.infranet
#   name                = "Az-Vnet-Core-InfraNet"
#   resource_group_name = "Az_Rg_Core_InfraNet_Network"
# }

# # Create RG
# module "rg" {
#   for_each = { for k, resource_group in var.resource_groups : k => resource_group }
#   source   = "github.com/Just-TF/tf-mod-resource-group.git?ref=v1.0.0"
#   prefix   = try(each.value.prefix, "rg")
#   suffix   = each.value.suffix
#   location = var.location
#   tags     = each.value.tags
# }

# module "virtual_network" {
#   for_each = { for k, virtual_network in var.virtual_networks : k => virtual_network }
#   source   = "github.com/Just-TF/tf-mod-virtual-network.git?ref=v2.1.0"

#   # General parameters
#   virtual_network_prefix        = try(each.value["virtual_network_prefix"], "vnet")
#   subnet_prefix                 = try(each.value["subnet_prefix"], "snet")
#   network_security_group_prefix = try(each.value["network_security_group_prefix"], "nsg")
#   route_table_prefix            = try(each.value["route_table_prefix"], "rt")
#   suffix                        = each.value["suffix"]
#   location                      = var.location
#   resource_group_name           = try(var.resource_groups[each.value.resource_group_name], null) != null ? module.rg[each.value.resource_group_name].data.name : each.value.resource_group_name

#   # Virtual network specific variables
#   address_space                 = each.value["address_space"]
#   bgp_community                 = try(each.value["bgp_community"], null)
#   ddos_protection_plan          = try(each.value["ddos_protection_plan"], {})
#   dns_servers                   = try(each.value["dns_servers"], [])
#   edge_zone                     = try(each.value["edge_zone"], null)
#   flow_timeout_in_minutes       = try(each.value["flow_timeout_in_minutes"], null)
#   add_vnet_name_to_suffix       = try(each.value["add_vnet_name_to_suffix"], true)
#   deploy_route_table            = try(each.value["deploy_route_table"], false)
#   disable_bgp_route_propagation = try(each.value["disable_bgp_route_propagation"], false)
#   subnets                       = try(each.value["subnets"], [])
#   routes                        = try(each.value["routes"], [])
#   rules                         = fileset(path.module, "network_rules/*/*.csv")
#   firewall_enabled              = try(each.value.firewall_enabled, false)
# }



# # VNET Peering bastion
# resource "azurerm_virtual_network_peering" "peering-prd-bastion" {
#   name                         = "peer-${module.virtual_network["vnet-${var.usecase_name}-${var.environment}"].data.name}-${data.azurerm_virtual_network.vnet-bastion.name}"
#   resource_group_name          = module.virtual_network["vnet-${var.usecase_name}-${var.environment}"].data.resource_group_name
#   virtual_network_name         = module.virtual_network["vnet-${var.usecase_name}-${var.environment}"].data.name
#   remote_virtual_network_id    = data.azurerm_virtual_network.vnet-bastion.id
#   allow_virtual_network_access = true
#   allow_forwarded_traffic      = false
#   use_remote_gateways          = false
# }

# resource "azurerm_virtual_network_peering" "peering-bastion-prd" {
#   provider                     = azurerm.infranet
#   name                         = "peer-${data.azurerm_virtual_network.vnet-bastion.name}-${module.virtual_network["vnet-${var.usecase_name}-${var.environment}"].data.name}"
#   resource_group_name          = data.azurerm_virtual_network.vnet-bastion.resource_group_name
#   virtual_network_name         = data.azurerm_virtual_network.vnet-bastion.name
#   remote_virtual_network_id    = module.virtual_network["vnet-${var.usecase_name}-${var.environment}"].data.id
#   allow_virtual_network_access = true
#   allow_forwarded_traffic      = false
#   allow_gateway_transit        = false
# }

# # Connect to Azure vwan
# resource "azurerm_virtual_hub_connection" "virtual_hub_connection" {
#   provider                  = azurerm.infranet
#   name                      = module.virtual_network["vnet-${var.usecase_name}-${var.environment}"].data.name
#   virtual_hub_id            = "/subscriptions/28b840cb-341d-43f8-8079-f7e295b7adac/resourceGroups/rg-core-infranet-vwan/providers/Microsoft.Network/virtualHubs/vhub-vwan-core-infranet"
#   remote_virtual_network_id = module.virtual_network["vnet-${var.usecase_name}-${var.environment}"].data.id
#   internet_security_enabled = true
# }
