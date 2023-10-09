#!/bin/bash

if [[ $# < 1 ]]; then
  echo "Missing arg 1: function_name"
  exit 1
fi
function_name=$1

project_name=$(basename `git rev-parse --show-toplevel`)

test_venv_name="$project_name-$function_name-test-venv"

"${PYENV_ROOT}/versions/$test_venv_name/bin/pip" install -r functions/$function_name/requirements.txt

"${PYENV_ROOT}/versions/$test_venv_name/bin/python" -m unittest
