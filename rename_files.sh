#!/bin/bash

# Directory to process (defaults to current dir)
DIR="${1:-.}"

cd "$DIR" || exit 1

for f in *; do
  # Only process files with " - " in the name
  if [[ "$f" == *" - "* ]]; then
    # Extract part after the first " - "
    newname="${f#* - }"
    # Rename file
    mv -n "$f" "$newname"
    echo "Renamed: $f -> $newname"
  fi
done
