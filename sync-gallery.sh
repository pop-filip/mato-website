#!/usr/bin/env bash
# Syncs Nextcloud gallery folder → /var/www/matografie.at/gallery/
# and regenerates gallery/index.json with auto thumbnails for videos
#
# Requirements:
#   - rclone configured with remote named "nextcloud"
#     rclone config → new remote → WebDAV → https://cloud.digitalnature.at/remote.php/dav/files/USERNAME/
#   - ffmpeg (apt install ffmpeg) for video thumbnails

set -euo pipefail

NEXTCLOUD_REMOTE="nextcloud:Matografie/gallery"
WEB_ROOT="/var/www/matografie.at"
GALLERY_DIR="$WEB_ROOT/gallery"
THUMBS_DIR="$GALLERY_DIR/thumbs"
MANIFEST="$GALLERY_DIR/index.json"
LOG="/var/log/gallery-sync.log"

IMAGE_EXT="jpg jpeg png webp gif avif"
VIDEO_EXT="mp4 mov webm"

log() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" >> "$LOG"; }

log "Sync started"

mkdir -p "$THUMBS_DIR"

# ── 1. Sync files from Nextcloud ───────────────────────────────
rclone sync "$NEXTCLOUD_REMOTE" "$GALLERY_DIR" \
  --include "*.{jpg,jpeg,png,webp,gif,avif,mp4,mov,webm,JPG,JPEG,PNG,MP4,MOV}" \
  --exclude "index.json" \
  --exclude "thumbs/**" \
  --transfers 4 \
  --log-file "$LOG" \
  --log-level INFO \
  2>> "$LOG" || { log "rclone error"; exit 1; }

log "rclone sync complete"

# ── 2. Generate missing video thumbnails ───────────────────────
if command -v ffmpeg &>/dev/null; then
  for f in "$GALLERY_DIR"/*.{mp4,mov,webm,MP4,MOV} 2>/dev/null; do
    [[ -f "$f" ]] || continue
    fname=$(basename "$f")
    thumb_name="${fname%.*}_thumb.jpg"
    thumb_path="$THUMBS_DIR/$thumb_name"
    if [[ ! -f "$thumb_path" ]]; then
      ffmpeg -i "$f" -ss 00:00:01 -vframes 1 -vf "scale=640:-1" \
        -q:v 4 "$thumb_path" -y -loglevel quiet 2>>"$LOG" \
        && log "Thumbnail: $thumb_name" \
        || log "Thumbnail failed: $fname"
    fi
  done
else
  log "ffmpeg not found — skipping thumbnail generation"
fi

# ── 3. Regenerate index.json ───────────────────────────────────
TMP_ITEMS=""

for f in "$GALLERY_DIR"/*; do
  [[ -f "$f" ]] || continue
  fname=$(basename "$f")
  ext="${fname##*.}"
  ext_lower=$(echo "$ext" | tr '[:upper:]' '[:lower:]')

  TYPE=""
  for e in $IMAGE_EXT; do [[ "$ext_lower" == "$e" ]] && TYPE="image" && break; done
  for e in $VIDEO_EXT; do [[ "$ext_lower" == "$e" ]] && TYPE="video" && break; done
  [[ -z "$TYPE" ]] && continue

  FDATE=$(date -r "$f" '+%Y-%m-%dT%H:%M:%SZ' 2>/dev/null || date '+%Y-%m-%dT%H:%M:%SZ')

  if [[ "$TYPE" == "video" ]]; then
    thumb_name="${fname%.*}_thumb.jpg"
    if [[ -f "$THUMBS_DIR/$thumb_name" ]]; then
      ENTRY="{\"type\":\"video\",\"file\":\"$fname\",\"thumb\":\"thumbs/$thumb_name\",\"date\":\"$FDATE\"}"
    else
      ENTRY="{\"type\":\"video\",\"file\":\"$fname\",\"date\":\"$FDATE\"}"
    fi
  else
    ENTRY="{\"type\":\"image\",\"file\":\"$fname\",\"date\":\"$FDATE\"}"
  fi

  TMP_ITEMS="${TMP_ITEMS:+$TMP_ITEMS,}$ENTRY"
done

UPDATED=$(date '+%Y-%m-%dT%H:%M:%SZ')
echo "{\"updated\":\"$UPDATED\",\"items\":[${TMP_ITEMS}]}" > "$MANIFEST"

COUNT=$(echo "$TMP_ITEMS" | grep -o '"type"' | wc -l | tr -d ' ')
log "Manifest updated — $COUNT items"
