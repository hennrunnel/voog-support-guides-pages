#!/usr/bin/env python3

"""
Rebuild Voog Support Guides markdown from HTML sources.

- Parses HTML in `Support Guides/en/` and `Support Guides/et/`
- Extracts main content reliably using BeautifulSoup
- Converts HTML to Markdown with preserved structure
- Writes to `Support Guides/markdown-content/{lang}/{section}/{slug}.md`
- Builds a flat JSON index at `Support Guides/json-content/index-flat.json`
"""

from __future__ import annotations

import argparse
import datetime as dt
import json
import os
import re
import shutil
import sys
from dataclasses import dataclass, asdict
from pathlib import Path
from typing import Optional, Tuple, List

try:
    from bs4 import BeautifulSoup, Tag
except Exception as exc:  # pragma: no cover
    print("Missing dependency: beautifulsoup4. Install with: pip install beautifulsoup4 lxml markdownify", file=sys.stderr)
    raise

try:
    # Prefer lxml parser for robustness
    DEFAULT_PARSER = "lxml"
    import lxml  # type: ignore  # noqa: F401
except Exception:
    DEFAULT_PARSER = "html.parser"

try:
    from markdownify import markdownify as md
except Exception as exc:  # pragma: no cover
    print("Missing dependency: markdownify. Install with: pip install markdownify", file=sys.stderr)
    raise


REPO_ROOT = Path(__file__).resolve().parents[1]
SRC_DIRS = [REPO_ROOT / "en", REPO_ROOT / "et"]
OUT_MD_DIR = REPO_ROOT / "markdown-content"
OUT_JSON_DIR = REPO_ROOT / "json-content"
BACKUPS_DIR = REPO_ROOT / f"markdown-backup-{dt.datetime.utcnow().strftime('%Y%m%d-%H%M%S')}"
SECTIONS_MAP_PATH = REPO_ROOT / "scripts" / "sections.json"


def load_sections_map() -> dict:
    if SECTIONS_MAP_PATH.exists():
        with open(SECTIONS_MAP_PATH, "r", encoding="utf-8") as f:
            return json.load(f)
    # Fallback minimal map
    return {
        "display": {
            "all-about-languages": "Languages",
            "content-areas": "Content Areas",
            "creating-and-managing-forms": "Forms",
            "managing-your-blog": "Blog",
            "managing-your-content": "Content",
            "managing-your-website-pages": "Pages",
            "online-store": "Online Store",
            "seo": "SEO",
            "setting-up-your-account": "Account",
            "stats-and-maintenance": "Stats & Maintenance",
            "video-tutorials": "Video Tutorials",
            "webinars": "Webinars",
            "your-pictures-and-files": "Pictures & Files",
            "your-subscriptions": "Subscriptions",
            "your-website-addresses": "Addresses",
            "your-websites-design": "Design",
            "contact": "Contact",
        },
        "et_from_en": {
            "managing-your-blog": "blogi",
            "your-website-addresses": "domeenid",
            "online-store": "e-pood",
            "all-about-languages": "keeled",
            "contact": "kontakt",
            "setting-up-your-account": "konto-loomine",
            "your-websites-design": "kujundus",
            "managing-your-website-pages": "lehed",
            "your-pictures-and-files": "pildid-ja-failid",
            "seo": "seo",
            "managing-your-content": "sisu-haldamine",
            "content-areas": "sisualad",
            "stats-and-maintenance": "statistika-ja-saidi-haldamine",
            "your-subscriptions": "tellimus",
            "webinars": "veebiseminar",
            "video-tutorials": "videojuhendid",
            "creating-and-managing-forms": "vormid",
        },
    }


def clean_text(text: str) -> str:
    # Normalize whitespace while preserving paragraph breaks later
    text = re.sub(r"\r\n?", "\n", text)
    text = re.sub(r"\u00A0", " ", text)  # nbsp
    return text.strip()


def strip_noise(node: Tag) -> None:
    # Remove scripts, styles, navs, headers, footers, share/related blocks
    for selector in [
        "script",
        "style",
        "nav",
        "header",
        "footer",
        "aside",
        "div.share",
        "div.related",
        "section.related",
        "div[data-testid='share']",
    ]:
        for el in node.select(selector):
            el.decompose()


def find_main_content(soup: BeautifulSoup) -> Tag | None:
    # Priority selectors observed in site
    candidates = []
    for sel in [
        ".ListingArticleContent",
        "article",
        "main",
        "div.content, div.entry, div.post",
    ]:
        found = soup.select_one(sel)
        if found:
            candidates.append(found)
    # Fallback: the largest text-containing div
    if not candidates:
        divs = soup.find_all("div")
        divs_sorted = sorted(divs, key=lambda d: len(d.get_text(" ", strip=True)), reverse=True)
        if divs_sorted:
            candidates.append(divs_sorted[0])
    for cand in candidates:
        text_len = len(cand.get_text(" ", strip=True))
        if text_len > 200:  # heuristic threshold
            return cand
    return candidates[0] if candidates else None


def extract_title(soup: BeautifulSoup, content_node: Optional[Tag]) -> str:
    if content_node:
        h1 = content_node.find(["h1", "h2"])  # sometimes H2 used
        if h1 and h1.get_text(strip=True):
            return h1.get_text(strip=True)
    title_tag = soup.find("title")
    if title_tag and title_tag.get_text(strip=True):
        title = title_tag.get_text(strip=True)
        # Remove site suffix after separator
        title = re.split(r"\s+\|\s+", title)[0]
        return title
    return "Untitled"


def html_to_markdown(html_fragment: str) -> str:
    # Configure markdownify for better structure
    md_text = md(
        html_fragment,
        heading_style="ATX",
        strip=['span'],
        bullets="-",
        escape_asterisks=False,
    )
    # Post-process: collapse excessive blank lines; ensure lists separated
    md_text = re.sub(r"\n{3,}", "\n\n", md_text)
    return clean_text(md_text)


def build_original_url(lang: str, section: str, slug: str) -> str:
    if lang == "en":
        return f"https://www.voog.com/support/{section}/{slug}"
    else:
        return f"https://www.voog.com/tugi/{section}/{slug}"


@dataclass
class IndexItem:
    id: str
    lang: str
    section: str
    slug: str
    title: str
    original_url: str
    html_path: str
    md_path: str
    word_count: int
    size_bytes: int
    updated_at: str
    excerpt: str


def ensure_dirs(path: Path) -> None:
    path.mkdir(parents=True, exist_ok=True)


def backup_existing_markdown() -> None:
    if OUT_MD_DIR.exists():
        shutil.copytree(OUT_MD_DIR, BACKUPS_DIR)


def extract_one(html_path: Path, lang: str) -> Tuple[str, str, str, str]:
    # Returns (title, markdown, section, slug)
    html = html_path.read_text(encoding="utf-8", errors="ignore")
    soup = BeautifulSoup(html, DEFAULT_PARSER)
    main = find_main_content(soup)
    if not main:
        # fall back to body
        main = soup.body or soup
    strip_noise(main)
    title = extract_title(soup, main)
    # Convert only main content to markdown
    markdown_body = html_to_markdown(str(main))
    # Section and slug from path
    section = html_path.parent.name
    slug = html_path.stem
    return title, markdown_body, section, slug


def make_frontmatter(title: str, lang: str, section: str, slug: str, original_url: str, updated_at: str, word_count: int) -> str:
    fm = [
        "---",
        f"title: {title}",
        f"lang: {lang}",
        f"section: {section}",
        f"slug: {slug}",
        f"original_url: {original_url}",
        f"updated_at: {updated_at}",
        f"word_count: {word_count}",
        "---",
        "",
    ]
    return "\n".join(fm)


def first_excerpt(text: str, max_chars: int = 500) -> str:
    snippet = text.strip().replace("\n", " ")
    snippet = re.sub(r"\s+", " ", snippet)
    return (snippet[: max_chars].rstrip() + ("…" if len(snippet) > max_chars else "")) if snippet else ""


def rebuild(lang_filters: Optional[List[str]] = None) -> None:
    sections_map = load_sections_map()

    # Prepare dirs
    ensure_dirs(OUT_MD_DIR)
    ensure_dirs(OUT_JSON_DIR)

    # Backup and clear markdown-content
    backup_existing_markdown()
    if OUT_MD_DIR.exists():
        shutil.rmtree(OUT_MD_DIR)
    ensure_dirs(OUT_MD_DIR)

    index_items: List[IndexItem] = []
    processed = 0
    errors = 0
    now_iso = dt.datetime.utcnow().strftime("%Y-%m-%dT%H:%M:%SZ")

    for src_dir in SRC_DIRS:
        lang = src_dir.name
        if lang_filters and lang not in lang_filters:
            continue
        for html_path in src_dir.rglob("*.html"):
            # Skip top-level index.html pages
            if html_path.name == "index.html":
                continue
            try:
                title, md_body, section, slug = extract_one(html_path, lang)
                words = len(re.findall(r"\b\w+\b", md_body))

                original_url = build_original_url(lang, section, slug)

                md_dir = OUT_MD_DIR / lang / section
                ensure_dirs(md_dir)
                md_file = md_dir / f"{slug}.md"

                fm = make_frontmatter(title, lang, section, slug, original_url, now_iso, words)
                content = f"{fm}{md_body}\n"
                md_file.write_text(content, encoding="utf-8")

                rel_html = str(html_path.relative_to(REPO_ROOT))
                rel_md = str(md_file.relative_to(REPO_ROOT))
                size_bytes = html_path.stat().st_size
                item = IndexItem(
                    id=f"{lang}:{section}:{slug}",
                    lang=lang,
                    section=section,
                    slug=slug,
                    title=title,
                    original_url=original_url,
                    html_path=rel_html,
                    md_path=rel_md,
                    word_count=words,
                    size_bytes=size_bytes,
                    updated_at=now_iso,
                    excerpt=first_excerpt(md_body),
                )
                index_items.append(item)
                processed += 1
                if processed % 50 == 0:
                    print(f"Processed {processed} files…")
            except Exception as e:
                errors += 1
                print(f"[ERROR] {html_path}: {e}", file=sys.stderr)

    # Write flat index
    flat = [asdict(i) for i in index_items]
    (OUT_JSON_DIR / "index-flat.json").write_text(
        json.dumps(flat, ensure_ascii=False, indent=2), encoding="utf-8"
    )

    # Simple nested index by lang -> section -> slug
    nested: dict = {"metadata": {
        "generated": now_iso,
        "total_articles": {
            "en": sum(1 for i in index_items if i.lang == "en"),
            "et": sum(1 for i in index_items if i.lang == "et"),
        },
        "sections": {
            "en": len({i.section for i in index_items if i.lang == "en"}),
            "et": len({i.section for i in index_items if i.lang == "et"}),
        }
    }, "articles": {"en": {}, "et": {}}}

    for item in index_items:
        articles = nested["articles"][item.lang]
        sec = articles.setdefault(item.section, {})
        sec[item.slug] = {
            "title": item.title,
            "content": item.excerpt,
            "file": item.md_path,
        }

    (OUT_JSON_DIR / "content-index.json").write_text(
        json.dumps(nested, ensure_ascii=False, indent=2), encoding="utf-8"
    )

    print(f"Done. Processed: {processed}, Errors: {errors}")
    if BACKUPS_DIR.exists():
        print(f"Backup saved at: {BACKUPS_DIR}")
    print(f"Markdown at: {OUT_MD_DIR}")
    print(f"Flat index: {OUT_JSON_DIR / 'index-flat.json'}")
    print(f"Nested index: {OUT_JSON_DIR / 'content-index.json'}")


def main() -> None:
    parser = argparse.ArgumentParser(description="Rebuild support guides markdown and indexes")
    parser.add_argument("--lang", choices=["en", "et"], nargs="*", help="Limit to language(s)")
    args = parser.parse_args()
    rebuild(args.lang)


if __name__ == "__main__":
    main()

