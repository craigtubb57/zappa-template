#!/bin/bash

function_name=$1

force_update=""
if [[ $# > 1 ]]; then
  force_update="true"
fi

export AWS_REGION=$((env | grep AWS_REGION || aws configure get region) | sed 's/AWS_REGION=//g')
if [[ "$(echo $AWS_REGION)" == "" ]]; then
  echo "AWS Region not set"
  exit 1
fi

project_name=$(basename `git rev-parse --show-toplevel`)

export AWS_ACCOUNT=$(aws sts get-caller-identity --query Account --output text)
export PROJECT_NAME=$project_name
export EVENT_SOURCE=$AWS_ACCOUNT"-"$project_name
export FUNCTION_NAME=$function_name

eval "$(../../scripts/libs-layer.sh $function_name $force_update | tail -1)"

python ../../util/generate_settings.py ''$function_name''
