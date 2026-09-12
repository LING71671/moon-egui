# Rebuild the JavaScript bundle that the demo pages load.
param()

$ErrorActionPreference = "Stop"
$ROOT = Split-Path -Parent $PSScriptRoot
Set-Location $ROOT

Write-Host "Building MoonBit JS target..."
moon build --target js --release

$BUILD = Join-Path $ROOT "_build/js/release/build/examples/canvas/canvas.js"
$OUT = Join-Path $ROOT "examples/canvas/canvas.js"

if (-not (Test-Path $BUILD)) {
  Write-Error "Build output not found: $BUILD"
  exit 1
}

$content = Get-Content $BUILD -Raw
$step = [regex]::Match($content, 'function (_M0[A-Za-z0-9_]*4step)\(').Groups[1].Value
$gallery_step = [regex]::Match($content, 'function (_M0[A-Za-z0-9_]*gallery__step[A-Za-z0-9_]*)\(').Groups[1].Value
$status = [regex]::Match($content, 'function (_M0[A-Za-z0-9_]*get__gallery__status)\(').Groups[1].Value
$cursor = [regex]::Match($content, 'function (_M0[A-Za-z0-9_]*get__gallery__cursor)\(').Groups[1].Value
$set_vm = [regex]::Match($content, 'function (_M0[A-Za-z0-9_]*set__gallery__view__mode)\(').Groups[1].Value
$get_vm = [regex]::Match($content, 'function (_M0[A-Za-z0-9_]*get__gallery__view__mode)\(').Groups[1].Value
$set_theme = [regex]::Match($content, 'function (_M0[A-Za-z0-9_]*set__gallery__theme)\(').Groups[1].Value
$get_theme = [regex]::Match($content, 'function (_M0[A-Za-z0-9_]*get__gallery__theme)\(').Groups[1].Value

if (-not $step) {
  Write-Error "Could not locate step entry point"
  exit 1
}
if (-not $gallery_step) {
  Write-Error "Could not locate gallery_step entry point"
  exit 1
}

$exports = @"

if (typeof window !== 'undefined') window.moon_step = $step;
if (typeof globalThis !== 'undefined') globalThis.moon_step = $step;
if (typeof window !== 'undefined') window.moon_gallery_step = $gallery_step;
if (typeof globalThis !== 'undefined') globalThis.moon_gallery_step = $gallery_step;
"@

if ($status) {
  $exports += @"

if (typeof window !== 'undefined') window.moon_gallery_status = $status;
if (typeof globalThis !== 'undefined') globalThis.moon_gallery_status = $status;
"@
}

if ($cursor) {
  $exports += @"

if (typeof window !== 'undefined') window.moon_gallery_cursor = $cursor;
if (typeof globalThis !== 'undefined') globalThis.moon_gallery_cursor = $cursor;
"@
}

if ($set_vm) {
  $exports += @"

if (typeof window !== 'undefined') window.moon_set_gallery_view_mode = $set_vm;
if (typeof globalThis !== 'undefined') globalThis.moon_set_gallery_view_mode = $set_vm;
"@
}

if ($get_vm) {
  $exports += @"

if (typeof window !== 'undefined') window.moon_get_gallery_view_mode = $get_vm;
if (typeof globalThis !== 'undefined') globalThis.moon_get_gallery_view_mode = $get_vm;
"@
}

if ($set_theme) {
  $exports += @"

if (typeof window !== 'undefined') window.moon_set_gallery_theme = $set_theme;
if (typeof globalThis !== 'undefined') globalThis.moon_set_gallery_theme = $set_theme;
"@
}

if ($get_theme) {
  $exports += @"

if (typeof window !== 'undefined') window.moon_get_gallery_theme = $get_theme;
if (typeof globalThis !== 'undefined') globalThis.moon_get_gallery_theme = $get_theme;
"@
}

[System.IO.File]::WriteAllText($OUT, $content + "`n" + $exports, [System.Text.Encoding]::UTF8)
Write-Host "Successfully wrote $OUT"
