#!/usr/bin/env sh
#
# Rebuild the JavaScript bundle that the demo pages load.
#
# `moon build --target js --release` emits the module but does not export the
# entry point the host page needs. `run.js` drives the CAD benchmark through
# `window.moon_step`, so the two export lines below are appended to the build
# output. Those lines used to be patched in by hand, which is how the committed
# `examples/canvas/canvas.js` could silently drift away from `src/`.
#
# Usage: sh scripts/build_demo.sh
#
set -eu

ROOT=$(cd "$(dirname "$0")/.." && pwd)
BUILD="$ROOT/_build/js/release/build/examples/canvas/canvas.js"
OUT="$ROOT/examples/canvas/canvas.js"

cd "$ROOT"
moon build --target js --release

if [ ! -f "$BUILD" ]; then
  echo "error: build output not found: $BUILD" >&2
  exit 1
fi

STEP=$(grep -oE 'function (_M0[A-Za-z0-9_]*4step)\(' "$BUILD" |
  head -n 1 |
  sed -e 's/^function //' -e 's/($//')

if [ -z "$STEP" ]; then
  echo "error: could not locate the canvas.step entry point in the build output" >&2
  exit 1
fi

cp "$BUILD" "$OUT"
{
  echo
  echo "if (typeof window !== 'undefined') window.moon_step = $STEP;"
  echo "if (typeof globalThis !== 'undefined') globalThis.moon_step = $STEP;"
} >> "$OUT"

echo "wrote $OUT (entry point: $STEP)"
