subscription_id = "33348d3c-78df-4c06-94a7-0465c3fb6d22"
environment     = "dev"
usecase_name    = "genai"

resource_groups = {
  rg-genai-network-dev = {
    suffix = "genai-network-dev"
    tags = {
      BusinessContact  = "TBD",
      BusinessUnit     = "TBD",
      TechnicalContact = "TBD"
    }
  },
  rg-terraform-genai-dev = {
    suffix = "terraform-genai-dev"
    tags = {
      BusinessContact  = "TBD",
      TechnicalContact = "TBD",
      BusinessUnit     = "TBD"
    }
  }
}

storage_accounts = {
  azsttfgenaidev = {
    prefix                        = "azst"
    suffix                        = "tfgenaidev"
    resource_group_name           = "rg-terraform-genai-dev"
    tier                          = "Premium"
    public_network_access_enabled = false

    # Create TF state container
    create_container = true
    container_name   = "c-terraform"

    private_endpoints = [
      {
        name                          = "pe-tfgenaidev-blob"
        custom_private_endpoint_name  = "pe-tfgenaidev-blob"
        custom_network_interface_name = "nic-pe-tfgenaidev-blob"
        subresource_name              = "blob"
        network_interface_prefix      = "nic"
        subnet_id                     = "/subscriptions/33348d3c-78df-4c06-94a7-0465c3fb6d22/resourceGroups/rg-genai-network-dev/providers/Microsoft.Network/virtualNetworks/vnet-genai-dev/subnets/snet-cmn-vnet-genai-dev"
        private_dns_zone_ids          = ["/subscriptions/28b840cb-341d-43f8-8079-f7e295b7adac/resourceGroups/az_rg_core_infranet_network/providers/Microsoft.Network/privateDnsZones/privatelink.blob.core.windows.net"]
      }
    ]
  }
}

virtual_networks = {

  # Virtual network variables
  vnet-genai-dev = {
    virtual_network_prefix        = "vnet"
    subnet_prefix                 = "snet"
    network_security_group_prefix = "nsg"
    route_table_prefix            = "rt"
    dns_servers                   = ["10.244.200.132", "10.244.200.133"]

    firewall_enabled    = true
    resource_group_name = "rg-genai-network-dev"

    # General variable
    suffix             = "genai-dev"
    address_space      = ["10.244.97.0/24"]
    deploy_route_table = false # Optional, Defaults to true

    # Subnet variable
    subnets = [
      {
        shortname         = "pub-app"
        address_prefixes  = "10.244.97.0/27"
        service_endpoints = ["Microsoft.CognitiveServices"]
        delegation = {
          friendly_name = "Microsoft.Web.serverFarms"
          name          = "Microsoft.Web/serverFarms"
          actions       = ["Microsoft.Network/virtualNetworks/subnets/action"]
        }
      },
      {
        shortname                                 = "pub-pe"
        address_prefixes                          = "10.244.97.32/27"
        service_endpoints                         = ["Microsoft.CognitiveServices"]
        private_endpoint_network_policies_enabled = false
      },
      {
        shortname         = "cmn"
        address_prefixes  = "10.244.97.64/27"
        service_endpoints = ["Microsoft.CognitiveServices"]
      },
      {
        shortname        = "pub-app-logic"
        address_prefixes = "10.244.97.96/27"
        delegation = {
          friendly_name = "Microsoft.Web.serverFarms"
          name          = "Microsoft.Web/serverFarms"
          actions       = ["Microsoft.Network/virtualNetworks/subnets/action"]
        }
      },
    ]
  }
}
