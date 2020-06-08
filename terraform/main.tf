provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "arg" {
  name     = "terraform-showoff"
  location = "West Europe"
}
