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
echo "project_name: "$project_name

export AWS_ACCOUNT=$(aws sts get-caller-identity --query Account --output text)
export PROJECT_NAME=$project_name
export EVENT_SOURCE=$AWS_ACCOUNT"-"$project_name
export FUNCTION_NAME=$function_name

upper_project=$(echo $project_name | tr [:lower:] [:upper:] | sed 's/-/_/g')
upper_function=$(echo $function_name | tr [:lower:] [:upper:] | sed 's/-/_/g')

# export any project-function specific environment variables
# looks for any named: {PROJECT_NAME}_{FUNCTION_NAME}_{VAR_NAME}
# e.g. ZAPPA_TEMPLATE_EXAMPLE_MY_ENV_VAR
for var in "${!"$upper_project"_"$upper_function"_@}"; do
    export $(echo $var | sed 's/'$upper_project'_'$upper_function'_//g')="${!var}"
done

result="$(../../scripts/libs-layer.sh $function_name $force_update | tail -1)"
echo "libs-layer result: "$result
eval $result

python ../../util/generate_settings.py ''$function_name''
