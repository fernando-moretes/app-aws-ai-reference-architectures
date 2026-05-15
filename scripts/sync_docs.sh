#!/usr/bin/env bash
# Copy architecture READMEs into docs/ so MkDocs can render them.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TARGET="$ROOT/docs/architectures"

mkdir -p "$TARGET"

for arch_dir in "$ROOT"/architectures/*/; do
  name=$(basename "$arch_dir")
  src="$arch_dir/README.md"
  dst="$TARGET/$name.md"
  if [[ -f "$src" ]]; then
    cp "$src" "$dst"
    echo "synced: $name"
  fi
done
