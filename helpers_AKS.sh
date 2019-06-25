# Install Azure CLI
# https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest

az login

az group create --name aksresgrp --location eastus

# create AKS cluster (2 nodes is the limit for the trial account)
az aks create \
    --resource-group aksresgrp \
    --name akscluster \
    --node-count 2 \ 
    --generate-ssh-keys