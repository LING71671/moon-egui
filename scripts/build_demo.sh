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

# Match the module-qualified mangled name of `examples/canvas.step`; the bare
# `4step` suffix also matches widget methods such as `Knob::step`.
STEP=$(grep -oE 'function (_M0[A-Za-z0-9_]*8examples6canvas4step)\(' "$BUILD" |
  head -n 1 |
  sed -e 's/^function //' -e 's/($//')

GALLERY_STEP=$(grep -oE 'function (_M0[A-Za-z0-9_]*gallery__step[A-Za-z0-9_]*)\(' "$BUILD" |
  head -n 1 |
  sed -e 's/^function //' -e 's/($//')

if [ -z "$STEP" ]; then
  echo "error: could not locate the canvas.step entry point in the build output" >&2
  exit 1
fi

if [ -z "$GALLERY_STEP" ]; then
  echo "error: could not locate the canvas.gallery_step entry point in the build output" >&2
  exit 1
fi

STATUS=$(grep -oE 'function (_M0[A-Za-z0-9_]*get__gallery__status)\(' "$BUILD" |
  head -n 1 |
  sed -e 's/^function //' -e 's/($//' || true)

CURSOR=$(grep -oE 'function (_M0[A-Za-z0-9_]*get__gallery__cursor)\(' "$BUILD" |
  head -n 1 |
  sed -e 's/^function //' -e 's/($//' || true)

SET_VM=$(grep -oE 'function (_M0[A-Za-z0-9_]*set__gallery__view__mode)\(' "$BUILD" |
  head -n 1 |
  sed -e 's/^function //' -e 's/($//' || true)

GET_VM=$(grep -oE 'function (_M0[A-Za-z0-9_]*get__gallery__view__mode)\(' "$BUILD" |
  head -n 1 |
  sed -e 's/^function //' -e 's/($//' || true)

SET_THEME=$(grep -oE 'function (_M0[A-Za-z0-9_]*set__gallery__theme)\(' "$BUILD" |
  head -n 1 |
  sed -e 's/^function //' -e 's/($//' || true)

GET_THEME=$(grep -oE 'function (_M0[A-Za-z0-9_]*get__gallery__theme)\(' "$BUILD" |
  head -n 1 |
  sed -e 's/^function //' -e 's/($//' || true)

cp "$BUILD" "$OUT"
{
  echo
  echo "if (typeof window !== 'undefined') window.moon_step = $STEP;"
  echo "if (typeof globalThis !== 'undefined') globalThis.moon_step = $STEP;"
  echo "if (typeof window !== 'undefined') window.moon_gallery_step = $GALLERY_STEP;"
  echo "if (typeof globalThis !== 'undefined') globalThis.moon_gallery_step = $GALLERY_STEP;"
  if [ -n "$STATUS" ]; then
    echo "if (typeof window !== 'undefined') window.moon_gallery_status = $STATUS;"
    echo "if (typeof globalThis !== 'undefined') globalThis.moon_gallery_status = $STATUS;"
  fi
  if [ -n "$CURSOR" ]; then
    echo "if (typeof window !== 'undefined') window.moon_gallery_cursor = $CURSOR;"
    echo "if (typeof globalThis !== 'undefined') globalThis.moon_gallery_cursor = $CURSOR;"
  fi
  if [ -n "$SET_VM" ]; then
    echo "if (typeof window !== 'undefined') window.moon_set_gallery_view_mode = $SET_VM;"
    echo "if (typeof globalThis !== 'undefined') globalThis.moon_set_gallery_view_mode = $SET_VM;"
  fi
  if [ -n "$GET_VM" ]; then
    echo "if (typeof window !== 'undefined') window.moon_get_gallery_view_mode = $GET_VM;"
    echo "if (typeof globalThis !== 'undefined') globalThis.moon_get_gallery_view_mode = $GET_VM;"
  fi
  if [ -n "$SET_THEME" ]; then
    echo "if (typeof window !== 'undefined') window.moon_set_gallery_theme = $SET_THEME;"
    echo "if (typeof globalThis !== 'undefined') globalThis.moon_set_gallery_theme = $SET_THEME;"
  fi
  if [ -n "$GET_THEME" ]; then
    echo "if (typeof window !== 'undefined') window.moon_get_gallery_theme = $GET_THEME;"
    echo "if (typeof globalThis !== 'undefined') globalThis.moon_get_gallery_theme = $GET_THEME;"
  fi
} >> "$OUT"

echo "wrote $OUT (entry points: $STEP, $GALLERY_STEP, status, cursor, view_mode, theme)"
