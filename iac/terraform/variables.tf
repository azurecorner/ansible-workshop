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
  type = map(object({
  name = string
  address_prefixes = list(string)
  }))
}

variable "username" {
  type = string
}

variable "public_ip_name" {
  type = string
}

variable "network_security_group_name" {
  type = string
}

variable "network_interface_name" {
  type = string
}

variable "virtual_machine_name" {
  type = string
}