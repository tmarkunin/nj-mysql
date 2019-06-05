#Create firewall rule for GCP port 3000
gcloud compute firewall-rules create nodejs-default --allow tcp:3000
gcloud compute firewall-rules create cadvisor-default --allow tcp:8080

#For docker-compose execution with docker server in GCP
docker-machine create --driver google --google-project docker-242218 --google-machine-image https://www.googleapis.com/compute/v1/projects/ubuntu-os-cloud/global/images/family/ubuntu-1604-lts  --google-machine-type n1-standard-1  --google-zone europe-west1-b   ghost 
eval $(docker-machine env ghost)
