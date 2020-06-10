resource "azurerm_container_registry" "acr" {
  name                     = "terraformshowoff"
  resource_group_name      = azurerm_resource_group.arg.name
  location                 = azurerm_resource_group.arg.location
  sku                      = "Basic"
  admin_enabled            = true
}

resource "azurerm_container_group" "acg-0" {
  name                = "showoff-0"
  location            = azurerm_resource_group.arg.location
  network_profile_id  = azurerm_network_profile.container-np.id
  resource_group_name = azurerm_resource_group.arg.name
  ip_address_type     = "private"
  os_type             = "Linux"

  image_registry_credential {
    server   = azurerm_container_registry.acr.login_server
    username = azurerm_container_registry.acr.admin_username
    password = azurerm_container_registry.acr.admin_password
  }
  container {
    name   = "showoff"
    image  = "${azurerm_container_registry.acr.login_server}/showoff:${var.app_tag}"
    cpu    = "0.1"
    memory = "0.2"

    ports {
      port     = var.app_port
      protocol = "TCP"
    }
  }
}

resource "azurerm_container_group" "acg-1" {
  name                = "showoff-1"
  location            = azurerm_resource_group.arg.location
  network_profile_id  = azurerm_network_profile.container-np.id
  resource_group_name = azurerm_resource_group.arg.name
  ip_address_type     = "private"
  os_type             = "Linux"

  image_registry_credential {
    server   = azurerm_container_registry.acr.login_server
    username = azurerm_container_registry.acr.admin_username
    password = azurerm_container_registry.acr.admin_password
  }
  container {
    name   = "showoff"
    image  = "${azurerm_container_registry.acr.login_server}/showoff:${var.app_tag}"
    cpu    = "0.1"
    memory = "0.2"

    ports {
      port     = var.app_port
      protocol = "TCP"
    }
  }
}
