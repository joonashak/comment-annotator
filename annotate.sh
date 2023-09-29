#!/bin/bash

grep_result=$(grep -RnE "^\s*(//|#|\!|'|;)\s*(TODO|FIXME).*")

set_ann_type () {
  if [[ $1 =~ "TODO" ]]
  then
    ANN_TYPE="warning"
  elif [[ $1 =~ "FIXME" ]]
  then
    ANN_TYPE="error"
  else
    ANN_TYPE="notice"
  fi
}

while IFS=':' read -r path line message; do
  set_ann_type "$message"
  echo "::${ANN_TYPE} file=${path},line=${line}::${message}"
done <<< "$grep_result"
