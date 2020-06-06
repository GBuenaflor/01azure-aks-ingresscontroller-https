----------------------------------------------------------
# Azure Kubernetes Services (AKS) - NGINX Ingress Controller configured with Lets Encrypt Certificate and Azure DNS Zone

High Level Architecture Diagram:

![Image description](https://github.com/GBuenaflor/01azure-aks-ingresscontroller-https/blob/master/GB-AKS-Ingress-Https.png)


Configuration Flow :

1. Create AKS Cluster (with Advance Networking using Azure Terraform)
2. Install the Cert-Manger,Ingress Controller,Configure AZ DNS Zone
    -  Cert-Manager and Ingress Controller
    -  Create new Azure DNS Zone based on domain name from GoDaddy
       - Create new A Record that maps to the External IP of Ingress controller
       - Create new CAA record that maps to letsencrypt.org
    -  Configure Cert-Manager using Azure DNS 
       -  Create a Service Principal "AZCertManager-SPN" and assign "DNS Zone Contributor" role ,to give access to DNS Zone
       -  Create a Kubernetes secret "azuredns-config" this will be use in ClusterIssuer.yaml file
3. Get Name Server details from Azure DNS Zone and replace Name Server from GoDaddy
4. Deploy the kubernetes files in sequence:
   - Web and SQl Linux into Kubernetes .yaml file
   - Certificate Issuer .yaml file - This will get certificate from Let's Encrypt
       - Certificate Based on Azure DNS Zone
       - Certificate based on  .nip.io 
   - Ingress Controller .yaml file
5. Verifiy the application, both URL's utilize the Let's Encrypt Certificate


View the two URL's


![Image description](https://github.com/GBuenaflor/01azure-aks-ingresscontroller-https/blob/master/GB-AKS-Ingress-Https02.png)


View the two Certificates


![Image description](https://github.com/GBuenaflor/01azure-aks-ingresscontroller-https/blob/master/GB-AKS-Ingress-Https03.png)


6. Bunos, To manage SQL Linux, connect using SSMS.

Note: My Favorite > Microsoft Technologies , Next AKS with Application Gateway Ingress Controller, Stay Tuned!..
