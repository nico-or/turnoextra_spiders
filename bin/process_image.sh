#!/bin/bash
set -e


# Use this script to process images in parallel
# $ find images/original -type f | parallel -j 4 ./process_image.sh {}
#

INPUT_PATH="$1"
INPUT_DIR="images/original"
OUTPUT_BASE="images/dist"
SIZES="1200x630 250x250 320x320 400x400 500x500 640x640 800x800"

relative_path="${INPUT_PATH#$INPUT_DIR/}"
base_name=$(basename "$relative_path")
dir_path=$(dirname "$relative_path")

# Step 0: Determine which sizes actually need to be created
missing_sizes=()
for sz in $SIZES; do
    out_dir="$OUTPUT_BASE/$sz/$dir_path"
    output_path="$out_dir/${base_name}.jpg"
    if [ ! -f "$output_path" ]; then
        missing_sizes+=("$sz")
    fi
done


# Early exit if all outputs already exist
if [ ${#missing_sizes[@]} -eq 0 ]; then
    echo "Skipping $INPUT_PATH — all sizes exist."
    exit 0
fi

echo "Processing $INPUT_PATH — missing sizes: ${missing_sizes[*]}"

# Step 1–3: Trim and pad image only if needed
tmp=$(mktemp --suffix=.png)
convert "$INPUT_PATH" -fuzz 5% -trim +repage "$tmp"

read w h <<< $(identify -format "%w %h" "$tmp")
max_dim=$(( w > h ? w : h ))
padding=$(awk "BEGIN { printf \"%d\", $max_dim * 0.1 }")

convert "$tmp" -bordercolor white -border "${padding}x${padding}" "$tmp"

# Step 4: Only generate the missing sizes
for sz in "${missing_sizes[@]}"; do
    out_dir="$OUTPUT_BASE/$sz/$dir_path"
    mkdir -p "$out_dir"
    output_path="$out_dir/${base_name}.jpg"

    convert "$tmp" \
        -resize "$sz" \
        -background white \
        -gravity center \
        -extent "$sz" \
        -quality 90 \
        "$output_path"
done

rm "$tmp"

