provider "azurerm" {
features {}
}
resource "azurerm_resource_group" "demorg" {
    name = "demoresourcegroup"
    location = "Central India"
  
}

resource "azurerm_virtual_network" "name" {
  name = "myVnet"
  address_space = [ "10.0.0.0/16" ]
  location = "Central India"
  resource_group_name = azurerm_resource_group.demorg.name
  tags = {
      environment = "Terraform demo"
  }
}

resource "azurerm_subnet" "name" {
  name = "mySubnet"
  resource_group_name = azurerm_resource_group.demorg.name
  virtual_network_name = azurerm_virtual_network.name.name
  address_prefixes = [ "10.0.2.0/24" ]
}
