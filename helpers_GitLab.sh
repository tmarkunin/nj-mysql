# Installation steps
# Based on instructions from: https://about.gitlab.com/install/#ubuntu

# Update package manager and install prerequisites
sudo apt-get update
sudo apt-get install -y curl openssh-server ca-certificates

# Set up gitlab apt repository
curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.deb.sh | sudo bash

# Install gitlab server
sudo EXTERNAL_URL="http://192.168.50.10" apt-get install gitlab-ce

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
