#!/bin/bash

set -e

environment=${1:-jobs}
environment="$(tr '[:lower:]' '[:upper:]' <<< ${environment:0:1})${environment:1}"
environment_name=Enconta-$environment

function list {
	aws elasticbeanstalk describe-environment-resources --environment-name "$environment_name" |
		grep INSTANCES |
		awk '{print $2}' |
		xargs aws ec2 describe-instances --instance-ids |
		grep INSTANCES |
		awk '{print $15}'
}

list
