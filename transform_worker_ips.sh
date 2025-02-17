#!/bin/bash

# Check if the file is provided as an argument
if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <file with IPs>"
  exit 1
fi

# Read the file and convert the lines into a single line with space separation
result=$(tr '\n' ' ' < "$1")

# Print the result (remove the trailing space)
echo "${result%"${result##*[![:space:]]}"}"
