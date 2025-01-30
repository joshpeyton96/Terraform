# Create a resource group
resource "azurerm_resource_group" "task2" {
  name     = "task-rg-Josh2"
  location = "West Europe"
}

# Create a virtual network within the resource group
resource "azurerm_virtual_network" "task2-net" {
  name                = "task2-vnet-Josh"
  resource_group_name = azurerm_resource_group.task2.name
  location            = azurerm_resource_group.task2.location
  address_space       = ["10.0.0.0/16"]
}


# Create subnet
resource "azurerm_subnet" "task2-subnet" {
  name                 = "task2-mySubnet-Josh"
  resource_group_name  = azurerm_resource_group.task2.name
  virtual_network_name = azurerm_virtual_network.task2-net.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Create public IPs
resource "azurerm_public_ip" "task2-pubip" {
  name                = "task2-myPublicIP-Josh"
  location            = azurerm_resource_group.task2.location
  resource_group_name = azurerm_resource_group.task2.name
  allocation_method   = "Dynamic"
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "task2_nsg" {
  name                = "task2-myNetworkSecurityGroup-Josh"
  location            = azurerm_resource_group.task2.location
  resource_group_name = azurerm_resource_group.task2.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}


# Create network interface
resource "azurerm_network_interface" "task2-nic" {
  name                = "task2-myNIC-Josh"
  location            = azurerm_resource_group.task2.location
  resource_group_name = azurerm_resource_group.task2.name

  ip_configuration {
    name                          = "task2-my_nic_configuration-Josh"
    subnet_id                     = azurerm_subnet.task2-subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.task2-pubip.id
  }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "example" {
  network_interface_id      = azurerm_network_interface.task2-nic.id
  network_security_group_id = azurerm_network_security_group.task2_nsg.id
}

# Create virtual machine
resource "azurerm_linux_virtual_machine" "task2-vm" {
  name                  = var.vm_name
  location              = azurerm_resource_group.task2.location
  resource_group_name   = azurerm_resource_group.task2.name
  network_interface_ids = [azurerm_network_interface.task2-nic.id]
  size                  = var.vm_size

  os_disk {
    name                 = "myOsDisk"
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  computer_name  = "hostname"
  admin_username = var.username

#Admin ssh_key needed for deployment. Get public key from local folder
  admin_ssh_key {
    username   = var.username
    public_key = file("~/.ssh/id_rsa.pub")
  }

}