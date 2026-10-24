#!/usr/bin/env bash
# Vercel build: install Flutter, synthesize placeholder audio from the game's
# data tables, then build the release web bundle. Audio is regenerated here
# so the repo/upload stays text-only.
set -euo pipefail

# Deployments upload the source as one compressed blob (src.tar.gz.b64);
# unpack it in place. Local runs (source already on disk) skip this.
if [ -f src.tar.gz.b64 ]; then
  echo "── unpacking source blob…"
  base64 -d src.tar.gz.b64 | tar xz
fi

command -v unzip >/dev/null || dnf install -y unzip || yum install -y unzip || true

FLUTTER_DIR="/tmp/flutter"
if [ ! -x "$FLUTTER_DIR/bin/flutter" ]; then
  echo "── cloning Flutter stable…"
  git clone --depth 1 -b 3.32.5 https://github.com/flutter/flutter.git "$FLUTTER_DIR"
fi
export PATH="$FLUTTER_DIR/bin:$PATH"
flutter config --no-analytics >/dev/null || true
flutter --version

echo "── pub get…"
flutter pub get

mkdir -p assets/audio/sfx assets/audio/voice/jamo assets/audio/voice/syllable \
  assets/audio/voice/word assets/audio/voice/ui assets/audio/voice/phrase

echo "── synthesizing sfx…"
dart run tool/gen_sfx.dart

echo "── synthesizing voice (TTS)…"
dart run tool/gen_tts_jobs.dart > tool/tts_jobs.json
dart run tool/edge_tts.dart || echo "WARN: some voice slots failed; app degrades to silence per-slot"

echo "── audio manifest…"
dart run tool/gen_audio_manifest.dart

echo "── flutter build web…"
flutter build web --release

echo "── done: $(find build/web -type f | wc -l) files"
