#!/bin/bash

function_name=""
if [[ $# > 0 ]]; then
  function_name=$1
fi

pip install -r requirements.txt

for f in functions/* ; do
  if [ -d "$f" ]; then
    d=${f##*/}
    if [[ "$function_name" == "" ]] || [[ "$function_name" == "$d" ]]; then
      cd functions/$d
      if [[ -f "requirements.txt" ]]; then
        ../../scripts/configure.sh $d $force_update
        status=$(zappa status $d)
        if [[ $status == *Error* ]]; then
          echo "Already undeployed: "$d
        else
          echo "Undeploy "$d
          zappa undeploy $d
        fi
        [ -e zappa_settings.json ] && rm zappa_settings.json
      elif [[ "$function_name" == "" ]]; then
        echo "ERROR: requirements.txt missing for "$d
      fi
      cd -
    fi
  fi
done
