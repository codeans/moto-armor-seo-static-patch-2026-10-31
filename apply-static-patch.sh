#!/bin/bash
set -euo pipefail
ROOT=/home/u231275295/domains/getmotoarmor.com/public_html
SRC=$ROOT/_seo_static_patch
FLAG=$ROOT/backend/storage/app/seo-static-apply-2026-10-31.done
LOG=$ROOT/backend/storage/app/seo-static-apply-2026-10-31.log
if [ -f "$FLAG" ]; then exit 0; fi
{
  echo "START $(date -Is)"
  cd "$SRC"
  # assets first
  if [ -d assets ]; then
    mkdir -p "$ROOT/assets"
    find assets -type f ! -path '*/.git/*' -print0 | while IFS= read -r -d '' f; do
      mkdir -p "$ROOT/$(dirname "$f")"
      cp -f "$f" "$ROOT/$f"
    done
  fi
  # txt/json/xml next
  find . -type f \( -name '*.txt' -o -name '*.json' -o -name '*.xml' \) ! -path './.git/*' ! -name 'apply-static-patch.sh' -print0 | while IFS= read -r -d '' f; do
    f="${f#./}"
    mkdir -p "$ROOT/$(dirname "$f")"
    cp -f "$f" "$ROOT/$f"
  done
  # html except index.html
  find . -type f -name '*.html' ! -path './.git/*' ! -name 'index.html' -print0 | while IFS= read -r -d '' f; do
    f="${f#./}"
    mkdir -p "$ROOT/$(dirname "$f")"
    cp -f "$f" "$ROOT/$f"
  done
  # nested index.html files (guide pages etc) — all index.html including root last
  find . -type f -name 'index.html' ! -path './.git/*' ! -path './index.html' -print0 | while IFS= read -r -d '' f; do
    f="${f#./}"
    mkdir -p "$ROOT/$(dirname "$f")"
    cp -f "$f" "$ROOT/$f"
  done
  if [ -f ./index.html ]; then
    cp -f ./index.html "$ROOT/index.html"
  fi
  echo OK > "$FLAG"
  echo "END $(date -Is) exit:$?"
} >>"$LOG" 2>&1
