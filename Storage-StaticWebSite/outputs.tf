output "static_web_url" {
  value = "${azurerm_storage_account.storage.primary_web_endpoint}"
}
