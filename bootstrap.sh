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
# https://golang.org/doc/install#tarball

echo "Update and upgrade all the things..."

apt-get update -y
#apt-get upgrade -y

echo "Some essentials..."
apt-get install -y curl wget git xclip \
  apt-transport-https ca-certificates gnupg-agent build-essential software-properties-common

# Chrome setup
wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
echo 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' | sudo tee /etc/apt/sources.list.d/google-chrome.list
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
dpkg --install google-chrome-stable_current_amd64.deb
rm google-chrome-stable_current_amd64.deb

# Docker setup - https://docs.docker.com/install/linux/docker-ce/ubuntu/
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get update -y
apt-get install -y docker-ce docker-ce-cli containerd.io

# Docker Compose - https://docs.docker.com/compose/install/#install-compose-on-linux-systems
curl -L "https://github.com/docker/compose/releases/download/1.26.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# ASP.net setup - https://docs.microsoft.com/en-us/dotnet/core/install/linux-ubuntu#2004-
wget -q https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
dpkg -i packages-microsoft-prod.deb
rm packages-microsoft-prod.deb

apt-get update -y
apt-get install -y apt-transport-https
apt-get update -y
apt-get install -y dotnet-sdk-3.1

# VS Code setup - https://code.visualstudio.com/docs/setup/linux
sudo snap install --classic code

# Node setup - https://github.com/nodesource/distributions/blob/master/README.md
curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
apt-get install -y nodejs

# build tools
apt-get install -y gcc g++ make

# Yarn setup - https://yarnpkg.com/lang/en/docs/install/#debian-stable
curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

apt-get update -y
apt install yarn -y

# Go
VERSION=1.14.2
OS=linux
ARCH=amd64
wget https://dl.google.com/go/go$VERSION.$OS-$ARCH.tar.gz -O /tmp/go$VERSION.$OS-$ARCH.tar.gz
tar -C /usr/local -xzf /tmp/go$VERSION.$OS-$ARCH.tar.gz

echo '
export PATH=$PATH:/usr/local/go/bin
' >> ~/.profile

# adds the cuurent user who is sudo'ing to a docker group:
groupadd docker
usermod -aG docker $SUDO_USER
service docker restart
# note that typically you still need a logout/login for docker to work...

cat << EOF

# now....

code --install-extension ms-vscode.csharp
code --install-extension ms-vscode.go
code --install-extension dbaeumer.vscode-eslint
code --install-extension HookyQR.beautify
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
