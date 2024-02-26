#!/bin/bash

if [[ $(id -u) -ne 0 ]]; 
  then echo "Ubuntu dev bootstrapper, APT-GETs all the things -- run as root...";
  exit 1; 
fi

# ARCH=amd64
ARCH=arm64

# https://www.google.com/linuxrepositories/
# https://www.microsoft.com/net/core#linuxubuntu
# https://code.visualstudio.com/docs/setup/linux
# https://nodejs.org/en/download/package-manager/#debian-and-ubuntu-based-linux-distributions
# https://yarnpkg.com/lang/en/docs/install/
# https://golang.org/doc/install#tarball

# echo "Update and upgrade all the things..."

apt-get update -y
apt-get upgrade -y

echo "Some essentials..."
apt-get install -y curl wget git xclip vim git-daemon-run \
  apt-transport-https ca-certificates gnupg-agent build-essential software-properties-common

# Chrome setup
apt install chromium-browser

# Docker setup - https://docs.docker.com/install/linux/docker-ce/ubuntu/
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
add-apt-repository \
   "deb [arch=${ARCH}] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get update -y
apt-get install -y docker-ce docker-ce-cli containerd.io

# Docker Compose - https://docs.docker.com/compose/install/#install-compose-on-linux-systems
curl -L "https://github.com/docker/compose/releases/download/1.26.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# ASP.net setup, see - https://learn.microsoft.com/en-us/dotnet/core/install/linux-scripted-manual#scripted-install

# VS Code setup - https://code.visualstudio.com/docs/setup/linux
snap install --classic code

# Node setup - https://github.com/nodesource/distributions
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash - &&\
apt-get install -y nodejs

# build tools
apt-get install -y gcc g++ make

# Yarn setup - https://yarnpkg.com/lang/en/docs/install/#debian-stable
curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

apt-get update -y
apt install yarn -y

# Python 3 (ignoring version 2)
apt install -y python3 python3-pip
echo 'alias python=python3
' >> ~/.bash_aliases

apt install -y build-essential libssl-dev libffi-dev python3-dev
apt install -y  python3-dev

# Go
VERSION=1.15
OS=linux
wget https://dl.google.com/go/go$VERSION.$OS-$ARCH.tar.gz -O /tmp/go$VERSION.$OS-$ARCH.tar.gz
tar -C /usr/local -xzf /tmp/go$VERSION.$OS-$ARCH.tar.gz

# Using "~" in sudo context will get "/root" so wild guess the profile path:
USERS_PROFILE_FILENAME=/home/${SUDO_USER}/.profile
if grep -Fq "/usr/local/go/bin" $USERS_PROFILE_FILENAME
then
    echo "GO path found in $USERS_PROFILE_FILENAME"
else
    echo '
export PATH=$PATH:/usr/local/go/bin
' >> $USERS_PROFILE_FILENAME
fi

# adds the cuurent user who is sudo'ing to a docker group:
groupadd docker
usermod -aG docker $SUDO_USER
service docker restart
# note that typically you still need a logout/login for docker to work...

sudo apt autoremove -y

cat << EOF

# now....

code --install-extension ms-dotnettools.csharp
code --install-extension golang.go
code --install-extension dbaeumer.vscode-eslint
code --install-extension HookyQR.beautify
code --list-extensions

# git setup:

git config --global user.email "you@example.com"
git config --global user.name "Your Name"

ssh-keygen -t rsa -b 4096 -C "you@example.com"

eval "\$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa
xclip -sel clip < ~/.ssh/id_rsa.pub

# now go to https://github.com/settings/keys

# also check docker... you may need to login again for groups to sort out
# try >> docker run hello-world

# To use GO straight up, get the path:
source ~/.profile

EOF
