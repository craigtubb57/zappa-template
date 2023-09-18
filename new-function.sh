#!/bin/bash

if [[ $# < 1 ]]; then
  echo "Missing arg 1: function_name"
  exit 1
fi
function_name=$1
echo "FUNCTION: "$function_name

overwrite=false
if [[ $# > 1 ]]; then
  overwrite=true
  echo "OVERWRITE: "$overwrite
fi

if [ -d "functions/"$function_name ]; then
  if [ $overwrite == true ]; then
    echo "Removing previous function directory..."
    rm -r functions/$function_name
  else
    echo $function_name" exists"
    exit 1
  fi
fi

project_name=$(basename `git rev-parse --show-toplevel`)

upper_function=$(echo $function_name | tr [:lower:] [:upper:] | sed 's/-/_/g')

echo "Creating venv: $project_name-$function_name-venv..."
result=$(pyenv virtualenv 3.9.15 $project_name-$function_name-venv)

echo "Creating function directory..."
cp -r functions/example functions/$function_name

echo "Creating Zappa template..."
cat functions/example/zappa_template.json | sed 's/EXAMPLE/'$upper_function'/g' | sed 's/example/'$function_name'/g' > functions/$function_name/zappa_template.json
