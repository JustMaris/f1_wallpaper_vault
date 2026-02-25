#!/bin/zsh

find . -type d -not -path "*/.git/*" | while read -r dir; do
  # Skip folders that contain subfolders (non-leaves)
  if find "$dir" -mindepth 1 -type d | grep -q .; then
    continue
  fi

  # Ensure it's inside a Git repo
  if git -C "$dir" rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    # Check if this leaf has changes (untracked or modified)
    if ! git -C "$dir" status --porcelain | grep -q .; then
      continue
    fi

    cd "$dir" || continue
    git add .

    # Commit if staging produced anything
    if ! git diff --cached --quiet; then
      msg="Update: ${PWD#$(git rev-parse --show-toplevel)/}"
      git commit -m "$msg"
      git push
      echo "Committed and pushed: $msg"
    fi

    cd - > /dev/null
  fi
done
