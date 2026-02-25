#!/bin/sh
# Re-encode all JPEGs to quality=75 and strip ALL metadata, recursively.

DIR="${1:-.}"

# Require ImageMagick
if ! command -v mogrify >/dev/null 2>&1; then
  echo "Error: ImageMagick not found. Install it (macOS): brew install imagemagick" >&2
  exit 1
fi

# Optional: dry-run if second arg is --dry-run
DRYRUN=0
[ "$2" = "--dry-run" ] && DRYRUN=1

# Find and process .jpg/.jpeg (case-insensitive)
# -strip removes EXIF/IPTC/XMP/color profiles/comments
# -quality 75 re-encodes
# -define jpeg:optimize-coding=true improves entropy coding (smaller files, same quality)
# -sampling-factor 4:2:0 is standard for photos (leave it out if you want to preserve original chroma)
find "$DIR" -type f \( -iname '*.jpg' -o -iname '*.jpeg' \) | while IFS= read -r img; do
  if [ $DRYRUN -eq 1 ]; then
    echo "[DRY-RUN] would process: $img"
  else
    mogrify -strip -quality 75 -define jpeg:optimize-coding=true -sampling-factor 4:2:0 "$img" || {
      echo "Failed to process: $img" >&2
    }
  fi
done

[ $DRYRUN -eq 1 ] && echo "Dry run complete. Nothing was modified."
