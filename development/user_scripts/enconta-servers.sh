#!/bin/bash

set -e

environment=${1:-jobs}
environment_name=encontaapp-$environment
username=ec2-user
pem_file=~/.ssh/$environment_name.pem

function list {
	aws elasticbeanstalk describe-environment-resources --environment-name "$environment_name" |
		grep INSTANCES |
		awk '{print $2}' |
		xargs aws ec2 describe-instances --instance-ids |
		grep INSTANCES |
		awk '{print $15}'
}

list
