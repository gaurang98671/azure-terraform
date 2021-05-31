provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "demoGrp" {
  name = "DemoGroup"
  location = "Central India"
}