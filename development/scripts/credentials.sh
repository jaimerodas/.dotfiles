#! /bin/bash

set -e

# Sign into 1Password
source ~/.dotfiles/development/scripts/1password_auth.sh

echo "Making sure ~/.ssh exists..."
mkdir -p ~/.ssh
rm -f ~/.ssh/id_rsa*

printf "Creating id_rsa..."
op get document id_rsa >> ~/.ssh/id_rsa
echo " (success)"

printf "Creating id_rsa.pub..."
op get document id_rsa.pub >> ~/.ssh/id_rsa.pub
echo " (success)"

echo "Setting permissions..."
chmod 600 ~/.ssh/id_rsa*

echo "All done!"
