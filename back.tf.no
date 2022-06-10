resource "azurerm_network_interface" "BBDD" {
  name                = "backend-nic"
  location            = azurerm_resource_group.ciber-terraform.location
  resource_group_name = azurerm_resource_group.ciber-terraform.name

  ip_configuration {
    name                          = "terraformconfig1"
    subnet_id                     = azurerm_subnet.http.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "BBDD" {
  name                  = var.BBDD_vm_name
  location              = azurerm_resource_group.ciber-terraform.location
  resource_group_name   = azurerm_resource_group.ciber-terraform.name
  network_interface_ids = [azurerm_network_interface.BBDD.id]
  vm_size               = "Standard_DS1_v2"

  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }

  storage_os_disk {
    name              = "BBDD-osdisk1"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "Backend"
    admin_username = "ubuntu"
    admin_password = "DockerDocker@1234"
    ##custom_data    = file("scripts/first-boot.sh")
  }

  os_profile_linux_config {
    disable_password_authentication = false
    ssh_keys {
        key_data = "${file("files/ssh-id.pub")}"
        path = "/home/ubuntu/.ssh/authorized_keys"
    }
  }
}

resource "azurerm_dev_test_global_vm_shutdown_schedule" "rg2" {
  virtual_machine_id = azurerm_virtual_machine.BBDD.id
  location           = azurerm_resource_group.ciber-terraform.location
  enabled            = true

  daily_recurrence_time = "2030"
  timezone           = "Romance Standard Time"

  notification_settings {
    enabled = false
  }
}