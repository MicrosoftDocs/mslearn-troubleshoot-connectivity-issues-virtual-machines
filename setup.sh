#!/bin/bash
resource=`az group list --query '[0].name' --output tsv`

echo "Creating VM Scale Set in $resource..."
az vmss create --name myScaleSet --image UbuntuLTS --upgrade-policy-mode automatic --admin-username azureuser --generate-ssh-keys --resource-group $resource

echo "Setting up webservers..."
az vmss extension set --publisher Microsoft.Azure.Extensions --version 2.0 --name CustomScript  --vmss-name myScaleSet --resource-group $resource

echo "Opening port 80 for web traffic..."
az network lb rule create --name myLoadBalancerRuleWeb --lb-name myScaleSetLB --backend-pool-name myScaleSetLBBEPool --backend-port 80 --frontend-ip-name loadBalancerFrontEnd --frontend-port 80 --protocol tcp --load-distribution SourceIP --resource-group $resource

printf "***********************  Webserver Pool Created  *********************\n\n"
