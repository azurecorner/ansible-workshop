tags = {
  environment = "dev"
  application = "datasynchro"
  deployed_by = "terraform"
}

resource_group_name     = "RG-ANSIBLE-DATASYNCHRO"
resource_group_location = "West Europe"

virtual_network_name          = "ANSIBLE-DATASYNCHRO-VNET"
virtual_network_address_space = "10.3.0.0/16"



subnets = {
  controlNodeSubnet = {
    name             = "CONTROL-NODE-SUBNET"
    address_prefixes = ["10.3.0.0/24"]
  }
  managedNodeSubnet = {
    name             = "MANAGED-NODE-SUBNET"
    address_prefixes = ["10.3.1.0/24"]
  }
}

username = "logcorner"

public_ip_name="PIP"

network_security_group_name="NSG"

network_interface_name="NIC"

virtual_machine_name="VM"