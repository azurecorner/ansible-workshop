# Create public IPs
resource "azurerm_public_ip" "public_ip" {
  name                = var.public_ip_name
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  allocation_method   = "Dynamic"
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "network_security_group" {
  name                = var.network_security_group_name
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Create network interface
resource "azurerm_network_interface" "network_interface" {
  name                = var.network_interface_name
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "${var.network_interface_name}_configuration"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip.id
  }
 
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "network_interface_security_group_association" {
  network_interface_id      = azurerm_network_interface.network_interface.id
  network_security_group_id = azurerm_network_security_group.network_security_group.id
}

# Generate random text for a unique storage account name
resource "random_id" "random_id" {
  keepers = {
    # Generate a new ID only when a new resource group is defined
    resource_group = var.resource_group_name
  }

  byte_length = 8
}

# Create storage account for boot diagnostics
resource "azurerm_storage_account" "storage_account" {
  name                     = "diag${random_id.random_id.hex}"
  location                 = var.resource_group_location
  resource_group_name      = var.resource_group_name
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# Create virtual machine
resource "azurerm_linux_virtual_machine" "linux_virtual_machine" {
  name                  = var.virtual_machine_name
  location              = var.resource_group_location
  resource_group_name   = var.resource_group_name
  network_interface_ids = [azurerm_network_interface.network_interface.id]
  size                  = "Standard_DS1_v2"

  os_disk {
    name                 =  "${var.virtual_machine_name}_OS_DISK"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  computer_name  =  var.computer_name
  admin_username = var.username

  admin_ssh_key {
    username   = var.username
    public_key = var.public_key
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.storage_account.primary_blob_endpoint
  }
}


resource "azurerm_virtual_machine_extension" "custom_script" {
  count               = var.computer_name == "controlNode" ? 1 : 0  
  name                = "customScriptExtension"
  virtual_machine_id  = azurerm_linux_virtual_machine.linux_virtual_machine.id
  publisher           = "Microsoft.Azure.Extensions"
  type                = "CustomScript"
  type_handler_version = "2.0"

  # protected_settings = <<PROT
  # {
  #   "script": "${base64encode(templatefile("script.sh", { arg1="1", arg2="2", arg3="3" }))}"
  # }
  # PROT

  # Load the script from the path provided in the variable and pass in the args
  protected_settings = <<PROT
  {
    "script": "${base64encode(templatefile(var.script_path, var.script_args))}"
  }
  PROT
  depends_on = [azurerm_linux_virtual_machine.linux_virtual_machine]
}
