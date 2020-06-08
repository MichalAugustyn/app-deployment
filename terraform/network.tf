resource "azurerm_virtual_network" "vnet" {
  name                = "tf-vnet"
  resource_group_name = azurerm_resource_group.arg.name
  location            = azurerm_resource_group.arg.location
  address_space       = ["10.0.0.0/23"]
}

resource "azurerm_subnet" "frontend" {
  name                 = "tf-vnet-frontend"
  resource_group_name  = azurerm_resource_group.arg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.0.0/24"]
}

resource "azurerm_subnet" "backend" {
  name                 = "tf-vnet-backend"
  resource_group_name  = azurerm_resource_group.arg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]

  delegation {
    name = "delegation"

    service_delegation {
      name    = "Microsoft.ContainerInstance/containerGroups"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}

resource "azurerm_network_profile" "container-np" {
  name                = "terraformNetProfile"
  resource_group_name = azurerm_resource_group.arg.name
  location            = azurerm_resource_group.arg.location

  container_network_interface {
    name = "appNetInterface"

    ip_configuration {
      name      = "appIpConfig"
      subnet_id = azurerm_subnet.backend.id
    }
  }
}

resource "azurerm_public_ip" "frontend" {
  name                 = "terraformIp"
  resource_group_name  = azurerm_resource_group.arg.name
  location             = azurerm_resource_group.arg.location
  allocation_method    = "Dynamic"
}

resource "azurerm_application_gateway" "prod-gateway" {
  name                = "tf-prod-gateway"
  resource_group_name = azurerm_resource_group.arg.name
  location            = azurerm_resource_group.arg.location

  sku {
    name     = "Standard_Small"
    tier     = "Standard"
    capacity = 1
  }

  gateway_ip_configuration {
    name      = "tf-prod-gateway-ip-config"
    subnet_id = azurerm_subnet.frontend.id
  }

  frontend_port {
    name = "http-port"
    port = 80
  }

  frontend_ip_configuration {
    name                 = "tf-frontend-ip-config"
    public_ip_address_id = azurerm_public_ip.frontend.id
  }

  backend_address_pool {
    name = "app-backend-pool"
    ip_addresses = [ azurerm_container_group.acg.ip_address ]
  }

  backend_http_settings {
    name                  = "container-http"
    cookie_based_affinity = "Disabled"
    port                  = 5000
    protocol              = "Http"
    request_timeout       = 1
  }

  http_listener {
    name                           = "port-80-listener"
    frontend_ip_configuration_name = "tf-frontend-ip-config"
    frontend_port_name             = "http-port"
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = "app-routing"
    rule_type                  = "Basic"
    http_listener_name         = "port-80-listener"
    backend_address_pool_name  = "app-backend-pool"
    backend_http_settings_name = "container-http"
  }
  depends_on = [ azurerm_container_group.acg ]
}
