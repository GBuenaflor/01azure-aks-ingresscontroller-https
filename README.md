----------------------------------------------------------
# Azure Kubernetes Services (AKS) - NGINX Ingress Controller configured with Lets Encrypt Certificate and Azure DNS Zone

High Level Architecture Diagram:

![Image description](https://github.com/GBuenaflor/01azure-aks-ingresscontroller-https/blob/master/GB-AKS-Ingress-Https.png)


Configuration Flow :

1. Create AKS Cluster (with Advance Networking using Azure Terraform
2. Install the kubernetes components
    -  Cert-Manager and Ingress Controller
   Create new Azure DNS Zone based on domain name from GoDaddy
    - Create new A Record that maps to the External IP of Ingress controller
    - Create new CAA record that maps to letsencrypt.org
3. Place the Name server of Azure DNS to GoDaddy
4. Deploy the kubernetes files in sequence:
   - Web and SQl Linux into Kubernetes .yaml file
   - Certificate Issuer .yaml file - This will get certificate from Let's Encrypt
       - Certificate Based on Azure DNS Zone
       - Certificate based on  .nip.io 
   - Ingress Controller .yaml file
5. Verifiy the https URL, the certificate is valid from Let's Encrypt


![Image description](https://github.com/GBuenaflor/01azure-aks-ingresscontroller-https/blob/master/GB-AKS-Ingress-Https02.png)



![Image description](https://github.com/GBuenaflor/01azure-aks-ingresscontroller-https/blob/master/GB-AKS-Ingress-Https03.png)


6. Bunos, To manage SQL Linux, connect using SSMS.

Note: My Favorite > Microsoft Technologies
