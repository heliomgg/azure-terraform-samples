provider "azurerm" {
  tenant_id       = "${var.tenant_id}"
  subscription_id = "${var.subscription_id}"
  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
}

resource "azurerm_resource_group" "rg" {
  name     = "${var.prefix}-rg"
  location = "${var.location}"
}

resource "azurerm_app_service_plan" "appserviceplan" {
  name                = "${var.prefix}-servplan"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  kind                = "Linux"
  reserved            = true

  sku {
    tier = "Free"
    size = "F1"
  }
}

resource "azurerm_app_service" "appservice" {
  name                = "${var.prefix}-webapi"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  app_service_plan_id = "${azurerm_app_service_plan.appserviceplan.id}"
  https_only = true

  app_settings = {
    "SOME_KEY" = "some-value"
    "SOME_KEY2" = "some-value 2"
  }

  connection_string {
    name = "Database"
    type = "SQLAzure"
    value = "Server=some-server.mydomain.com;Integrated Security=SSPI"
  }

  connection_string {
    name = "connstr2"
    type = "SQLAzure"
    value = "value2"
  }
}
