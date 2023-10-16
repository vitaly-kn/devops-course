#!/bin/bash
directory="./"
if [ -n "$1" ]; then
  directory=$1
fi
files=`find $directory -type f -name '*' | wc -l`
echo "Directory \"$directory\" contains $files file(s)"
