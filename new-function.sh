#!/bin/bash

if [[ $# < 1 ]]; then
  echo "Missing arg 1: function_name"
  exit 1
fi
function_name=$1

if [ -d "$functions/"$function_name ]; then
  echo $function_name" exists"
  exit 1
fi

project_name=$(basename `git rev-parse --show-toplevel`)

upper_function=$(echo $function_name | tr [:lower:] [:upper:] | sed 's/-/_/g')

echo "Create venv: $project_name-$function_name-venv"
pyenv virtualenv 3.9.15 $project_name-$function_name-venv

cp functions/example functions/$function_name
while IFS='' read -r a; do
    replaced=$(echo "${a//example/"$function_name"}")
    replaced=$(echo "${$replaced//EXAMPLE/"$upper_function"}")
    echo $replaced
done < functions/example/zappa_template.json > functions/$function_name/zappa_template.json
