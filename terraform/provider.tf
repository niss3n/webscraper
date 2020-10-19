provider "azurerm" {
    version         = "~> 2.23"
    subscription_id = var.subscriptionId
    features {}
}