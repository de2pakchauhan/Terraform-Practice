resource "azurerm_subnet" "bastion_subnet" {
  for_each             = var.bastion_details
  name                 = "AzureBastionSubnet"
  resource_group_name  = each.value.resource_group_name
  virtual_network_name = each.value.virtual_network_name
  address_prefixes     = each.value.address_prefixes

}

resource "azurerm_public_ip" "public_ip" {
  for_each            = var.bastion_details
  name                = each.value.publicip_name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  allocation_method   = "Static"
}

resource "azurerm_bastion_host" "bastion_host" {
  for_each            = var.bastion_details
  name                = "dcbastion"
  location            = each.value.location
  resource_group_name = each.value.resource_group_name

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.bastion_subnet[each.key].id
    public_ip_address_id = azurerm_public_ip.public_ip[each.key].id
  }
}
