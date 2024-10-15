variable "resource_group_name" {
  type = string
}
variable "resource_group_location" {
  type = string
}
variable "tags" {
  type = map(string)
}

variable "subnet_id" {
  type = string
  
}

variable "username" {
  default = "logcorner"
}

variable "public_ip_name" {
  
}

variable "network_security_group_name" {
  
}

variable "network_interface_name" {
  
}

variable "virtual_machine_name" {
  
}

variable "computer_name" {
  
}
variable "public_key" {
  
}