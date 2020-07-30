#----------------------------------------------------
#  Replace correct values or configure values in Azure DevOps variables :
#
#  - subscription_id  
#  - client_id  
#  - client_secret  
#  - tenant_id  
#  - ssh_public_key  
#  - access_key
#---------------------------------------------------- 

variable subscription_id {
	  default = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"  
 }

variable client_id       {
	  default = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"  
 }

variable client_secret   {
	  default = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"  
 }

variable tenant_id       {
	  default = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"  
 }
 
variable ssh_public_key {
   default = "azure_rsa.pub"
} 

#----------------------------------------------------
# Azure Storage Account
#---------------------------------------------------- 
    
variable storage_account_name {
    default = "dev01straccnt01"
}
 
variable access_key {
    default = "1qxGagOl73iVmc/KBZJvKS1aHHG/MIDS6BHRd3OXi5PFav6fNBPv3h0xhEr1zvHsaLkMzHw/UcOxMf09yNnSsQ==" 
}
  
variable key {
    default = "dev01.k8s.tfstate"
}
  
variable container_name {
    default = "dev01strcontainer01"
}
    
#----------------------------------------------------
# Azure AKS Variables
#----------------------------------------------------
    
variable environment {
    default = "Dev"
}

variable location {
    default = "eastus"
}

variable node_count {
  default = 2
}

variable dns_prefix {
  default = "aks01"
}

variable cluster_name {
  default = "aks01"
}

variable vm_size {
  default = "Standard_D3_v2"  
}


variable "autoscale" {
  default     = "true"
}

variable "autoscale_node_count" {
  default     = "2"
}

variable "autoscale_max_count" {
  default     = "3"
}

variable "autoscale_min_count" {
  default     = "2"
}
 

variable resource_group {
  default = "Dev01-aks01-RG"
}
variable "aks_agent_os_disk_size" {
  description = "Disk size (in GB), range from 0 to 1023. Specifying 0 - the default disk size."
  default     = 50
}

variable "aks_service_cidr" {
  default     = "10.0.0.0/16"
}

variable "aks_dns_service_ip" { 
  default     = "10.0.0.10"
}

variable "aks_docker_bridge_cidr" { 
  default     = "172.17.0.1/16"
}

 
