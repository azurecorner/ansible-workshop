resource "azurerm_resource_group" "resource_group" {
  location = var.resource_group_location
  name     = var.resource_group_name
}

resource "azurerm_virtual_network" "virtual_network" {
  address_space       = [var.virtual_network_address_space]
  location            = var.resource_group_location
  name                = var.virtual_network_name
  resource_group_name = var.resource_group_name
  depends_on = [
    azurerm_resource_group.resource_group,
  ]
}

resource "azurerm_subnet" "devops_subnet" {
  for_each             = var.subnets
  address_prefixes     = each.value["address_prefixes"]
  name                 = each.value["name"]
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.virtual_network.name

}


# module "virtual_machine" {
#   source              = "./modules/virtual_machine"

#   resource_group_name = var.resource_group_name
#   resource_group_location = var.resource_group_location
#    subnet_id = azurerm_subnet.devops_subnet["CONTROL-NODE-SUBNET"].id
#   tags = var.tags
#   public_ip_name = var.public_ip_name
#   network_security_group_name = var.network_security_group_name
#   network_interface_name = var.network_interface_name
#   virtual_machine_name = var.virtual_machine_name
# }

module "control_node_virtual_machine" {
  source              = "./modules/virtual_machine"

  resource_group_name         = var.resource_group_name
  resource_group_location     = var.resource_group_location
  subnet_id                   = azurerm_subnet.devops_subnet["controlNodeSubnet"].id
  tags                        = var.tags
  public_ip_name              = "CONTROL-NODE-${var.public_ip_name}"
  network_security_group_name = "CONTROL-NODE-${var.network_security_group_name}"
  network_interface_name      = "CONTROL-NODE-${var.network_interface_name}"
  virtual_machine_name        = "CONTROL-NODE-${var.virtual_machine_name}"
 computer_name = "controlNode"
  public_key = azapi_resource_action.ssh_public_key_gen.output.publicKey
  
  depends_on = [ azurerm_virtual_network.virtual_network ]
}


# module "managed_node_virtual_machine" {
#   source              = "./modules/virtual_machine"

#   resource_group_name         = var.resource_group_name
#   resource_group_location     = var.resource_group_location
#   subnet_id                   = azurerm_subnet.devops_subnet["managedNodeSubnet"].id
#   tags                        = var.tags
#   public_ip_name              = "MANAGED-NODE-${var.public_ip_name}-001"
#   network_security_group_name = "CONTROL-NODE-${var.network_security_group_name}-001"
#   network_interface_name      = "CONTROL-NODE-${var.network_interface_name}-001"
#   virtual_machine_name        = "CONTROL-NODE-${var.virtual_machine_name}-001"
#   computer_name = "managedNode-001"
#   public_key = azapi_resource_action.ssh_public_key_gen.output.publicKey
  
#   depends_on = [ azurerm_virtual_network.virtual_network ]
# }

module "managed_node_virtual_machine" {
  source                   = "./modules/virtual_machine"
  count                    = 3  # Create 3 VMs

  resource_group_name       = var.resource_group_name
  resource_group_location   = var.resource_group_location
  subnet_id                 = azurerm_subnet.devops_subnet["managedNodeSubnet"].id
  tags                      = var.tags
  public_ip_name            = "MANAGED-NODE-${var.public_ip_name}-${format("%03d", count.index + 1)}"
  network_security_group_name = "MANAGED-NODE-${var.network_security_group_name}-${format("%03d", count.index + 1)}"
  network_interface_name    = "MANAGED-NODE-${var.network_interface_name}-${format("%03d", count.index + 1)}"
  virtual_machine_name      = "MANAGED-NODE-${var.virtual_machine_name}-${format("%03d", count.index + 1)}"
  computer_name             = "managedNode-${format("%03d", count.index + 1)}"
  public_key                = azapi_resource_action.ssh_public_key_gen.output.publicKey

  depends_on = [azurerm_virtual_network.virtual_network]
}
