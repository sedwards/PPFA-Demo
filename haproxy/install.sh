#!/bin/bash

sudo yum install -y haproxy
sudo cp /tmp/haproxy.cfg /etc/haproxy/haproxy.cfg
sudo service haproxy restart

