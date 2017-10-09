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
apt-get install -y curl wget git xclip

# Chrome setup
wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
echo 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' | sudo tee /etc/apt/sources.list.d/google-chrome.list

# ASP.net setup
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/microsoft-ubuntu-xenial-prod xenial main" > /etc/apt/sources.list.d/dotnetdev.list'

# VS Code setup
sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'

# Node setup
curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -

# Yarn setup
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

apt-get update -y

echo "Install Chrome..."
apt-get install -y google-chrome-stable

echo "Install ASP.NET and VS Code..."
apt-get install -y dotnet-sdk-2.0.0 code


echo "Node etc"
apt-get install -y nodejs npm yarn build-essential

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

eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa
xclip -sel clip < ~/.ssh/id_rsa.pub

# now go to https://github.com/settings/keys

EOF
