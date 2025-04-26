#!/usr/bin/env bash

# === Require 2 args ===
if [ "$#" -ne 2 ]; then
  echo "Usage: $0 <source-folder> <output-prefix>"
  echo "Example: $0 my-project dragon-dance-build"
  exit 1
fi

SOURCE="$1"
PREFIX="$2"
CLEANED="${PREFIX}-clean"

# === Step 1: Copy clean version ===
echo "🧹 Copying clean version to '${CLEANED}'..."
cp -r "$SOURCE" "$CLEANED"
rm -rf "$CLEANED/node_modules" "$CLEANED/.git" "$CLEANED/.github" "$CLEANED/dist"
find "$CLEANED" -type f \( -iname "*.md5" -o -iname "*.sha1" -o -iname "*.zip" \) -exec rm -f {} \;

# === Step 2: Generate .md5 and .sha1 for all files in clean copy ===
echo "🔏 Generating checksums..."
find "$CLEANED" -type f -exec md5sum {} \; > "${PREFIX}.md5"
find "$CLEANED" -type f -exec sha1sum {} \; > "${PREFIX}.sha1"

# === Step 3: Zip the cleaned copy (exclude the generated .md5/.sha1) ===
echo "📦 Creating zip: ${PREFIX}.zip..."
zip -r "${PREFIX}.zip" "$CLEANED" > /dev/null

# === Step 4: Clean up clean copy ===
echo "🧹 Removing temp cleaned folder: $CLEANED"
rm -rf "$CLEANED"

# === Done ===
echo "✅ All done:"
echo " → ${PREFIX}.zip"
echo " → ${PREFIX}.md5"
echo " → ${PREFIX}.sha1"
