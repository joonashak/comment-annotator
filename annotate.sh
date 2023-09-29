#!/bin/bash

GREP=$(grep -Rn "// TODO:")

while IFS=':' read -r path line message; do
  echo "::warning file=${path},line=${line}::${message}"
done <<< "$GREP"
