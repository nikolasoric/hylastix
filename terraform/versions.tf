terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }

  cloud {
    organization = "SorkeOps"

    workspaces {
      name = "hylastix"
    }
  }
}

provider "azurerm" {
  features {}
}