#!/bin/bash

region=$(aws configure get region)

function_name=""
if [[ $# > 0 ]]; then
  function_name=$1
fi

pip install -r requirements.txt

for f in functions/* ; do
  if [ -d "$f" ]; then
    func=${f##*/}
    if [[ $func != example ]]; then
      if [[ "$function_name" == "" ]] || [[ "$function_name" == "$func" ]]; then
        cd functions/$func
        if [[ -f "requirements.txt" ]]; then
          ../../scripts/configure.sh $func
          echo "Status "$func
          zappa status $func
          [ -e zappa_settings.json ] && rm zappa_settings.json
        elif [[ "$function_name" == "" ]]; then
          echo "ERROR: requirements.txt missing for "$func
        fi
        cd -
      fi
    fi
  fi
done
