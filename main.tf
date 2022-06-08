terraform {
  }

provider "azurerm" {
  features {}
  
}

resource "azurerm_resource_group" "rg" {
  name      = "mukesh-rg"
  location  = "East US"

}

resource "azurerm_storage_account" "rg" {
  name                     = "mukeshstorage"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Premium"
  account_replication_type = "LRS"

  #tags = {
    #environment = "staging"
 # }
}
#Virtual Network and Subnet
resource   "azurerm_virtual_network"   "vnet"   { 
   name   =   "mukesh-vnet" 
   address_space   =   [ "10.0.0.0/16" ] 
   location   =   "East US" 
   resource_group_name   =   azurerm_resource_group.rg.name 
 } 

 resource   "azurerm_subnet"   "mukeshterraformsubnet"   { 
   name   =   "mukeshterraformsubnet" 
   resource_group_name   =    azurerm_resource_group.rg.name 
   virtual_network_name   =   azurerm_virtual_network.vnet.name 
   address_prefixes     = ["10.0.1.0/24"]
 }

#Define a New Public IP Address
 resource   "azurerm_public_ip"   "mukeshvmpublicip"   { 
   name   =   "pip1" 
   location   =   "East US" 
   resource_group_name   =   azurerm_resource_group.rg.name 
   allocation_method   =   "Dynamic" 
   sku   =   "Basic" 
 }

 #Define a Network Interface for our VM

 resource   "azurerm_network_interface"   "mukeshvmnic"   { 
   name   =   "mukeshvm1-nic" 
   location   =   "East US" 
   resource_group_name   =   azurerm_resource_group.rg.name 

   ip_configuration   { 
     name   =   "ipconfig1" 
     subnet_id   =   azurerm_subnet.mukeshterraformsubnet.id 
     private_ip_address_allocation   =   "Dynamic" 
     public_ip_address_id   =   azurerm_public_ip.mukeshvmpublicip.id 
   } 
 }

#Define the Virtual Machine
 resource   "azurerm_windows_virtual_machine"   "virtual_machine"   { 
   name                    =   "mukeshvm1"   
   location                =   "East US" 
   resource_group_name     =   azurerm_resource_group.rg.name 
   network_interface_ids   =   [ azurerm_network_interface.mukeshvmnic.id ] 
   size                    =   "Standard_DS1_v2" 
   admin_username          =   "azureuser" 
   admin_password          =   "Hexware@123" 

   source_image_reference   { 
     publisher   =   "MicrosoftWindowsServer" 
     offer       =   "WindowsServer" 
     sku         =   "2019-Datacenter" 
     version     =   "latest" 
   } 
 

   os_disk   { 
     caching             =   "ReadWrite" 
     storage_account_type   =   "Premium_LRS" 
   } 
 }
 