resource "azurerm_container_registry" "container_registry" {
  name                = var.registryName
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  sku                 = "Standard"
  admin_enabled       = false

  tags = (merge(var.tags, tomap({
    type = "container_registry"

    })
  ))
}

resource "azurerm_role_assignment" "role_assignment" {
  scope                = azurerm_container_registry.container_registry.id
  role_definition_name = "acrpull"
  principal_id         = var.user_assigned_identity_principal_id 

  depends_on = [azurerm_container_registry.container_registry]
}