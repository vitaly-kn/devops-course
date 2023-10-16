#!/bin/bash
threshold=8000000
if [ -n "$1" ]; then
  threshold=$1
fi
avail=`df --output=avail / | grep '[0-9]'`
echo "Available disk space is $avail bytes"
if [ $avail -lt $threshold ]; then
  echo "WARNING! Disk free space is below that threshold set for this system ($threshold bytes)"
fi
