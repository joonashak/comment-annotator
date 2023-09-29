#!/bin/bash

# Default regex pattern can be overridden with $PATTERN env var.
default_pattern="^\s*(//|#|\!|'|;)\s*(TODO|FIXME).*"
pattern=${PATTERN:-$default_pattern}

# Parsed files can be limited with glob pattern in $INCLUDE env var.
include=${INCLUDE:-"*"}

grep_result=$(grep -RnE --exclude-dir=.git --include="$include" "$pattern")

# Group TODO and FIXME-like annotations by using different annotation severity.
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

# Iterate over grep results, printing annotation strings.
while IFS=':' read -r path line message; do
  # Grep might return an empty result. Skip those.
  if [[ -z $message ]]; then
    continue
  fi

  set_ann_type "$message"
  echo "::${ANN_TYPE} file=${path},line=${line}::${message}"
done <<< "$grep_result"
