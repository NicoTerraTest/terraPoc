subscription_id = "2963755f-2a1f-4fcf-b9f0-b60a138703ec"
environment     = "prd"
usecase_name    = "genai"

resource_groups = {
  rg-genai-network-prd = {
    suffix = "genai-network-prd"
    tags = {
      BusinessContact  = "TBD",
      BusinessUnit     = "TBD",
      TechnicalContact = "TBD"
    }
  },
  rg-terraform-genai-prd = {
    suffix = "terraform-genai-prd"
    tags = {
      BusinessContact  = "TBD",
      TechnicalContact = "TBD",
      BusinessUnit     = "TBD"
    }
  }
}
/*
storage_accounts = {
  azsttfgenaiprd = {
    prefix                        = "azst"
    suffix                        = "tfgenaiprd"
    resource_group_name           = "rg-terraform-genai-prd"
    tier                          = "Premium"
    public_network_access_enabled = false

    # Create TF state container
    create_container = true
    container_name   = "c-terraform"

    private_endpoints = [
      {
        name                          = "pe-tfgenaiprd-blob"
        custom_private_endpoint_name  = "pe-tfgenaiprd-blob"
        custom_network_interface_name = "nic-pe-tfgenaiprd-blob"
        subresource_name              = "blob"
        network_interface_prefix      = "nic"
        subnet_id                     = "/subscriptions/2963755f-2a1f-4fcf-b9f0-b60a138703ec/resourceGroups/rg-genai-network-prd/providers/Microsoft.Network/virtualNetworks/vnet-genai-prd/subnets/snet-cmn-vnet-genai-prd"
        private_dns_zone_ids          = ["/subscriptions/28b840cb-341d-43f8-8079-f7e295b7adac/resourceGroups/az_rg_core_infranet_network/providers/Microsoft.Network/privateDnsZones/privatelink.blob.core.windows.net"]
      }
    ]
  }
}
*/

virtual_networks = {

  # Virtual network variables
  vnet-genai-prd = {
    virtual_network_prefix        = "vnet"
    subnet_prefix                 = "snet"
    network_security_group_prefix = "nsg"
    route_table_prefix            = "rt"
    dns_servers                   = ["10.244.200.132", "10.244.200.133"]

    firewall_enabled    = true
    resource_group_name = "rg-genai-network-prd"

    # General variable
    suffix             = "genai-prd"
    address_space      = ["10.244.171.0/24"]
    deploy_route_table = false # Optional, Defaults to true

    # Subnet variable
    subnets = [
      {
        shortname         = "pub-app"
        address_prefixes  = "10.244.171.0/27"
        service_endpoints = ["Microsoft.CognitiveServices"]
        delegation = {
          friendly_name = "Microsoft.Web.serverFarms"
          name          = "Microsoft.Web/serverFarms"
          actions       = ["Microsoft.Network/virtualNetworks/subnets/action"]
        }
      },
      {
        shortname                                 = "pub-pe"
        address_prefixes                          = "10.244.171.32/27"
        service_endpoints                         = ["Microsoft.CognitiveServices"]
        private_endpoint_network_policies_enabled = false
      },
      {
        shortname         = "cmn"
        address_prefixes  = "10.244.171.64/27"
        service_endpoints = ["Microsoft.CognitiveServices"]
      },
      {
        shortname        = "pub-app-logic"
        address_prefixes = "10.244.171.96/27"
        delegation = {
          friendly_name = "Microsoft.Web.serverFarms"
          name          = "Microsoft.Web/serverFarms"
          actions       = ["Microsoft.Network/virtualNetworks/subnets/action"]
        }
      },
    ]
  }
}
