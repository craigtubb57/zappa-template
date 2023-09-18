#!/bin/bash

project_name=$(basename `git rev-parse --show-toplevel`)

echo "Create venv: $project_name-venv"
pyenv virtualenv 3.9.15 $project_name-venv

for f in functions/* ; do
  if [ -d "$f" ]; then
    function_name=${f##*/}
    if [[ $function_name != example ]]; then
      echo "Create venv: $project_name-$function_name-venv"
      pyenv virtualenv 3.9.15 $project_name-$function_name-venv
    fi
  fi
done
