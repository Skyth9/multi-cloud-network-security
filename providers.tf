# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.54.0"
    }

    aws = {
      source  = "hashicorp/aws"
      version = "6.23.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}

  resource_provider_registrations = "none"
  client_id                       = var.az_clientid
  client_secret                   = var.az_client_secr
  tenant_id                       = var.az_tenantid
  subscription_id                 = var.az_subscrid
}

provider "aws" {
  # Configuration options
}