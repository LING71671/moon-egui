import subprocess
import os
import re
import sys

def main():
    root = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
    build_file = os.path.join(root, "_build", "js", "release", "build", "examples", "canvas", "canvas.js")
    out_file = os.path.join(root, "examples", "canvas", "canvas.js")

    print(f"Building demo bundle in {root}...")
    res = subprocess.run(["moon", "build", "--target", "js", "--release"], cwd=root)
    if res.returncode != 0:
        print("Error: moon build failed", file=sys.stderr)
        sys.exit(res.returncode)

    if not os.path.isfile(build_file):
        print(f"Error: build output not found: {build_file}", file=sys.stderr)
        sys.exit(1)

    with open(build_file, "r", encoding="utf-8") as f:
        content = f.read()

    step_match = re.search(r'function (_M0[A-Za-z0-9_]*8examples6canvas4step)\(', content)
    gallery_step_match = re.search(r'function (_M0[A-Za-z0-9_]*gallery__step[A-Za-z0-9_]*\)\(', content)

    if not step_match:
        print("Error: could not locate canvas.step entry point", file=sys.stderr)
        sys.exit(1)
    if not gallery_step_match:
        print("Error: could not locate canvas.gallery_step entry point", file=sys.stderr)
        sys.exit(1)

    step_fn = step_match.group(1)
    gallery_step_fn = gallery_step_match.group(1)
    status_match = re.search(r'function (_M0[A-Za-z0-9_]*get__gallery__status)\(', content)
    status_fn = status_match.group(1) if status_match else "null"
    cursor_match = re.search(r'function (_M0[A-Za-z0-9_]*get__gallery__cursor)\(', content)
    cursor_fn = cursor_match.group(1) if cursor_match else "null"

    footer = f"""
if (typeof window !== 'undefined') window.moon_step = {step_fn};
if (typeof globalThis !== 'undefined') globalThis.moon_step = {step_fn};
if (typeof window !== 'undefined') window.moon_gallery_step = {gallery_step_fn};
if (typeof globalThis !== 'undefined') globalThis.moon_gallery_step = {gallery_step_fn};
if (typeof window !== 'undefined') window.moon_gallery_status = {status_fn};
if (typeof globalThis !== 'undefined') globalThis.moon_gallery_status = {status_fn};
if (typeof window !== 'undefined') window.moon_gallery_cursor = {cursor_fn};
if (typeof globalThis !== 'undefined') globalThis.moon_gallery_cursor = {cursor_fn};
"""

    with open(out_file, "w", encoding="utf-8") as f:
        f.write(content + footer)

    print(f"Wrote {out_file}")
    print(f"Entry points exported: step={step_fn}, gallery_step={gallery_step_fn}")

if __name__ == "__main__":
    main()
