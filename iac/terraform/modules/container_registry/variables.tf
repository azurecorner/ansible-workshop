variable "resource_group_name" {
  type = string
}

variable "resource_group_location" {
  type = string
}
variable "tags" {
  type = map(string)
}

variable "registryName" {
  type = string
}

variable "user_assigned_identity_principal_id" {
  type = string
}