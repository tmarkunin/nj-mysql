#Create firewall rule for GCP port 3000
gcloud compute firewall-rules create nodejs-default --allow tcp:3000
