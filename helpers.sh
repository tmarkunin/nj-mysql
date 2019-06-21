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
 docker build -t $DOCKER_USERNAME/testapi:2.1 . --target prod
 docker build -f db/Dockerfile -t $DOCKER_USERNAME/maria:2.0 db/

docker-compose up -d

#k8-s deployment
#Create gke cluster
#You need to change db IP in /k8s_ext_db/endpoint.yaml
gcloud config set compute/zone us-central1-f
gcloud container clusters create test-cluster  --machine-type=n1-standard-1 --num-nodes=1
#Configure kubectl
gcloud container clusters get-credentials test_cluster --zone europe-north1-a --project infra-243408

#deployment for database on external VM
kubectl apply -f k8s_ext_db/





