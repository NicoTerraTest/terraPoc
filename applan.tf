# Service Plan
resource "azurerm_service_plan" "plan" {
  name                       = local.full_name
  location                   = var.location
  resource_group_name        = var.resource_group_name
  os_type                    = var.os_type
  sku_name                   = var.sku_name
  app_service_environment_id = var.app_service_environment_id
  tags                       = var.tags
  zone_balancing_enabled     = var.zone_balancing_enabled

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}