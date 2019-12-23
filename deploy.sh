#!/bin/bash

COMMAND="help"

# Options
while [[ $# -gt 0 ]]
do
key="$1"
  case $key in
      *)
      COMMAND="$1"
      ;;
  esac
  shift # past argument or value
done


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
  terraform destroy
  rm -fr ssh/*
}
 

case "$COMMAND" in
  install-tf)
    if [[ ! -f "/usr/local/bin/terraform" ]]; then
      install_tf
    fi
    ;;
  gen-keys)
    if [[ ! -f "ssh/terraform.pub" ]]; then
      generate_ssh_keys
    fi
    ;;
  init)
    terraform init
    ;;
  plan)
    terraform plan
    ;;
  apply)
    terraform apply
    ;;
  cleanup)
    cleanup "Removing keys and environment"
    ;;
  *)
    echo "
usage: deploy <command>
The most commonly used commands are:
 [requirements]
   install-tf            - Show terraform state
   gen-keys              - Should be clear enough
 [deploy envrionment]
   init                  - init terraform
   plan                  - execute terraform plan
   apply                 - execute terraform apply
 [housekeeping]
   cleanup               - terraform destory and remove ssh keys
"
  >&2
    exit 3
    ;;
esac

