
#!/bin/bash

# users=("ubuntu")
user=$(whoami)
distro_family=$(awk -F= '/^ID_LIKE=/{gsub("\"", "", $2); print $2}' /etc/os-release)
distro_type=$(awk -F= '/^ID=/{gsub("\"", "", $2); print $2}' /etc/os-release)
echo "Found $distro_type machine..."

if [[ $distro_family == "debian" ]]
then
  echo "Installing Docker in "
  sudo apt-get remove docker docker-engine docker.io containerd runc -y

  sudo apt-get update
  sudo apt-get install ca-certificates curl gnupg -y
  sudo install -m 0755 -d /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/$distro_type/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  sudo chmod a+r /etc/apt/keyrings/docker.gpg
  echo \
    "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
    "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  sudo apt-get update
  sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

# Iterate over the array of users and add them to the docker group
  
elif [[ $distro_family == *"rhel"* || $distro_family == *"fedora"* ]]
then
  if [[ $distro_family == "fedora" ]]
  then
    distro_type="fedora"
    sudo yum install dnf-plugins-core -y
  fi
  sudo yum update -y
  sudo yum remove docker docker-client docker-client-latest docker-common docker-latest docker-latest-logrotate docker-logrotate docker-engine -y
  sudo yum install -y yum-utils
  sudo yum-config-manager --add-repo https://download.docker.com/linux/$distro_type/docker-ce.repo
  sudo yum install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
  sudo systemctl start docker
  sudo systemctl enable docker
else
  echo "Unsupported distribution or ID_LIKE value."
  exit 1
fi

if [[ $? -eq 0 ]]; then
    echo "Docker installation completed successfully."
else
    echo "Docker installation encountered an error."
    exit 1
fi

echo "Adding user: $user"
sudo usermod -aG docker $user
echo "User $user added to the docker group."
sudo reboot
