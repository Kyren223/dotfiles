#!/usr/bin/env python3
import os
import sys
import shutil
import subprocess
import hashlib
import urllib.parse
from pathlib import Path

# ==============================================================================
# CONFIGURATION
# ==============================================================================
# Change this path to wherever you want your categorized archives to sit.
OUTPUT_DIR = Path("/home/kyren/Archive/html")
# ==============================================================================

def verify_dependencies():
    """Ensure monolith is available on the system."""
    if not shutil.which("monolith"):
        print("Error: 'monolith' CLI not found. Please ensure it is installed and in your PATH.", file=sys.stderr)
        sys.exit(1)

def clean_filename(title: str) -> str:
    """Sanitize the webpage title to be safe for filesystems."""
    forbidden = ["/", "\\", "<", ">", ":", '"', "|", "?", "*", "\x00"]
    for char in forbidden:
        title = title.replace(char, "_")
    return title.strip()

def get_fallback_filename(url: str) -> str:
    """Generates a clean fallback filename based on the URL structure."""
    parsed = urllib.parse.urlparse(url)
    clean_path = parsed.path.strip("/").replace("/", "_")
    name = f"{parsed.netloc}_{clean_path}" if clean_path else parsed.netloc
    return clean_filename(name)[:60]

def register_dolphin_thumbnail(html_path: Path):
    """Generates a screenshot and registers it inside the XDG Thumbnail Cache."""
    from playwright.sync_api import sync_playwright

    print(" Generating visual thumbnail for Dolphin...")
    
    # 1. Standard XDG paths for Large (256x256) thumbnails
    thumb_dir = Path(os.path.expanduser("~/.cache/thumbnails/large"))
    thumb_dir.mkdir(parents=True, exist_ok=True)

    # 2. Convert absolute file path to a deterministic File URI
    file_uri = html_path.resolve().as_uri()
    
    # 3. MD5 hash the exact URI (required by the Freedesktop Spec)
    md5_hash = hashlib.md5(file_uri.encode("utf-8")).hexdigest()
    target_thumb_path = thumb_dir / f"{md5_hash}.png"

    # 4. Spin up headless Chromium to capture a crisp view of the *local* file
    with sync_playwright() as p:
        browser = p.chromium.launch(headless=True)
        page = browser.new_page(viewport={"width": 1024, "height": 768})
        
        try:
            page.goto(file_uri, wait_until="networkidle")
            # Take the screenshot, automatically scaling/fitting into Dolphin's standard
            page.screenshot(path=str(target_thumb_path), type="png")
            print(f" Thumbnail registered successfully at: {target_thumb_path}")
        except Exception as e:
            print(f" Warning: Could not generate preview thumbnail: {e}", file=sys.stderr)
        finally:
            browser.close()

def main():
    if len(sys.argv) < 2:
        print(f"Usage: {sys.argv[0]} <URL>", file=sys.stderr)
        sys.exit(1)

    target_url = sys.argv[1]
    verify_dependencies()
    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)

    # Generate a reliable filename based on the target URL
    filename_base = get_fallback_filename(target_url)
    final_html_path = OUTPUT_DIR / f"{filename_base}.html"

    print(f" Archiving: {target_url}")
    print(f" Saving to: {final_html_path}")

    # Run Monolith to compile the remote web page down into a single local file
    try:
        # -o specifies the output file destination
        subprocess.run([
            "monolith",
            target_url,
            "-o", str(final_html_path)
        ], check=True)
    except subprocess.CalledProcessError as e:
        print(f"Error executing Monolith: {e}", file=sys.stderr)
        sys.exit(1)

    # Generate the thumbnail mapping from the locally saved file
    if final_html_path.exists():
        register_dolphin_thumbnail(final_html_path)
        print("\n Done! File is ready to browse natively in Dolphin.")
    else:
        print("Error: Target HTML file was not created successfully.", file=sys.stderr)

if __name__ == "__main__":
    main()
