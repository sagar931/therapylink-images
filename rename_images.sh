#!/bin/bash

# Counter file (hidden)
COUNTER_FILE=".img_counter"

# Start from 1 if counter file doesn't exist
if [[ -f "$COUNTER_FILE" ]]; then
  COUNTER=$(cat "$COUNTER_FILE")
else
  COUNTER=1
fi

# Enable case-insensitive globbing
shopt -s nocaseglob

for FILE in *.png *.jpg *.jpeg; do
  # Skip if no matching files
  [[ -e "$FILE" ]] || continue

  # Skip files already renamed
  if [[ "$FILE" =~ ^IMG[0-9]{5}\.(png|jpg|jpeg)$ ]]; then
    continue
  fi

  EXT="${FILE##*.}"
  NEW_NAME=$(printf "IMG%05d.%s" "$COUNTER" "$EXT")

  # Avoid overwrite
  if [[ -e "$NEW_NAME" ]]; then
    echo "Skipping $FILE → $NEW_NAME already exists"
    continue
  fi

  mv "$FILE" "$NEW_NAME"
  echo "Renamed: $FILE → $NEW_NAME"

  COUNTER=$((COUNTER + 1))
done

# Save updated counter
echo "$COUNTER" > "$COUNTER_FILE"

echo "✅ Done. Next image number will start from $COUNTER"
