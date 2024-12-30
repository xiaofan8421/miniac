provider "azurerm" {
  features {}
}


resource "azurerm_resource_group" "example" {
  name     = "tf-test-resources-group"
  location = var.region
}

resource "azurerm_public_ip" "example" {
  name                = "tf-test-public-ip"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  allocation_method   = "Static"
}

resource "azurerm_virtual_network" "example" {
  name                = "tf-test-virtual-network"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  address_space       = ["172.16.0.0/16"]
}

resource "azurerm_subnet" "example" {
  name                 = "tf-test-subnet"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["172.16.1.0/24"]
}

resource "azurerm_network_interface" "example" {
  name                = "tf-test-network-interface"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.example.id
    primary                       = true
  }
}

resource "azurerm_network_security_group" "example" {
  name                = "tf-test-network-security-group"
  location            = var.region
  resource_group_name = azurerm_resource_group.example.name

  security_rule {
    name                       = "SSH"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "allow-oubound"
    priority                   = 102
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface_security_group_association" "example" {
  network_interface_id      = azurerm_network_interface.example.id
  network_security_group_id = azurerm_network_security_group.example.id
}

resource "azurerm_virtual_machine" "example" {
  name                  = "tf-test-vm"
  location              = azurerm_resource_group.example.location
  resource_group_name   = azurerm_resource_group.example.name
  network_interface_ids = [azurerm_network_interface.example.id]
  vm_size               = "Standard_B1s" # 1C1G

  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = var.publisher
    offer     = var.offer
    sku       = var.sku
    version   = "latest"
  }

  storage_os_disk {
    name              = "tf-test-disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
    disk_size_gb      = 30
  }

  os_profile {
    computer_name  = "tf-test-vm"
    admin_username = "tf"
  }

  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      path     = "/home/tf/.ssh/authorized_keys"
      key_data = file("${var.ssh_key_path}.pub")
    }
  }

  depends_on = [azurerm_network_interface.example, azurerm_public_ip.example]

  connection {
    type        = "ssh"
    user        = "tf"
    private_key = file("${var.ssh_key_path}")
    host        = azurerm_public_ip.example.ip_address
    timeout     = "3m"
  }

  provisioner "file" {
    source      = "../deploy_env.sh"
    destination = "/tmp/deploy_env.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "set -e",
      "echo remote-exec begin...",
      "curl -H Metadata:true --noproxy '*' 'http://169.254.169.254/metadata/instance?api-version=2021-02-01'",
      "bash /tmp/deploy_env.sh",
      "echo remote-exec end...",
    ]
  }
}
