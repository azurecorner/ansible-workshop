
# Define local variable to create script_args dynamically
locals {
  script_args = {
    for idx in range(length(module.managed_node_virtual_machine)) : 
    format("arg%d", idx + 1) => {
      vmname    = module.managed_node_virtual_machine[idx].linux_virtual_machine_name
      vmtype    = (idx == 0) ? "webserver" : (idx == 1 ? "dbserver" : "appserver")
      ipaddress = module.managed_node_virtual_machine[idx].private_ip_address
    }
  }
}



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


module "control_node_virtual_machine" {
  source = "./modules/virtual_machine"

  resource_group_name         = var.resource_group_name
  resource_group_location     = var.resource_group_location
  subnet_id                   = azurerm_subnet.devops_subnet["controlNodeSubnet"].id
  tags                        = var.tags
  public_ip_name              = "CONTROL-NODE-${var.public_ip_name}"
  network_security_group_name = "CONTROL-NODE-${var.network_security_group_name}"
  network_interface_name      = "CONTROL-NODE-${var.network_interface_name}"
  virtual_machine_name        = "CONTROL-NODE-${var.virtual_machine_name}"
  computer_name               = "controlNode"
  public_key                  = azapi_resource_action.ssh_public_key_gen.output.publicKey

  script_path         = "script.sh"
  # script_args = {
  #    arg1 = {
  #     vmname    = module.managed_node_virtual_machine[0].linux_virtual_machine_name
  #     vmtype    = "webservers"
  #     ipaddress = module.managed_node_virtual_machine[0].private_ip_address
  #   },
  #   arg2 = {
  #     vmname    = module.managed_node_virtual_machine[1].linux_virtual_machine_name
  #     vmtype    = "dbserver"
  #     ipaddress = module.managed_node_virtual_machine[1].private_ip_address
  #   },
  #   arg3 = {
  #     vmname    = module.managed_node_virtual_machine[2].linux_virtual_machine_name
  #     vmtype    = "appserver"
  #     ipaddress = module.managed_node_virtual_machine[2].private_ip_address
  #   }
  # }
   script_args                 = local.script_args  # Use dynamic script_args

  depends_on = [azurerm_virtual_network.virtual_network , module.managed_node_virtual_machine]
}


module "managed_node_virtual_machine" {
  source = "./modules/virtual_machine"
  count  = 3 # Create 3 VMs

  resource_group_name         = var.resource_group_name
  resource_group_location     = var.resource_group_location
  subnet_id                   = azurerm_subnet.devops_subnet["managedNodeSubnet"].id
  tags                        = var.tags
  public_ip_name              = "MANAGED-NODE-${var.public_ip_name}-${format("%03d", count.index + 1)}"
  network_security_group_name = "MANAGED-NODE-${var.network_security_group_name}-${format("%03d", count.index + 1)}"
  network_interface_name      = "MANAGED-NODE-${var.network_interface_name}-${format("%03d", count.index + 1)}"
  virtual_machine_name        = "MANAGED-NODE-${var.virtual_machine_name}-${format("%03d", count.index + 1)}"
  computer_name               = "managedNode-${format("%03d", count.index + 1)}"
  public_key                  = azapi_resource_action.ssh_public_key_gen.output.publicKey

  depends_on = [azurerm_virtual_network.virtual_network]
}
