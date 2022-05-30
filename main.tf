terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.46.0"
    }
          backend "azurerm" {
        resource_group_name  = "rg-tf-acr"
        storage_account_name = "mukeshacrstorage"
        container_name       = "mukeshacrcontainer"
        key                  = "terraform.tfstate"
    }
  }

provider"azurerm"{
features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-tf-acr"
  location = "East US"
}

resource "azurerm_container_registry" "acr" {
  name                     = "mukeshacr777"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  sku                      = "Standard"
  admin_enabled            = false
}
resource "azurerm_container_registry" "acr1" {
  name                     = "mukeshacr666"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  sku                      = "Standard"
  admin_enabled            = false
}

output "admin_password" {
  sensitive = true
  value       = azurerm_container_registry.acr.admin_password
  description = "The object ID of the user"
}
