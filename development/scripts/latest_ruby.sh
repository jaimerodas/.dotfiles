#! /bin/bash

set -e

echo "Updating ruby-build..."
if [ $(brew upgrade ruby-build) &> /dev/null ]; then
	echo "Successfuly upgraded"
fi

current_ruby=$(rbenv version-name)
ruby_version=$(rbenv install -l | sed -e 's/^[ ]*//' | grep -E '^\d+\.\d+\.\d+$' | tail -n 1)

if [ "$ruby_version" == "$current_ruby" ]; then
	echo "You already have the latest ruby version installed"
	exit 0
fi

echo "Current ruby version: $current_ruby"
echo "Installing ruby $ruby_version"

rbenv install -s $ruby_version && rbenv global $ruby_version
