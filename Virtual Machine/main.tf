provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "testGroup" {
  name = "testGroup"
  location = "Central India"
}

resource "azurerm_virtual_network" "testVnet" {
  name = "testVnet"
  address_space = [ "10.0.0.0/16" ]
  location = azurerm_resource_group.testGroup.location
  resource_group_name = azurerm_resource_group.testGroup.name
}

resource "azurerm_subnet" "testSubnet" {
  name = "testSubnet"
  resource_group_name = azurerm_resource_group.testGroup.name
  virtual_network_name = azurerm_virtual_network.testVnet.name
  address_prefixes = [ "10.0.2.0/24" ]
}

resource "azurerm_public_ip" "testIp" {
  name = "testPublicIP"
  resource_group_name = azurerm_resource_group.testGroup.name
  location = azurerm_resource_group.testGroup.location
  allocation_method = "Dynamic"
  
}

resource "azurerm_network_interface" "myInterface" {
  name = "myNIC"
  location = azurerm_resource_group.testGroup.location
  resource_group_name = azurerm_resource_group.testGroup.name
  ip_configuration {
    name = "myConf"
    subnet_id                     = azurerm_subnet.testSubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.testIp.id
  }

}

resource "azurerm_virtual_machine" "testing" {
  name = "Test"
  resource_group_name = azurerm_resource_group.testGroup.name
  vm_size = "Standard_DS1_v2"
  location = azurerm_resource_group.testGroup.location
  network_interface_ids = [ azurerm_network_interface.myInterface.id ]
  delete_os_disk_on_termination = true
  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "hostname"
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }
  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
  
  
}

