#!/bin/bash
sudo -i
sudo yum update -y
sudo yum install -y nodejs npm git

git clone https://github.com/MachaSreenath/apt-oneclick-project.git /app
cd /app/app
npm install
node script.js &