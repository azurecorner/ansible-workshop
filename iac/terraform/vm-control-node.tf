# data "azurerm_subnet" "control_node" {
#   name                 = "CONTROL-NODE-SUBNET"
#   resource_group_name  = azurerm_resource_group.resource_group.name
#   virtual_network_name = var.virtual_network_name
#   depends_on = [ azurerm_virtual_network.virtual_network ]
# }

# # Create public IPs
# resource "azurerm_public_ip" "public_ip" {
#   name                = "controlNodePublicIP"
#   location            = azurerm_resource_group.resource_group.location
#   resource_group_name = azurerm_resource_group.resource_group.name
#   allocation_method   = "Dynamic"
# }

# # Create Network Security Group and rule
# resource "azurerm_network_security_group" "network_security_group" {
#   name                = "controlNodeNetworkSecurityGroup"
#   location            = azurerm_resource_group.resource_group.location
#   resource_group_name = azurerm_resource_group.resource_group.name

#   security_rule {
#     name                       = "SSH"
#     priority                   = 1001
#     direction                  = "Inbound"
#     access                     = "Allow"
#     protocol                   = "Tcp"
#     source_port_range          = "*"
#     destination_port_range     = "22"
#     source_address_prefix      = "*"
#     destination_address_prefix = "*"
#   }
# }

# # Create network interface
# resource "azurerm_network_interface" "network_interface" {
#   name                = "controlNodeNIC"
#   location            = azurerm_resource_group.resource_group.location
#   resource_group_name = azurerm_resource_group.resource_group.name

#   ip_configuration {
#     name                          = "controlNode_nic_configuration"
#     subnet_id                     = data.azurerm_subnet.control_node.id
#     private_ip_address_allocation = "Dynamic"
#     public_ip_address_id          = azurerm_public_ip.public_ip.id
#   }
#   depends_on = [ azurerm_virtual_network.virtual_network ]
# }

# # Connect the security group to the network interface
# resource "azurerm_network_interface_security_group_association" "network_interface_security_group_association" {
#   network_interface_id      = azurerm_network_interface.network_interface.id
#   network_security_group_id = azurerm_network_security_group.network_security_group.id
# }

# # Generate random text for a unique storage account name
# resource "random_id" "random_id" {
#   keepers = {
#     # Generate a new ID only when a new resource group is defined
#     resource_group = azurerm_resource_group.resource_group.name
#   }

#   byte_length = 8
# }

# # Create storage account for boot diagnostics
# resource "azurerm_storage_account" "storage_account" {
#   name                     = "diag${random_id.random_id.hex}"
#   location                 = azurerm_resource_group.resource_group.location
#   resource_group_name      = azurerm_resource_group.resource_group.name
#   account_tier             = "Standard"
#   account_replication_type = "LRS"
# }

# # Create virtual machine
# resource "azurerm_linux_virtual_machine" "linux_virtual_machine" {
#   name                  = "VM-CONTROL-NODE"
#   location              = azurerm_resource_group.resource_group.location
#   resource_group_name   = azurerm_resource_group.resource_group.name
#   network_interface_ids = [azurerm_network_interface.network_interface.id]
#   size                  = "Standard_DS1_v2"

#   os_disk {
#     name                 = "myOsDisk"
#     caching              = "ReadWrite"
#     storage_account_type = "Premium_LRS"
#   }

#   source_image_reference {
#     publisher = "Canonical"
#     offer     = "0001-com-ubuntu-server-jammy"
#     sku       = "22_04-lts-gen2"
#     version   = "latest"
#   }

#   computer_name  = "controlNode"
#   admin_username = var.username

#   admin_ssh_key {
#     username   = var.username
#     public_key = azapi_resource_action.ssh_public_key_gen.output.publicKey
#   }

#   boot_diagnostics {
#     storage_account_uri = azurerm_storage_account.storage_account.primary_blob_endpoint
#   }
# }

# # resource "azurerm_virtual_machine_extension" "test" {
# #   name                 = "hostname"
    
# #   publisher            = "Microsoft.Azure.Extensions"
# #   type                 = "CustomScript"
# #   type_handler_version = "2.0"
# # virtual_machine_id = azurerm_linux_virtual_machine.linux_virtual_machine.id

# #   settings = <<SETTINGS
# #     {
# #         "commandToExecute": "hostname && uptime"
# #     }
# # SETTINGS


# # }
# resource "azurerm_virtual_machine_extension" "custom_script" {
#   name                 = "customScriptExtension"
#   virtual_machine_id   = azurerm_linux_virtual_machine.linux_virtual_machine.id
#   publisher            = "Microsoft.Azure.Extensions"
#   type                 = "CustomScript"
#   type_handler_version = "2.0"

#   protected_settings = <<PROT
#   {
#     "script": "${base64encode(templatefile("script.sh", { arg1="1", arg2="2", arg3="3" }))}"
#   }
#   PROT
#   depends_on = [ azurerm_linux_virtual_machine.linux_virtual_machine ]
# }