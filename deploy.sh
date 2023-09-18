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
    d=${f##*/}
    if [[ $d != example ]]; then
      if [[ "$function_name" == "" ]] || [[ "$function_name" == "$d" ]]; then
        cd functions/$d
        if [[ -f "requirements.txt" ]]; then
          ../../scripts/configure.sh $d $force_update
          if [[ $? -ne 0 ]]; then
            exit 1
          fi
          status=$(zappa status $d)
          if [[ $status == *Error* ]]; then
            echo "Update "$d
            zappa update $d
          else
            echo "Deploy "$d
            zappa deploy $d
          fi
          [ -e zappa_settings.json ] && rm zappa_settings.json
        elif [[ "$function_name" == "" ]]; then
          echo "ERROR: requirements.txt missing for "$d
        fi
        cd -
      fi
    fi
  fi
done
