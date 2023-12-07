#!/bin/sh

sudo yum -y update
sudo yum install -y nginx stress
sudo systemctl enable --now nginx
