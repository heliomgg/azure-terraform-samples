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

resource "azurerm_storage_account" "storage" {
  name                     = "${var.prefix}staticwebstor"
  resource_group_name      = "${azurerm_resource_group.rg.name}"
  location                 = "${azurerm_resource_group.rg.location}"
  account_tier             = "Standard"
  account_kind             = "StorageV2"
  account_replication_type = "LRS"
  enable_https_traffic_only = true

  provisioner "local-exec" {
    command = "az login  --service-principal -u ${var.client_id} -p ${var.client_secret} --tenant ${var.tenant_id} | az storage blob service-properties update --account-name ${azurerm_storage_account.storage.name} --static-website  --index-document index.html --404-document index.html"
  }
}
