#!/bin/bash

if [[ $# < 1 ]]; then
  echo "Missing arg 1: function_name"
  exit 1
fi
function_name=$1

set -o allexport
source .env
set +o allexport

project_name=$(basename `git rev-parse --show-toplevel`)

venv_name="$project_name-$function_name-venv"

event=$(cat "events/"$function_name".json")

echo $venv_name > functions/$function_name/.python-version
cd functions/$function_name

upper_project=$(echo $project_name | tr [:lower:] [:upper:] | sed 's/-/_/g')
upper_function=$(echo $function_name | tr [:lower:] [:upper:] | sed 's/-/_/g')

# export any project-function specific environment variables
# looks for any named: {PROJECT_NAME}_{FUNCTION_NAME}_{VAR_NAME}
# e.g. ZAPPA_TEMPLATE_EXAMPLE_MY_ENV_VAR
pattern="echo \${!${upper_project}_${upper_function}_@}"
for var in $(eval $pattern); do
  export $(echo $var | sed 's/'$upper_project'_'$upper_function'_//g')="${!var}"
done

pip install -r requirements.txt

python main.py ''${event}'' '{}'

cd -

rm functions/$function_name/.python-version
