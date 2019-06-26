# Install Azure CLI
# https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest

az login

az group create --name aksresgrp --location eastus
#create container registry
az acr create \
    --name tmaregistry \
    --resource-group aksresgrp \
    --sku Basic 

#take note of loginServer in returned JSON
sudo az acr login --name tmaregistry

sudo docker tag tmarkunin/prometheus:latest tmaregistry.azurecr.io/prometheus:latest

sudo docker push tmaregistry.azurecr.io/prometheus:latest

# Start Azure Pipelines https://azure.microsoft.com/en-us/services/devops/pipelines/


# create AKS cluster (2 nodes is the limit for the trial account)
az aks create \
    --resource-group aksresgrp \
    --name akscluster \
    --node-count 2 \ 
    --generate-ssh-keys