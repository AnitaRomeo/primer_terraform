resource "azurerm_resource_group" "name" {
    name = "${var.resource_name}"
    location = "${var.resource_location}" 
  
}
