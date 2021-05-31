provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "testRes" {
  name = "demoRes"
  location = "Central India"
}

resource "azurerm_virtual_network" "testVnet" {
  name="testVnet"
  location = azurerm_resource_group.testRes.location
  resource_group_name = azurerm_resource_group.testRes.name
  address_space = [ "10.0.0.0/16" ]
}

resource "azurerm_subnet" "testSubnet" {
    name = "testSubnet"
    resource_group_name = azurerm_resource_group.testRes.name
    virtual_network_name = azurerm_virtual_network.testVnet.name
    address_prefixes = [ "10.0.2.0/24" ]
}

resource "azurerm_public_ip" "publicIp" {
  name = "pubIp"
  count = 3
  resource_group_name = azurerm_resource_group.testRes.name
  location = azurerm_resource_group.testRes.location
  allocation_method = "Dynamic"
}

resource "azurerm_network_interface" "nwI" {
    count = 3
    name = "vm-nic-${count.index}"
    location = azurerm_resource_group.testRes.location
    resource_group_name = azurerm_resource_group.testRes.name
    ip_configuration {
        name= "external"
        subnet_id = azurerm_subnet.testSubnet.id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id = element(azurerm_public_ip.publicIp.*.id, count.index)
    }
  
}



resource "azurerm_virtual_machine" "testing" {
  name = "test_vm-${count.index}"
  count = 3
  resource_group_name = azurerm_resource_group.testRes.name
  vm_size = "Standard_DS1_v2"
  location = azurerm_resource_group.testRes.location
  network_interface_ids = [ element(azurerm_network_interface.nwI.*.id, count.index) ]
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
