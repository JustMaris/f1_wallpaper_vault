#!/bin/zsh

find . -type d -not -path "*/.git/*" | while read -r dir; do
  # Skip folders that contain subfolders
  if find "$dir" -mindepth 1 -type d | grep -q .; then
    continue
  fi

  cd "$dir" || continue

  # Ensure we're inside a Git repo
  if git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    git add .
    if ! git diff --cached --quiet; then
      msg="Update: ${PWD#$(git rev-parse --show-toplevel)/}"
      git commit -m "$msg"
      git push
      echo "Committed and pushed: $msg"
    fi
  fi

  cd - > /dev/null
done
