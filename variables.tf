variable "subscription_id" {
}

variable "usecase_name" {
}

variable "environment" {
}

variable "location" {
  default = "westeurope"
}

variable "virtual_networks" {

}

variable "resource_groups" {
  description = "Map of resource groups"
  default     = {}
  type        = map(any)
}

variable "storage_accounts" {
  description = "Map of storage accounts"
  type        = map(any)
  default     = {}
}
