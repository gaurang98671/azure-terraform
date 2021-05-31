provider "azurerm" {
  features {}
}

module "resourceGroup" {
  source = "./modules/rsGroup/"
}

