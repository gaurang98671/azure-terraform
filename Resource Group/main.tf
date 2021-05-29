
provider "azurerm" {
features {}
}
resource "azurerm_resource_group" "demorg" {
    name = "demoresourcegroup"
    location = "Central India"
  
}