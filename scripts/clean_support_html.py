#!/usr/bin/env python3

"""
Clean fetched Voog Support HTML files by removing global navigation, footer,
scripts, styles, and other boilerplate while keeping the main article content.

- Scans language folders (default: en, et)
- For each *.html (excluding top-level index.html), it extracts the main content
  and rewrites the file as a minimal HTML document to reduce size/noise.
"""

from __future__ import annotations

import argparse
from pathlib import Path
import re
import sys
from typing import Optional

try:
    from bs4 import BeautifulSoup, Tag
except Exception:
    print("Missing dependency: beautifulsoup4. Install with: pip install beautifulsoup4 lxml", file=sys.stderr)
    raise

try:
    import lxml  # noqa: F401
    DEFAULT_PARSER = "lxml"
except Exception:
    DEFAULT_PARSER = "html.parser"


REPO_ROOT = Path(__file__).resolve().parents[1]


def strip_noise(node: Tag) -> None:
    # Remove noisy elements likely outside article content.
    for selector in [
        "script",
        "style",
        "nav",
        "header",
        "footer",
        "aside",
        "noscript",
        ".site-header",
        ".site-footer",
        ".ListingArticleMeta",
        ".ListingArticleSharing",
        ".share",
        ".related",
        "section.related",
    ]:
        for el in node.select(selector):
            el.decompose()


def find_main_content(soup: BeautifulSoup) -> Optional[Tag]:
    # Priority selectors known on Voog support
    for sel in [
        ".ListingArticleContent",
        "article",
        "main",
        "div.content, div.entry, div.post",
    ]:
        el = soup.select_one(sel)
        if el and len(el.get_text(" ", strip=True)) > 100:
            return el
    # Fallback: largest contentful div
    divs = soup.find_all("div")
    divs.sort(key=lambda d: len(d.get_text(" ", strip=True)), reverse=True)
    return divs[0] if divs else soup.body or soup


def extract_title(soup: BeautifulSoup, main: Optional[Tag]) -> str:
    if main:
        h = main.find(["h1", "h2"])  # some pages use h2
        if h and h.get_text(strip=True):
            return h.get_text(strip=True)
    t = soup.find("title")
    if t and t.get_text(strip=True):
        return re.split(r"\s+\|\s+", t.get_text(strip=True))[0]
    return "Voog Support Guide"


def build_minimal_html(title: str, inner_html: str) -> str:
    return f"""<!DOCTYPE html>
<html lang=\"en\">
<head>
  <meta charset=\"utf-8\"/>
  <meta name=\"viewport\" content=\"width=device-width, initial-scale=1\"/>
  <title>{title} | Voog Support</title>
</head>
<body>
{inner_html}
</body>
</html>
"""


def clean_file(html_path: Path) -> None:
    html = html_path.read_text(encoding="utf-8", errors="ignore")
    soup = BeautifulSoup(html, DEFAULT_PARSER)
    main = find_main_content(soup)
    if main is None:
        # Nothing sensible found; skip
        return
    strip_noise(main)
    # Preserve inner HTML of main content
    inner_html = main.decode()
    title = extract_title(soup, main)
    minimal = build_minimal_html(title, inner_html)
    html_path.write_text(minimal, encoding="utf-8")


def run(lang_dirs: list[str]) -> None:
    processed = 0
    for lang in lang_dirs:
        base = REPO_ROOT / lang
        if not base.exists():
            continue
        for f in base.rglob("*.html"):
            if f.name == "index.html":
                continue
            try:
                clean_file(f)
                processed += 1
            except Exception as e:
                print(f"[WARN] Failed to clean {f}: {e}", file=sys.stderr)
    print(f"Cleaned {processed} HTML files.")


def main() -> None:
    ap = argparse.ArgumentParser(description="Clean Voog support HTML files")
    ap.add_argument("--lang", nargs="*", choices=["en", "et"], help="Languages to clean")
    args = ap.parse_args()
    langs = args.lang or ["en", "et"]
    run(langs)


if __name__ == "__main__":
    main()

