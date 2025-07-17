#!/bin/bash

FLAVOR=$1
DATE=$(date +%b%-d)
OUTPUT_DIR="build/app/outputs/flutter-apk"
PREFIX="etms-$DATE"

# Function to rename if file exists
rename_if_exists () {
  local from="$1"
  local to="$2"
  if [ -f "$from" ]; then
    mv "$from" "$to"
    echo "Renamed: $to"
  else
    echo "Skipped (not found): $from"
  fi
}

rename_if_exists "$OUTPUT_DIR/app-armeabi-v7a-release.apk" "$OUTPUT_DIR/$PREFIX-v7a.apk"
rename_if_exists "$OUTPUT_DIR/app-arm64-v8a-release.apk" "$OUTPUT_DIR/$PREFIX-v8a.apk"
rename_if_exists "$OUTPUT_DIR/app-x86_64-release.apk"     "$OUTPUT_DIR/$PREFIX-x86_64.apk"
