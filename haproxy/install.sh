#!/bin/bash

sudo yum install haproxy
sudo cp /tmp/haproxy.cfg /etc/haproxy.cfg
sudo service haproxy restart

