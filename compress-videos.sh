#!/bin/bash
# ═══════════════════════════════════════════════════════════════
#  MATO VIDEO COMPRESSION SCRIPT
#  Run this in the same folder as your videos
#  Requires: ffmpeg (free download → https://ffmpeg.org)
# ═══════════════════════════════════════════════════════════════

# ── voda.mp4 (homepage hero — short loop, needs to load FAST) ──
# Target: under 5MB, 1080p max, H.264 for universal browser support
# CRF 28 = good quality / small size balance (lower = better quality)
ffmpeg -i voda.mp4 \
  -c:v libx264 \
  -crf 28 \
  -preset slow \
  -vf "scale='min(1920,iw)':-2" \
  -c:a aac -b:a 96k \
  -movflags +faststart \
  -y voda_compressed.mp4

echo "✅ voda.mp4 done → voda_compressed.mp4"


# ── skok.mp4 (about section — 1:36 min, needs to stream smoothly) ──
# Target: under 15MB, 1080p, H.264, audio kept
# CRF 26 = slightly better quality for longer video
ffmpeg -i skok.mp4 \
  -c:v libx264 \
  -crf 26 \
  -preset slow \
  -vf "scale='min(1920,iw)':-2" \
  -c:a aac -b:a 96k \
  -movflags +faststart \
  -y skok_compressed.mp4

echo "✅ skok.mp4 done → skok_compressed.mp4"


# ── WebM versions (VP9 — 25% smaller, muted videi nemaju audio) ──
# Chrome/Firefox prefer WebM, Safari falls back to MP4
# -an = no audio (videi su muted, audio nije potreban → manji fajl)
# -deadline good -cpu-used 2 = dobar balans brzina/kvalitet

ffmpeg -i voda_compressed.mp4 \
  -c:v libvpx-vp9 -crf 33 -b:v 0 \
  -an \
  -deadline good -cpu-used 2 \
  -y videos/voda_compressed.webm

echo "✅ voda WebM done → videos/voda_compressed.webm"

ffmpeg -i skok_compressed.mp4 \
  -c:v libvpx-vp9 -crf 30 -b:v 0 \
  -an \
  -deadline good -cpu-used 2 \
  -y videos/skok_compressed.webm

echo "✅ skok WebM done → videos/skok_compressed.webm"

echo ""
echo "All done! Check file sizes:"
ls -lh voda_compressed.mp4 skok_compressed.mp4 videos/voda_compressed.webm videos/skok_compressed.webm 2>/dev/null
