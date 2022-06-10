terraform {
    required_version = ">= 1.0"
backend "azurerm" {
    resource_group_name = "tfstate"
    storage_account_name = "tfstatef56lq"
    container_name = "tfstate"
    key = "terraform.tfstate"
}
}