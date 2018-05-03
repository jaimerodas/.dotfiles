#! /bin/bash

set -e

region=${1:-"us-west-2"}

# Try and create a 1Password session from the other script
source ~/.dotfiles/development/scripts/1password_auth.sh

aws_credentials=$(op get item AWS | 
	jq '.details.sections[] | 
	  select(.title=="API Key").fields as $fields | 
		{
			access_key: ($fields[] | select(.t=="access_key").v), 
			secret_key: ($fields[] | select(.t=="secret_access_key").v) 
		}')

access_key=$(echo $aws_credentials | jq -r '.access_key')
secret_key=$(echo $aws_credentials | jq -r '.secret_key')

# Create what's needed in order for the aws cli to work
echo "Installing credentials"

rm -fr ~/.aws
mkdir -p ~/.aws
echo "[default]" >> ~/.aws/config
echo "output = text" >> ~/.aws/config
echo "region = $region" >> ~/.aws/config

echo "[default]" >> ~/.aws/credentials
echo "aws_access_key_id = $access_key" >> ~/.aws/credentials
echo "aws_secret_access_key = $secret_key" >> ~/.aws/credentials

success_message "AWS Credentials created"

# Download the PEM files to access remote servers
certificates=(encontaapp-prod encontaapp-stg talento)

mkdir -p ~/.ssh

echo "Installing Certificates"

for cert in ${certificates[@]} ; do
	file_name=$cert".pem"
	file_path=~/.ssh/$file_name

	echo "Creating certificate ${cert}..."

	rm -f $file_path
	op get document $file_name >> $file_path
	chmod 600 $file_path
done

success_message "Certificates created"

