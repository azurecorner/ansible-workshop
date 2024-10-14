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
  subnet1 = {
    name             = "CONTROL-NODE-SUBNET"
    address_prefixes = ["10.3.0.0/24"]
  }
  subnet2 = {
    name             = "MANAGED-NODE-SUBNET"
    address_prefixes = ["10.3.1.0/24"]
  }
}