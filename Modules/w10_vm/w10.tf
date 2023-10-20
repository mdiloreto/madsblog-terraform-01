resource "azurerm_resource_group" "madsblog-rg" {
  name     = var.rg
  location = var.location
}

resource "azurerm_virtual_network" "main" {
  name                = "${var.vmname}-network"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = var.rg
}

resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = var.rg
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "w10_vmnic" {
  name                = "${var.vmname}-nic"
  location            = var.location
  resource_group_name = var.rg

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "w10_vmnic" {
  
  location = var.location
  name = var.vmname
  network_interface_ids = [
      azurerm_network_interface.w10_vmnic.id,
  ]
  resource_group_name   = var.rg
  tags                  = {}
  vm_size               = "Standard_E2s_v3"
  zones                 = [
      "1",
  ]
  delete_os_disk_on_termination = true
  delete_data_disks_on_termination = true

  os_profile {
    computer_name = var.vmname
    admin_username = var.admin_username
    admin_password = var.admin_password
  }

  os_profile_windows_config {
      enable_automatic_upgrades = true
      provision_vm_agent        = true
  }

  storage_image_reference {
      offer     = "Windows-10"
      publisher = "MicrosoftWindowsDesktop"
      sku       = "win10-22h2-pro-g2"
      version   = "latest"
  }

  storage_os_disk {
      caching                   = "ReadWrite"
      create_option             = "FromImage"
      disk_size_gb              = 127
      managed_disk_type         = "Premium_LRS"
      name                      = "${var.vmname}-disk"
      os_type                   = "Windows"
      write_accelerator_enabled = false
  }
}