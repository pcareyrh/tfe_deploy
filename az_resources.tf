locals {
  # Common tags to be assigned to all resources
  common_tags = {
    owner = var.owner
    email = var.email
    se-region = var.location
    purpose = var.purpose
    ttl = var.ttl
    terraform = var.terraform
    hc-internet-facing = var.internet_facing
  }
}

# Configure remote backend.
#terraform {
#  backend "remote" {
#    hostname = ""
#    organization = "MyOrg"

#    workspaces {
#      name = "my-cli-workspace"
#    }
#  }
#}

# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">= 2.26"
    }
  }
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy = true
    }
  }
}

resource "azurerm_resource_group" "pcarey-rg" {
  name     = var.resource_group_name
  location = var.location

  tags = local.common_tags
}
