variable "resource_group_name" {
  type = string
}
variable "resource_group_location" {
  type = string
}
variable "tags" {
  type = map(string)
}

variable "virtual_network_name" {
  type = string
}

variable "virtual_network_address_space" {
  type = string
}



variable "subnets" {

  description = "A map of subnets to create"

  type = map(object({

    name = string

    address_prefixes = list(string)

  }))

}


variable "username" {

}

variable "public_ip_name" {

}

variable "network_security_group_name" {

}

variable "network_interface_name" {

}

variable "virtual_machine_name" {

}