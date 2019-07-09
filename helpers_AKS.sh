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


# create AKS cluster (2 nodes is the limit for the trial account)
az aks create \
    --resource-group aksresgrp \
    --name akscluster \
    --node-count 2 \
    --generate-ssh-keys


# connect to AKS cluster
az aks get-credentials --resource-group aksresgrp --name akscluster

kubectl apply -f azure-devops/helm-init.yaml

#authorize aks for pulling images from ACR
AKS_RESOURCE_GROUP=aksresgrp
AKS_CLUSTER_NAME=akscluster
ACR_RESOURCE_GROUP=aksresgrp
ACR_NAME=tmaregistry

# Get the id of the service principal configured for AKS
CLIENT_ID=$(az aks show --resource-group $AKS_RESOURCE_GROUP --name $AKS_CLUSTER_NAME --query "servicePrincipalProfile.clientId" --output tsv)

# Get the ACR registry resource id
ACR_ID=$(az acr show --name $ACR_NAME --resource-group $ACR_RESOURCE_GROUP --query "id" --output tsv)

# Create role assignment
az role assignment create --assignee $CLIENT_ID --role acrpull --scope $ACR_ID

