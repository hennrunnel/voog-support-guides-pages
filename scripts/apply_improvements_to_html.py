#!/usr/bin/env python3

from __future__ import annotations

import argparse
from pathlib import Path
from typing import List, Tuple
import re
import sys

try:
    from bs4 import BeautifulSoup, Tag, NavigableString
except Exception:
    print("Missing dependency: beautifulsoup4. Install with: pip install beautifulsoup4 lxml markdown", file=sys.stderr)
    raise

try:
    import lxml  # noqa: F401
    DEFAULT_PARSER = "lxml"
except Exception:
    DEFAULT_PARSER = "html.parser"

try:
    import markdown  # type: ignore
except Exception:
    print("Missing dependency: markdown. Install with: pip install markdown", file=sys.stderr)
    raise


def parse_frontmatter(text: str) -> tuple[dict, str]:
    if not text.startswith('---'):
        return {}, text
    lines = text.split('\n')
    fm = {}
    end = None
    for i in range(1, len(lines)):
        if lines[i].strip() == '---':
            end = i
            break
        if ':' in lines[i]:
            k, _, v = lines[i].partition(':')
            fm[k.strip()] = v.strip()
    body = '\n'.join(lines[end + 1:] if end is not None else lines)
    return fm, body


def find_main_content(soup: BeautifulSoup) -> Tag:
    for sel in [
        ".ListingArticleContent",
        "article",
        "main",
        "div.content, div.entry, div.post",
        "body",
    ]:
        el = soup.select_one(sel)
        if el and len(el.get_text(" ", strip=True)) > 0:
            return el
    return soup.body or soup


def is_image_block(node: Tag) -> bool:
    if isinstance(node, NavigableString):
        return False
    if not isinstance(node, Tag):
        return False
    if node.name in ("img", "picture", "figure"):
        return True
    # Containers that contain images
    if node.find(["img", "picture", "figure"]):
        return True
    return False


def md_to_blocks(md_body: str) -> List[Tag]:
    html_str = markdown.markdown(md_body, extensions=['extra', 'sane_lists', 'smarty'])
    frag = BeautifulSoup(f"<div class='__md'>{html_str}</div>", DEFAULT_PARSER)
    blocks: List[Tag] = []
    for child in frag.select('div.__md')[0].children:
        if isinstance(child, NavigableString):
            if child.strip():
                p = frag.new_tag('p')
                p.string = child
                blocks.append(p)
            continue
        if isinstance(child, Tag):
            blocks.append(child)
    return blocks


def interleave_blocks(original_children: List[Tag], new_blocks: List[Tag], soup: BeautifulSoup) -> List[Tag]:
    out: List[Tag] = []
    nb_idx = 0
    for child in original_children:
        if isinstance(child, NavigableString):
            continue
        if is_image_block(child):
            out.append(child)
        else:
            if nb_idx < len(new_blocks):
                out.append(new_blocks[nb_idx])
                nb_idx += 1
    # Append remaining text blocks
    while nb_idx < len(new_blocks):
        out.append(new_blocks[nb_idx])
        nb_idx += 1
    return out


def rewrite_one(md_file: Path, html_root: Path, out_root: Path) -> Path | None:
    fm, body = parse_frontmatter(md_file.read_text(encoding='utf-8'))
    section = fm.get('section') or md_file.stem
    slug = fm.get('slug') or md_file.stem
    src_html = html_root / section / f"{slug}.html"
    if not src_html.exists():
        print(f"[WARN] Missing source HTML: {src_html}")
        return None
    html_text = src_html.read_text(encoding='utf-8', errors='ignore')
    soup = BeautifulSoup(html_text, DEFAULT_PARSER)
    main = find_main_content(soup)

    # Capture original children as list of Tags (skip whitespace strings)
    orig_children = [c for c in list(main.children) if isinstance(c, Tag) or (isinstance(c, NavigableString) and c.strip())]

    # Build new text blocks from MD body
    new_blocks = md_to_blocks(body)

    # Interleave images from original with new text blocks
    composed = interleave_blocks([c for c in orig_children if isinstance(c, Tag)], new_blocks, soup)

    # Replace main content
    main.clear()
    for b in composed:
        main.append(b)

    # Write to out_root, preserving section folder
    out_dir = out_root / section
    out_dir.mkdir(parents=True, exist_ok=True)
    out_file = out_dir / f"{slug}.html"
    out_file.write_text(str(soup), encoding='utf-8')
    return out_file


def main() -> None:
    ap = argparse.ArgumentParser(description='Apply improved MD text to existing HTML while preserving images and styles')
    ap.add_argument('--md-dir', required=True, help='Directory of improved .md files')
    ap.add_argument('--html-root', required=True, help='Root of existing HTML (e.g., en)')
    ap.add_argument('--out-root', required=True, help='Output root for rewritten HTML')
    args = ap.parse_args()

    md_dir = Path(args.md_dir)
    html_root = Path(args.html_root)
    out_root = Path(args.out_root)

    count = 0
    for md_file in sorted(md_dir.glob('*.md')):
        if md_file.name.lower() == 'overview.md':
            continue
        out = rewrite_one(md_file, html_root, out_root)
        if out:
            count += 1
            print(f"Rewrote: {out}")
    print(f"Done. {count} files written to {out_root}")


if __name__ == '__main__':
    main()

