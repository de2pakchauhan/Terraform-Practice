data "azurerm_subnet" "data_subnet" {
  for_each             = var.vm_details
  name                 = each.value.subnet_name
  virtual_network_name = each.value.virtual_network_name
  resource_group_name  = each.value.resource_group_name
}

resource "azurerm_public_ip" "public_ip" {
  for_each            = var.publicip_enable ? var.vm_details : {}
  name                = "${each.value.vm_name}-ip"
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "network_interface" {
  for_each            = var.vm_details
  name                = each.value.nic_name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name

  ip_configuration {
    name                          = each.value.ip_name
    subnet_id                     = data.azurerm_subnet.data_subnet[each.key].id
    public_ip_address_id          = var.publicip_enable && contains(keys(azurerm_public_ip.public_ip), each.key) ? azurerm_public_ip.public_ip[each.key].id : null
    private_ip_address_allocation = "Dynamic"
  }
}



resource "azurerm_network_security_group" "nsg" {
  for_each            = var.vm_details
  name                = "${each.value.vm_name}-nsg"
  location            = each.value.location
  resource_group_name = each.value.resource_group_name

  security_rule {
    name                       = "Allow-SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-HTTP"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface_security_group_association" "nsg_association" {
  for_each = var.vm_details
  network_interface_id      = azurerm_network_interface.network_interface[each.key].id
  network_security_group_id = azurerm_network_security_group.nsg[each.key].id
}

data "azurerm_resource_group" "resource_group" {
  name = "dc_res"
}

data "azurerm_key_vault" "key_vault" {
  name                = "dckey-vault"
  resource_group_name = "key_res"
}

resource "random_password" "vm_password" {
  for_each         = var.vm_details
  length           = 16
  special          = true
  override_special = "_%@"
}

resource "azurerm_key_vault_secret" "vm_username_secret" {
  for_each     = var.vm_details
  name         = "${each.value.vm_name}-adminuser"
  value        = format("%s_adminuser", each.value.vm_name)
  key_vault_id = data.azurerm_key_vault.key_vault.id
}

resource "azurerm_key_vault_secret" "vm_password_secret" {
  for_each     = var.vm_details
  name         = "${each.value.vm_name}-password"
  value        = random_password.vm_password[each.key].result
  key_vault_id = data.azurerm_key_vault.key_vault.id
}

resource "azurerm_linux_virtual_machine" "virtual_machines" {
  for_each                        = var.vm_details
  name                            = each.value.vm_name
  resource_group_name             = each.value.resource_group_name
  location                        = each.value.location
  size                            = each.value.size
  admin_username                  = azurerm_key_vault_secret.vm_username_secret[each.key].value
  admin_password                  = random_password.vm_password[each.key].result
  disable_password_authentication = false
  network_interface_ids           = [azurerm_network_interface.network_interface[each.key].id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}
