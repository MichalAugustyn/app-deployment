resource "azurerm_application_gateway" "prod-gateway" {
  backend_address_pool {
    name = "app-backend-pool"
    ip_addresses = [ azurerm_container_group.acg.ip_address ]
  }
}
