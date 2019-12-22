#!/bin/bash

install_tf () {
  echo "Installing Terraform"
  
  if [ -x "$(command -v curl )" ]; then
    curl -o /tmp/terraform_0.12.18_linux_amd64.zip https://releases.hashicorp.com/terraform/0.12.18/terraform_0.12.18_linux_amd64.zip
  elif [ -x "$(command -v wget )" ]; then
    wget -O /tmp/terraform_0.12.18_linux_amd64.zip https://releases.hashicorp.com/terraform/0.12.18/terraform_0.12.18_linux_amd64.zip
  else
    echo "Please install curl or wget"
    exit  
  fi

  unzip /tmp/terraform_0.12.18_linux_amd64.zip
  sudo mv terraform /usr/local/bin
  sudo chmod +x /usr/local/bin/terraform
}

generate_ssh_keys () {
  echo "Creating SSH keys for new instances, to disable, comment out the generate_ssh_keys function"
  mkdir -p ssh
  ssh-keygen -b 2048 -t rsa -f ssh/terraform -q -N ""
  # link to our private key
  cp ssh/terraform ssh/terraform.pem
  # Fix permissions
  chmod 600 ssh/terraform.pem
}

cleanup () {
  rm -fr ssh/*
  terraform destroy
}

if [[ ! -f "/usr/local/bin/terraform" ]]; then
  install_tf
fi
if [[ ! -f "ssh/terraform.pub" ]]; then
  generate_ssh_keys
fi
 
