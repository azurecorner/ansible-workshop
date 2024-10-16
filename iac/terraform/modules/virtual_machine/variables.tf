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

variable "computer_name" {
    type = string
}

variable "public_key" {
    type = string
}


variable "script_path" {
  description = "Path to the script file to execute."
  type        = string
  default     = "script.sh"  # Provide the default script path
}


variable "script_args" {
  description = "Map of VM details with vmname, vmtype, and ipaddress"
  type        = map(object({
    vmname    = string
    vmtype    = string
    ipaddress = string
  }))
  default = {
    arg1 = {
      vmname    = "vm1"
      vmtype    = "webserver"
      ipaddress = "192.168.1.10"
    },
    arg2 = {
      vmname    = "vm2"
      vmtype    = "dbserver"
      ipaddress = "192.168.1.11"
    },
    arg3 = {
      vmname    = "vm3"
      vmtype    = "appserver"
      ipaddress = "192.168.1.12"
    }
  }
}
