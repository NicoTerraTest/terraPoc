# module "storage_account" {
#   for_each = { for sa in var.storage_accounts : "${sa.prefix}${sa.suffix}" => sa }
#   source   = "github.com/Just-TF/tf-mod-storage-account.git?ref=v1.0.0"
#   # General variables
#   prefix                   = each.value["prefix"]
#   suffix                   = each.value["suffix"]
#   location                 = var.location
#   resource_group_name      = each.value.resource_group_name
#   private_endpoint_prefix  = try(each.value.private_endpoints["private_endpoint_prefix"], "pe")
#   network_interface_prefix = try(each.value.private_endpoints["network_interface_prefix"], "nic")
#   private_endpoints        = try(each.value["private_endpoints"], [])
#   subnet_id                = try(each.value.private_endpoints["subnet_id"], null)
#   # subnet_id                     = try(module.virtual_network.data.subnet_ids[each.value.subnet_id], null)
#   private_dns_zone_ids          = try(each.value.private_endpoints["private_dns_zone_ids"], {})
#   network_rules                 = try(each.value["network_rules"], null)
#   public_network_access_enabled = try(each.value["public_network_access_enabled"], false)
# }

# #create statefile container
# resource "azurerm_storage_container" "storage_container_tf" {
#   for_each              = { for sa in var.storage_accounts : "${sa.prefix}${sa.suffix}" => sa if sa.create_container }
#   name                  = each.value.container_name
#   storage_account_name  = module.storage_account["${each.value.prefix}${each.value.suffix}"].data.name
#   container_access_type = "private"
# }