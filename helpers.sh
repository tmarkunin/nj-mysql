#Create firewall rule for GCP port 3000
gcloud compute firewall-rules create nodejs-default --allow tcp:3000
gcloud compute firewall-rules create cadvisor-default --allow tcp:8080
gcloud compute firewall-rules create prometheus-default --allow tcp:9090
#open mariadb port only if external access is required
gcloud compute firewall-rules create mariadb-default --allow tcp:3306

#For docker-compose execution with docker server in GCP
docker-machine create --driver google --google-project infra-243408 --google-machine-image https://www.googleapis.com/compute/v1/projects/ubuntu-os-cloud/global/images/family/ubuntu-1604-lts  --google-machine-type n1-standard-1  --google-zone europe-west1-b   ghost 
eval $(docker-machine env ghost)
export DOCKER_USERNAME=tmarkunin
docker build -f prometheus/Dockerfile -t $DOCKER_USERNAME/prometheus:latest prometheus/
 docker build -t $DOCKER_USERNAME/testapi:2.0 . --target prod
 docker build -f db/Dockerfile -t $DOCKER_USERNAME/maria:2.0 db/

docker-compose up -d

#k8-s deployment
#Create gke cluster
gcloud config set compute/zone us-central1-f
gcloud container clusters create test_cluster  --machine-type=n1-standard-1 --num-nodes=1



