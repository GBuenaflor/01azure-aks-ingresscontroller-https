----------------------------------------------------------
# Azure Kubernetes Services (AKS) - NGINX Ingress Controller configured with Lets Encrypt Certificate and Azure DNS Zone

High Level Architecture Diagram:

![Image description](https://github.com/GBuenaflor/01azure-aks-ingresscontroller-https/blob/master/GB-AKS-Ingress-Https.png)


Configuration Flow :

----------------------------------------------------------
# 1. Create AKS Cluster (with Advance Networking using Azure Terraform)
  
  - With AkS    
 
----------------------------------------------------------
# 2. Install the Cert-Manger,Ingress Controller,Configure AZ DNS Zone

# 2.1  Install the Cert-Manager
    
kubectl create namespace cert-manager
helm repo add jetstack https://charts.jetstack.io
helm repo update
kubectl apply --validate=false -f https://raw.githubusercontent.com/jetstack/cert-manager/release-0.14/deploy/manifests/00-crds.yaml
helm install cert-manager \
    --namespace cert-manager \
    --version v0.14.0 \
    jetstack/cert-manager
    
----------------------------------------------------------
# 2.2 Install Ingress Controller
    
kubectl create namespace ingress
helm repo add stable https://kubernetes-charts.storage.googleapis.com/
helm install nginx-ingress stable/nginx-ingress \
    --namespace ingress \
    --set controller.replicaCount=2 \
    --set controller.nodeSelector."beta\.kubernetes\.io/os"=linux \
    --set defaultBackend.nodeSelector."beta\.kubernetes\.io/os"=linux
    
----------------------------------------------------------
# 2.3 Create new A Record that maps to the External IP of Ingress controller
           
az network dns zone create \
  --resource-group Dev01-aks01-RG \
  --name aks01-web.domain.net
 
az network dns record-set a add-record \
    --resource-group Dev01-aks01-RG \
    --zone-name aks01-web.domain.net \
    --record-set-name '*' \
    --ipv4-address [External IP of Ingress Cotroller]


----------------------------------------------------------
# 2.4 Create new CAA record that maps to letsencrypt.org 


$zoneName="aks01-web.domain.net"

$resourcegroup="Dev01-aks01-RG"

$addcaarecord= @()

$addcaarecord+=New-AzDnsRecordConfig -Caaflags 0 -CaaTag "issue" -CaaValue "letsencrypt.org"

$addcaarecord+=New-AzDnsRecordConfig -Caaflags 0 -CaaTag "iodef" -CaaValue "mailto:<Your Email Address>"

$addcaarecord = New-AzDnsRecordSet -Name "@" -RecordType CAA -ZoneName $zoneName -ResourceGroupName $resourcegroup -Ttl 3600 -DnsRecords ($addcaarecord)



----------------------------------------------------------
# 2.4 Configure Cert-Manager using Azure DNS     
    
       -  Create a Service Principal "AZCertManager-SPN" and assign "DNS Zone Contributor" role to give access to DNS Zone
       -  Create a Kubernetes secret "azuredns-config" use in ClusterIssuer.yaml file
       
       
----------------------------------------------------------
# 3. Get Name Server details from Azure DNS Zone and replace Name Server from GoDaddy


az network dns zone show \
  --resource-group Dev01-aks01-RG \
  --name aks01-web.domain.net \
  --query nameServers

----------------------------------------------------------
# 4. Configure Cert-Manager using Azure DNS , this will be use in ClusterIsuer yaml file


https://cert-manager.io/docs/configuration/acme/dns01/azuredns/


----------------------------------------------------------
# 5. Deploy the kubernetes files in sequence:


   - Web and SQL Linux .yaml file, here i created simple asp.net core docker image deployed in dockerhub, sqllinux from docker hub
   - Certificate Issuer .yaml file - This will get certificate from Let's Encrypt
       - Certificate Based on Azure DNS Zone (aks01-web.domain.net)
       - Certificate based on Kubernetes host (.nip.io) 
   - Ingress Controller .yaml file - use http01 and DNS01 challenge
  
  
----------------------------------------------------------
# 5.1 Verifiy the application, both URL's utilize the Let's Encrypt Certificate


# View the two URL's


![Image description](https://github.com/GBuenaflor/01azure-aks-ingresscontroller-https/blob/master/GB-AKS-Ingress-Https02.png)


# View the two Certificates


![Image description](https://github.com/GBuenaflor/01azure-aks-ingresscontroller-https/blob/master/GB-AKS-Ingress-Https03.png)


# 6. In addition, connect SSMS to manage SQL Linux.

Note: My Favorite > Microsoft Technologies.
