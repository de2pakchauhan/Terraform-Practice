variable "rg" {

}

variable "vnet" {

}

# variable "subnet" {

# }

variable "virtual_machine" {

}

variable "bastion_host" {

}

variable "features" {
  type = object(
    {
      bastion_enable       = bool
      publicip_enable      = bool
      load_balancer_enable = bool
      key_vault_enable     = bool
    }
  )

}

  module "rg" {
    source     = "../modules/azurerm_resource_group"
    rg_details = var.rg
  }

module "vnet" {
  depends_on   = [module.rg]
  source       = "../modules/azurerm_virtual_network"
  vnet_details = var.vnet

}

# module "subnet" {
#   depends_on     = [module.vnet]
#   source         = "../modules/azurerm_subnet"
#   subnet_details = var.subnet

# }

module "virtual_machine" {
  depends_on      = [module.vnet, module.key_vault]
  source          = "../modules/azurerm_linux_virtual_machine"
  vm_details      = var.virtual_machine
  publicip_enable = var.features.publicip_enable


}

module "bastion_host" {
  count           = var.features.bastion_enable ? 1 : 0
  depends_on      = [module.virtual_machine]
  source          = "../modules/azurerm_bastion_host"
  bastion_details = var.bastion_host

}

module "loadbalancer" {
  count      = var.features.load_balancer_enable ? 1 : 0
  depends_on = [module.virtual_machine]
  source     = "../modules/azurerm_lb"

}

module "key_vault" {
  count      = var.features.key_vault_enable ? 1 : 0
  depends_on = [module.rg]
  source     = "../modules/azurerm_key_vault"
}
