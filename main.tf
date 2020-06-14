#######################################################
# Azure Terraform - Infrastructure as a Code (IaC)
#  
# - Azure Kubernetes 
#    - Advance Networking
# 
# ----------------------------------------------------
#  Initial Configuration
# ----------------------------------------------------
# - Run this in Azure CLI
#   az login
#   az ad sp create-for-rbac -n "AzureTerraform" --role="Contributor" --scopes="/subscriptions/[SubscriptionID]"
#
# - Then complete the variables in the variables.tf file
#   - subscription_id  
#   - client_id  
#   - client_secret  
#   - tenant_id  
#   - ssh_public_key  
#   - access_key
#
# - Create K8s Service Principal 
#  AZURE_K8S_SERVICE_PRINCIPAL_NAME=AZK8S-SPN
#
#   K8s_SP=$(az ad sp create-for-rbac --name $AZURE_K8S_SERVICE_PRINCIPAL_NAME)
#   AZURE_K8S_SP_APP_ID=$(echo $K8s_SP | jq -r '.appId')
#
# - Assign Role to K8s Service Principal
#   az role assignment delate --assignee $AZURE_K8S_SP_APP_ID --role Contributor
#
####################################################### 
#----------------------------------------------------
# Azure Terraform Provider
#----------------------------------------------------

provider "azurerm" { 
  features {}
  version = ">=2.0.0"  
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id 
}

#----------------------------------------------------
# Resource Group
#----------------------------------------------------

resource "azurerm_resource_group" "resource_group" {
  name     = var.resource_group
  location = var.location
}
  
#----------------------------------------------------
# Azure AKS Cluster (Advance Networking)
#----------------------------------------------------

resource "azurerm_kubernetes_cluster" "az-k8s" {
  name                = "az-k8s"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
  dns_prefix          = var.dns_prefix

  linux_profile {
    admin_username = "ubuntu"

    ssh_key {
      key_data = file(var.ssh_public_key)
    }
  }
  
  addon_profile {
    http_application_routing {
      enabled = false
    }
  }
  
  default_node_pool {
    name                 = "agentpool"
    node_count           = var.node_count
    vm_size              = var.vm_size
    os_disk_size_gb      = var.aks_agent_os_disk_size
    vnet_subnet_id       = azurerm_subnet.az-k8s-subnet.id
		
    enable_auto_scaling  = var.autoscale
    #node_count           = var.autoscale_node_count
    max_count            = var.autoscale_max_count 
    min_count            = var.autoscale_min_count
  }

  service_principal {
    client_id     = var.client_id
    client_secret = var.client_secret
  }

  network_profile {
    network_plugin     = "azure"
    dns_service_ip     = var.aks_dns_service_ip
    docker_bridge_cidr = var.aks_docker_bridge_cidr
    service_cidr       = var.aks_service_cidr
  }
 
  depends_on = [
    azurerm_virtual_network.az-vnet01,
    azurerm_application_gateway.az-appgateway01,
  ]
  
  tags = {
    Environment = var.environment
  }
}

