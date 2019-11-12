#!/bin/bash

if [[ $(id -u) -ne 0 ]]; 
  then echo "Ubuntu dev bootstrapper, APT-GETs all the things -- run as root...";
  exit 1; 
fi

# https://www.google.com/linuxrepositories/
# https://www.microsoft.com/net/core#linuxubuntu
# https://code.visualstudio.com/docs/setup/linux
# https://nodejs.org/en/download/package-manager/#debian-and-ubuntu-based-linux-distributions
# https://yarnpkg.com/lang/en/docs/install/

echo "Update and upgrade all the things..."

apt-get update -y
#apt-get upgrade -y

echo "Some essentials..."
apt-get install -y curl wget git xclip \
  apt-transport-https ca-certificates gnupg-agent build-essential software-properties-common

# Chrome setup
wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
echo 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' | sudo tee /etc/apt/sources.list.d/google-chrome.list

apt-get install -y google-chrome-stable

# Docker setup - https://docs.docker.com/install/linux/docker-ce/ubuntu/
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
apt-key fingerprint 0EBFCD88
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# ASP.net setup - https://dotnet.microsoft.com/download/linux-package-manager/ubuntu18-04/sdk-3.0.100
wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
dpkg -i packages-microsoft-prod.deb

add-apt-repository universe
apt-get update -y
# apt-get install apt-transport-https
# apt-get update -y
apt-get install dotnet-sdk-3.0

# VS Code setup - https://code.visualstudio.com/docs/setup/linux
sudo snap install --classic code

# Node setup - https://github.com/nodesource/distributions/blob/master/README.md
curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
apt-get install -y nodejs

# Yarn setup - https://yarnpkg.com/lang/en/docs/install/#debian-stable
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

apt-get update -y
apt install yarn -y

# adds the cuurent user who is sudo'ing to a docker group:
groupadd docker
usermod -aG docker $USER
service docker restart

cat << EOF

# now....

code --install-extension ms-vscode.csharp
code --install-extension donjayamanne.python
code --install-extension dbaeumer.vscode-eslint
code --install-extension HookyQR.beautify
code --install-extension lukehoban.go
code --install-extension PeterJausovec.vscode-docker
code --list-extensions

git config --global user.email "you@example.com"
git config --global user.name "Your Name"

ssh-keygen -t rsa -b 4096 -C "you@example.com"

eval "\$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa
xclip -sel clip < ~/.ssh/id_rsa.pub

# now go to https://github.com/settings/keys

# also check docker... you may need to login again for groups to sort out
# try >> docker run hello-world

# also, consider running:
sudo apt autoremove

EOF

