#!/bin/bash

# Usage check
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <logfile>"
    exit 1
fi

# Input and output file names
INPUT_FILE=$1
MERGED_FILE="topic_SHA1"
CONFLICT_FILE="topic_conflict"

# Create or clear the output file
> "$MERGED_FILE"
> "$CONFLICT_FILE"

# Write header
printf "%-20s %*s\n" "Name" 20 "SHA" >> "$MERGED_FILE"
printf "%s\n" "--------------------------------------------------------" >> "$MERGED_FILE"
printf "%-20s %*s\n" "Name" 20 "SHA" >> "$CONFLICT_FILE"
printf "%s\n" "--------------------------------------------------------" >> "$CONFLICT_FILE"

while read -r line; do
  echo "$line" | grep -E "^Merge successful : .+ : [a-fA-F0-9]{7,40}$"
  if [ $? -eq 0 ]; then
    branch=$(echo "$line" | cut -d':' -f2 | xargs)
    sha=$(echo "$line" | cut -d':' -f3 | xargs)
    printf "%-20s %*s\n" "$branch" 45 "$sha" >> "$MERGED_FILE"
  fi

  echo "$line" | grep -E "^Merge conflict : .+ : [a-fA-F0-9]{7,40}$"
  if [ $? -eq 0 ]; then
    branch=$(echo "$line" | cut -d':' -f2 | xargs)
    sha=$(echo "$line" | cut -d':' -f3 | xargs)
    printf "%-20s %*s\n" "$branch" 45 "$sha" >> "$CONFLICT_FILE"
  fi

done < "$INPUT_FILE"
