#!/bin/bash

grep_result=$(grep -RnE "^\s*(//|#|\!|'|;)\s*(TODO|FIXME).*")

while IFS=':' read -r path line message; do
  echo "::warning file=${path},line=${line}::${message}"
done <<< "$grep_result"
