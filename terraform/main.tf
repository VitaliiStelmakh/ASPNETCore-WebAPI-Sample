terraform {
  required_version = ">= 1.3.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.94.0 "
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.6.0"}
  }  
  backend "azurerm" {
    resource_group_name   = "tfstate"
    storage_account_name  = "tfstatedocker123"
    container_name        = "tfstate"
    key                   = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}

  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
}

# Resource Group
resource "azurerm_resource_group" "bestrong_docker_rg" {
  name     = "bestrong_docker_rg"
  location = "eastus"
}

# App Service Plan
resource "azurerm_service_plan" "be_strong_docker_asp" {
  name                = "beStrongDockerAppServicePlan"
  location            = azurerm_resource_group.bestrong_docker_rg.location
  resource_group_name = azurerm_resource_group.bestrong_docker_rg.name
  os_type             = "Linux"
  sku_name            = "B1"
}


# App Service

resource "azurerm_linux_web_app" "be_strong_docker_as" {
  name                = "beStrongAppService"
  location            = azurerm_resource_group.bestrong_docker_rg.location
  resource_group_name = azurerm_resource_group.bestrong_docker_rg.name
  service_plan_id = azurerm_service_plan.be_strong_docker_asp.id
  site_config {
    application_stack {
      docker_registry_username = var.docker_registry_username  
      docker_registry_password = var.docker_registry_password 
      docker_image_name        = "bestrongdockeracr6ep0b2yp.azurecr.io/vitaliistelmakhaspnetcorewebapisample:111"

    }
  }
}


# Random String
resource "random_string" "acr_suffix" {
  length  = 8
  special = false
  upper   = false
}

# Container Registry
resource "azurerm_container_registry" "be_strong_docker_acr" {
  name                     = "beStrongDockerAcr${random_string.acr_suffix.result}"
  resource_group_name      = azurerm_resource_group.bestrong_docker_rg.name
  location                 = azurerm_resource_group.bestrong_docker_rg.location
  sku                      = "Standard"
  admin_enabled            = true
}

















