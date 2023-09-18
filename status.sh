#!/bin/bash

region=$(aws configure get region)

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
        ../../scripts/configure.sh $d
        echo "Status "$d
        zappa status $d
        [ -e zappa_settings.json ] && rm zappa_settings.json
      elif [[ "$function_name" == "" ]]; then
        echo "ERROR: requirements.txt missing for "$d
      fi
      cd -
    fi
  fi
done
