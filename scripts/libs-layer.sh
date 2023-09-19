#!/bin/bash

function_name=$1

force_update=""
if [[ $# > 1 ]]; then
  force_update="true"
fi

project_name=$(basename `git rev-parse --show-toplevel`)

layer_name=$project_name"_"$function_name"_libs"
upper_version=$(echo $function_name"_libs_version" | tr '[:lower:]' '[:upper:]')
echo "Checking lambda layer: "$layer_name
version=$(aws lambda list-layer-versions --layer-name $layer_name --region $AWS_REGION --query 'max_by(LayerVersions, &Version).Version' --output text)

[ -e $layer_name".zip" ] && rm $layer_name".zip"
[ -e python ] && rm -rf python

if [[ "$version" == "None" ]] || [[ "$force_update" == "true" ]]; then
  docker run -v "$PWD":/var/task "public.ecr.aws/sam/build-python3.9:latest" /bin/sh -c "pip install -r requirements.txt -t python/lib/python3.9/site-packages/; exit"

  zip -r $layer_name".zip" python > /dev/null

  version=$(aws lambda publish-layer-version --layer-name $layer_name --description $project_name" - "$function_name" libs" --zip-file fileb://$layer_name".zip" --compatible-runtimes "python3.9" --query 'Version' --output text)

  [ -e $layer_name".zip" ] && rm $layer_name".zip"
  [ -e python ] && rm -rf python
fi

echo "export "$upper_version"="$version
