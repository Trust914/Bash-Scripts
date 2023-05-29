#!/bin/bash

### INSTALL KUBECTL

# Install kubectl binary with curl on Linux 
sudo apt-get update
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

# Validate the binary
curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check


# Install kubectl
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl


### INSTALL KOPS


# Download the latest release
curl -LO https://github.com/kubernetes/kops/releases/download/$(curl -s https://api.github.com/repos/kubernetes/kops/releases/latest | grep tag_name | cut -d '"' -f 4)/kops-linux-amd64

# Make the kops binary executable
chmod +x kops-linux-amd64

# Move the kops binary in to your PATH.
sudo mv kops-linux-amd64 /usr/local/bin/kops
sudo apt install awscli -y



