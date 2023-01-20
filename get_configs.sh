#!/bin/bash

appConfName=$1
input=$2
label=$3
hideSecrets=$4

echo "$(tput -T xterm setaf 4)Getting configs from $appConfName and hiding secrets: $hideSecrets"

configs=$(az appconfig kv list \
  --name $appConfName \
  --auth-mode login \
  --resolve-keyvault \
  --label $label)

while read -r line; do
  echo "::debug::Reading line: $line"
  if [ -z "$line" ] 
  then 
    echo "::debug::Line is empty, skipping"
    continue
  fi

  envVariableName="${line%=*}"
  configName="${line#*=}"
  echo "Environment variable name: $envVariableName, config name: $configName"

  configValue=$(jq ".[] | select(.key == \"$configName\") | .value" <<< "$configs")
  if [ "$hideSecrets" = true ]; then
      echo "::add-mask::$configValue"
      echo "Secret name: $configName value: $configValue"
  else
      echo "Config name: $configName value: $configValue"
  fi
  echo "$envVariableName=$configValue" >> "$GITHUB_ENV"
done <<< "$input"
