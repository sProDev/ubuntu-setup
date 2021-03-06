#!/bin/bash

# save current directory to variable
CURR_DIR=$(pwd)

# change dir to /tmp
cd /tmp

# update & upgrade packages
sudo apt update
sudo apt upgrade -y

# install net-tools
sudo apt install -y net-tools

# install development tools
sudo apt install -y build-essential

# install telnet
sudo apt install -y telnet

# install zip unzip
sudo apt install -y zip unzip

# install docker
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu  $(lsb_release -cs)  stable" -y
sudo apt update
sudo apt install -y docker-ce

# enable docker service
sudo systemctl start docker
sudo systemctl enable docker

# install docker-compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# install nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# install node.js
nvm install --lts
npm i -g npm yarn

# install pm2 & connect to pm2+ monit
yarn global add pm2
pm2 link ${PM2_SECRET_KEY} ${PM2_PUBLIC_KEY}

# enable pm2 at startup
pm2 startup

# install libreoffice
sudo apt install -y libreoffice

# install wkhtmltopdf
wget https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6-1/wkhtmltox_0.12.6-1.focal_amd64.deb
sudo apt install -y ./wkhtmltox_0.12.6-1.focal_amd64.deb
rm -rf ./wkhtmltox_0.12.6-1.focal_amd64.deb

# change dir to /opt
cd /opt

# pdfbot installation
git clone https://${GH_TOKEN}@github.com/sooluh/pdfbot-private.git --single-branch --branch build pdfbot
cd pdfbot
npm ci --unsafe-perm=true
pm2 start npm --name "pdfbot" -- start

# change dir to /tmp
cd /tmp

# autoremove & autoclean
sudo apt autoremove -y
sudo apt autoclean

# change dir to CURR_DIR
cd ${CURR_DIR}
