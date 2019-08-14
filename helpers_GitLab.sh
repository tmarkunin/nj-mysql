# Installation steps
# Based on instructions from: https://about.gitlab.com/install/#ubuntu

# Update package manager and install prerequisites
sudo apt-get update
sudo apt-get install -y curl openssh-server ca-certificates

# Set up gitlab apt repository
curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.deb.sh | sudo bash

# Install gitlab server
sudo EXTERNAL_URL="http://35.188.0.193" apt-get install gitlab-ce

#Install Docker gitlab runner
# These instructions are based on: https://docs.docker.com/install/linux/docker-ce/ubuntu/

# Update package manager
sudo apt-get update

# Install docker prerequisites
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

# Set up docker gpg key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# Add docker package repository
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

# Update package manager and install docker-ce
sudo apt-get update
sudo apt-get install docker-ce

# Download and run gitlab-runner docker container
sudo docker run -d --name gitlab-runner --restart always \
          -v /srv/gitlab-runner/config:/etc/gitlab-runner \
          -v /var/run/docker.sock:/var/run/docker.sock \
          gitlab/gitlab-runner:latest

# Register gitlab-runner with gitlab
sudo docker exec -it gitlab-runner gitlab-runner register

#In order to build docker images in your pipeline !!!!!!PRIVELEGED
 sudo docker exec -it gitlab-runner gitlab-runner register -n \
   --url http://35.188.0.193/ \
   --registration-token YQQBCoixZRBZDsswcV4H \
   --executor docker \
   --description "My Docker Runner" \
   --docker-image "docker:stable" \
   --docker-privileged

   # How to push image from GitLab to Google registry
   # https://medium.com/@gaforres/publishing-google-cloud-container-registry-images-from-gitlab-ci-23c45356ff0e

   # create helm service account
    - google-cloud-sdk/bin/kubectl --namespace kube-system create sa tiller
    - google-cloud-sdk/bin/kubectl create clusterrolebinding tiller --clusterrole cluster-admin --serviceaccount=kube-system:tiller


#GitLab-fargate integration
#GitLab server installed on GCP: AWS free tier is too small, we need 8 GB RAM
#GitLab runner (docker type) is installed into EC2: https://hackernoon.com/configuring-gitlab-ci-on-aws-ec2-using-docker-7c359d513a46

#push to ECR: https://medium.com/@stijnbe/using-gitlab-ci-with-aws-container-registry-ecaf4a37d791
#You can assign Role with Containers Access Priveleges to EC2 GitLabRunner instead of defining AWS variables in GitLab

$ docker build -t $REPOSITORY_URL .
Cannot connect to the Docker daemon at tcp://docker:2375. Is the docker daemon running?
#You need to add following to .gitlab-ci.yml
variables:
  DOCKER_TLS_CERTDIR: ""


#chenge priviledged to true in gitlab-runner config:

sudo docker exec -it gitlab-runner /bin/bash
nano /etc/gitlab-runner/config.toml

