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

az acr update -n tmaregistry --admin-enabled true

az acr credential show --name tmaregistry
#put password into DevOps pipeline variavles: Press Edit for selected build pipeline and then press 3 dots button right from RUN button
# You can add Service Connections (ACR,AKS) through DevOps project settings (Low left corner of UI)
# Start Azure Pipelines https://azure.microsoft.com/en-us/services/devops/pipelines/

#Task based build pipeline can look like
steps:
- task: Docker@2
  displayName: Build and push docker image
  inputs:
    containerRegistry: 'tma-acr-connection'
    repository: 'dotnetcore'
    command: 'buildAndPush'
    Dockerfile: '**/Dockerfile'


# create AKS cluster (2 nodes is the limit for the trial account)
az aks create \
    --resource-group aksresgrp \
    --name akscluster \
    --node-count 2 \
    --generate-ssh-keys


# connect to AKS cluster
az aks get-credentials --resource-group aksresgrp --name akscluster