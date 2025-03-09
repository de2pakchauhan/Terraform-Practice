variable "azure_subscription_id" {
  description = "Azure Subscription ID"
}

variable "rg" {

}

variable "vnet" {

}

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