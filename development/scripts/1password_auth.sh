#! /bin/bash

set -e

SUBDOMAIN=rodas
ACCOUNT_EMAIL="jaime@rodas.mx"

print_separator() {
	echo "---------------------------"
}

fail_with_message() {
	tput setaf 1
	echo $1
	tput sgr0
	print_separator
	exit 1
}

success_message() {
	tput setaf 2
	echo $1
	tput sgr0
	print_separator
}

if ! [ -x "$(command -v op)" ]; then
	fail_with_message "Error: 1Password cli not installed"
fi

if [ $(op list users &> /dev/null) ]; then
	success_message "Already signed into 1Password"
	exit 0
fi

read -p "Enter your 1Password Account Key: " SECRET_KEY
echo ""
print_separator

echo "Signing into 1Password..."
eval $(op signin "$SUBDOMAIN.1password.com" "$ACCOUNT_EMAIL" "$SECRET_KEY")

if ! [[ $(op list users) ]]; then
	fail_with_message "Authentication failed"
fi

success_message "Signed in successfully"
