#!/bin/bash

region=$(aws configure get region)

function_name=""
if [[ $# > 0 ]]; then
  function_name=$1
fi

force_update=""
if [[ $# > 1 ]]; then
  force_update="true"
fi

pip install -r requirements.txt

for f in functions/* ; do
  if [ -d "$f" ]; then
    func=${f##*/}
    if [[ $func != example ]]; then
      if [[ "$function_name" == "" ]] || [[ "$function_name" == "$func" ]]; then
        echo "Function: "$func
        cd functions/$func
        if [[ -f "requirements.txt" ]] && [[ -f "main.py" ]]; then
          ../../scripts/configure.sh $func $force_update
          if [[ $? -ne 0 ]]; then
            exit 1
          fi
          status=$(zappa status $func)
          if [[ $status == *Error* ]]; then
            echo "Update "$func
            zappa update $func
          else
            echo "Deploy "$func
            zappa deploy $func
          fi
          [ -e zappa_settings.json ] && rm zappa_settings.json
        elif [[ "$function_name" == "" ]]; then
          echo "ERROR: requirements.txt missing for "$func
        fi
        cd -
      fi
    fi
  fi
done
