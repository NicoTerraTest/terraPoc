subscription_id = "c7c04435-fc14-41f6-a135-dfafe4c78682"
environment     = "acc"
usecase_name    = "genai"

resource_groups = {
  rg-network-genai-acc = {
    suffix = "network-genai-acc"
    tags = {
      BusinessContact  = "TBD",
      BusinessUnit     = "TBD",
      TechnicalContact = "TBD"
    }
  },
  rg-terraform-genai-acc = {
    suffix = "terraform-genai-acc"
    tags = {
      BusinessContact  = "TBD",
      TechnicalContact = "TBD",
      BusinessUnit     = "TBD"
    }
  }
}

storage_accounts = {
  azsttfgenaiacc = {
    prefix                        = "azst"
    suffix                        = "tfgenaiacc"
    resource_group_name           = "rg-terraform-genai-acc"
    tier                          = "Premium"
    public_network_access_enabled = false

    # Create TF state container
    create_container = true
    container_name   = "c-terraform"

    private_endpoints = [
      {
        name                          = "pe-tfgenaiacc-blob"
        custom_private_endpoint_name  = "pe-tfgenaiacc-blob"
        custom_network_interface_name = "nic-pe-tfgenaiacc-blob"
        subresource_name              = "blob"
        network_interface_prefix      = "nic"
        subnet_id                     = "/subscriptions/c7c04435-fc14-41f6-a135-dfafe4c78682/resourceGroups/rg-network-genai-acc/providers/Microsoft.Network/virtualNetworks/vnet-genai-acc/subnets/snet-cmn-vnet-genai-acc"
        private_dns_zone_ids          = ["/subscriptions/28b840cb-341d-43f8-8079-f7e295b7adac/resourceGroups/az_rg_core_infranet_network/providers/Microsoft.Network/privateDnsZones/privatelink.blob.core.windows.net"]
      }
    ]
  }
}

virtual_networks = {

  # Virtual network variables
  vnet-genai-acc = {
    virtual_network_prefix        = "vnet"
    subnet_prefix                 = "snet"
    network_security_group_prefix = "nsg"
    route_table_prefix            = "rt"
    dns_servers                   = ["10.244.200.132", "10.244.200.133"]

    firewall_enabled    = true
    resource_group_name = "rg-network-genai-acc"

    # General variable
    suffix             = "genai-acc"
    address_space      = ["10.245.171.0/24"]
    deploy_route_table = false # Optional, Defaults to true

    # Subnet variable
    subnets = [
      {
        shortname         = "pub-app"
        address_prefixes  = "10.245.171.0/27"
        service_endpoints = ["Microsoft.CognitiveServices"]
        delegation = {
          friendly_name = "Microsoft.Web.serverFarms"
          name          = "Microsoft.Web/serverFarms"
          actions       = ["Microsoft.Network/virtualNetworks/subnets/action"]
        }
      },
      {
        shortname                                 = "pub-pe"
        address_prefixes                          = "10.245.171.32/27"
        service_endpoints                         = ["Microsoft.CognitiveServices"]
        private_endpoint_network_policies_enabled = false
      },
      {
        shortname         = "cmn"
        address_prefixes  = "10.245.171.64/27"
        service_endpoints = ["Microsoft.CognitiveServices"]
      },
      {
        shortname        = "pub-app-logic"
        address_prefixes = "10.245.171.96/27"
        delegation = {
          friendly_name = "Microsoft.Web.serverFarms"
          name          = "Microsoft.Web/serverFarms"
          actions       = ["Microsoft.Network/virtualNetworks/subnets/action"]
        }
      },
    ]
  }
}
