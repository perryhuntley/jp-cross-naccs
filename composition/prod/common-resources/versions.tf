terraform {
  required_version = ">= 1.0"
  required_providers {
    grafana = {
      source = "grafana/grafana"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    random = {
      source = "hashicorp/random"
    }
    template = {
      source = "hashicorp/template"
    }
  }
}
