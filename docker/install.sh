#!/bin/bash

sudo yum makecache
sudo yum clean all
sudo yum update -y
sudo yum install -y docker
sudo usermod -a -G docker ec2-user
sudo service docker restart
sudo docker run hello-world

