features = {
  bastion_enable       = true
  publicip_enable      = false
  load_balancer_enable = true
  key_vault_enable     = true
}

rg = {
  rg1 = {
    name     = "dc_res"
    location = "eastasia"
  }
  rg2 = {
    name     = "key_res"
    location = "eastasia"
  }
}

vnet = {
  vnet1 = {
    name                = "dc_vnet"
    location            = "eastasia"
    resource_group_name = "dc_res"
    address_space       = ["10.0.0.0/16"]

    subnets = {
      subnet1 = {
        name             = "subnet"
        address_prefixes = ["10.0.1.0/24"]
      }
      subnet2 = {
        name             = "AzureBastionSubnet"
        address_prefixes = ["10.0.3.0/24"]
      }
    }
  }
}

subnet = {
  subnet1 = {
    name                 = "subnet"
    resource_group_name  = "dc_res"
    virtual_network_name = "dc_vnet"
    address_prefixes     = ["10.0.1.0/24"]

  }
  # subnet2 = {
  #   name                 = "dcbackend"
  #   resource_group_name  = "dc_res"
  #   virtual_network_name = "dc_vnet"
  #   address_prefixes     = ["10.0.2.0/24"]

  # }
  subnet3 = {
    name                 = "AzureBastionSubnet"
    resource_group_name  = "dc_res"
    virtual_network_name = "dc_vnet"
    address_prefixes     = ["10.0.3.0/26"]

  }
}

virtual_machine = {
  vm1 = {
    subnet_name          = "subnet"
    virtual_network_name = "dc_vnet"
    resource_group_name  = "dc_res"
    location             = "eastasia"
    nic_name             = "dc-vm1-nic"
    ip_name              = "dcvm1ip"
    # publicip_name        = "frontendpublicip"
    vm_name = "vm1"
    size    = "Standard_B1s"
    # admin_username       = "adminuser"
    # admin_password       = "P@ssv0rd1234"

  }
  vm2 = {
    subnet_name          = "subnet"
    virtual_network_name = "dc_vnet"
    resource_group_name  = "dc_res"
    location             = "eastasia"
    nic_name             = "dc-vm2-nic"
    ip_name              = "dcvm2ip"
    # publicip_name        = "backendpublicip"
    vm_name = "vm2"
    size    = "Standard_B1s"
    # admin_username       = "adminuser"
    # admin_password       = "P@ssv0rd1234"

  }
}

bastion_host = {
  bastion1 = {
    virtual_network_name = "dc_vnet"
    resource_group_name  = "dc_res"
    location             = "eastasia"
    publicip_name        = "bastionpublicip"

  }
}
