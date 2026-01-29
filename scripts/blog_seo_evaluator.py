#!/usr/bin/env python3
"""
Blog SEO Evaluator - Comprehensive SEO scoring for blog URLs

Fetches each blog URL live, evaluates on-page, content quality,
and technical SEO factors, then writes a composite score (0-100)
back to the CSV.

Required: pip install requests beautifulsoup4
"""

import csv
import re
import sys
import json
import time
from pathlib import Path
from urllib.parse import urlparse
from concurrent.futures import ThreadPoolExecutor, as_completed

import requests
from bs4 import BeautifulSoup

# ─── Configuration ───────────────────────────────────────────────────────────

CSV_PATH = Path(__file__).parent.parent / "Instructions" / "blog_content_SEO.csv"
SITE_DOMAIN = "amdmachines.com"
CONCURRENCY = 5
REQUEST_TIMEOUT = 15
RETRY_COUNT = 2
RETRY_DELAY = 2
USER_AGENT = "AMDMachines-SEO-Evaluator/1.0"

STOP_WORDS = {
    "a", "an", "the", "and", "or", "but", "in", "on", "at", "to", "for",
    "of", "with", "by", "from", "is", "are", "was", "were", "be", "been",
    "being", "have", "has", "had", "do", "does", "did", "will", "would",
    "could", "should", "may", "might", "shall", "can", "this", "that",
    "these", "those", "it", "its", "not", "no", "nor", "so", "if", "then",
    "than", "too", "very", "just", "about", "above", "after", "again",
    "all", "also", "am", "as", "because", "before", "between", "both",
    "each", "few", "how", "into", "more", "most", "other", "our", "out",
    "over", "own", "same", "some", "such", "up", "what", "when", "where",
    "which", "while", "who", "whom", "why", "you", "your",
}


# ─── CSV I/O ─────────────────────────────────────────────────────────────────

def load_csv():
    rows = []
    with open(CSV_PATH, "r", newline="", encoding="utf-8") as f:
        reader = csv.DictReader(f)
        fieldnames = reader.fieldnames
        for row in reader:
            rows.append(row)
    return rows, fieldnames


def save_csv(rows, fieldnames):
    with open(CSV_PATH, "w", newline="", encoding="utf-8") as f:
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        writer.writeheader()
        for row in rows:
            writer.writerow(row)


# ─── HTTP Fetching ───────────────────────────────────────────────────────────

def fetch_url(url):
    headers = {"User-Agent": USER_AGENT}
    for attempt in range(RETRY_COUNT + 1):
        try:
            resp = requests.get(url, headers=headers, timeout=REQUEST_TIMEOUT)
            return {
                "url": url,
                "status_code": resp.status_code,
                "html": resp.text,
                "content_length": len(resp.content),
                "error": None,
            }
        except requests.exceptions.RequestException as e:
            if attempt < RETRY_COUNT:
                time.sleep(RETRY_DELAY)
                continue
            return {
                "url": url,
                "status_code": None,
                "html": None,
                "content_length": 0,
                "error": str(e),
            }


def fetch_all_urls(urls):
    results = {}
    total = len(urls)
    done = 0

    with ThreadPoolExecutor(max_workers=CONCURRENCY) as executor:
        futures = {executor.submit(fetch_url, url): url for url in urls}
        for future in as_completed(futures):
            result = future.result()
            results[result["url"]] = result
            done += 1
            if done % 50 == 0 or done == total:
                print(f"  Fetched {done}/{total}...")

    return results


# ─── Text Utilities ──────────────────────────────────────────────────────────

def get_body_text(soup):
    """Extract visible text from the article body only."""
    article = soup.find("div", id="article-body")
    if not article:
        article = soup.find("div", class_="article-body")
    if not article:
        article = soup.find("article")
    if not article:
        body = soup.find("body")
        if body:
            return body.get_text(separator=" ", strip=True)
        return ""
    return article.get_text(separator=" ", strip=True)


def get_article_element(soup):
    """Return the article content element for link/heading analysis."""
    el = soup.find("div", id="article-body")
    if not el:
        el = soup.find("div", class_="article-body")
    if not el:
        el = soup.find("article")
    if not el:
        el = soup.find("body")
    return el


def count_syllables(word):
    word = word.lower().strip(".,!?;:'\"()-")
    if len(word) <= 3:
        return 1
    vowels = "aeiouy"
    count = 0
    prev_vowel = False
    for char in word:
        is_vowel = char in vowels
        if is_vowel and not prev_vowel:
            count += 1
        prev_vowel = is_vowel
    if word.endswith("e"):
        count -= 1
    return max(1, count)


def flesch_kincaid_grade(text):
    sentences = re.split(r"[.!?]+", text)
    sentences = [s.strip() for s in sentences if len(s.strip()) > 5]
    words = [w for w in text.split() if len(w) > 0]
    if len(sentences) < 2 or len(words) < 50:
        return 0

    syllable_total = sum(count_syllables(w) for w in words)
    asl = len(words) / len(sentences)
    asw = syllable_total / len(words)
    grade = 0.39 * asl + 11.8 * asw - 15.59
    return max(0, grade)


def extract_keywords(text):
    """Extract meaningful words (non-stop-words) from text."""
    words = re.findall(r"[a-z0-9]+", text.lower())
    return {w for w in words if w not in STOP_WORDS and len(w) > 2}


# ─── SEO Checks ─────────────────────────────────────────────────────────────

def check_title(soup, url):
    tag = soup.find("title")
    title_text = tag.get_text(strip=True) if tag else ""
    points = 0
    notes = []

    if not title_text:
        notes.append("Missing title tag")
        return {"points": 0, "max": 8, "notes": notes}

    points += 4
    length = len(title_text)

    if 50 <= length <= 60:
        points += 4
    elif 30 <= length <= 70:
        points += 2
        notes.append(f"Title length {length} (ideal 50-60)")
    else:
        notes.append(f"Title length {length} (ideal 50-60)")

    return {"points": points, "max": 8, "notes": notes}


def check_meta_description(soup):
    tag = soup.find("meta", attrs={"name": "description"})
    desc = tag.get("content", "").strip() if tag else ""
    points = 0
    notes = []

    if not desc:
        notes.append("Missing meta description")
        return {"points": 0, "max": 7, "notes": notes}

    points += 3
    length = len(desc)

    if 120 <= length <= 155:
        points += 4
    elif 70 <= length <= 160:
        points += 2
        notes.append(f"Meta desc length {length} (ideal 120-155)")
    else:
        notes.append(f"Meta desc length {length} (ideal 120-155)")

    return {"points": points, "max": 7, "notes": notes}


def check_h1(soup):
    h1_tags = soup.find_all("h1")
    title_tag = soup.find("title")
    title_text = title_tag.get_text(strip=True) if title_tag else ""
    points = 0
    notes = []

    if len(h1_tags) == 0:
        notes.append("Missing H1 tag")
        return {"points": 0, "max": 7, "notes": notes}

    if len(h1_tags) == 1:
        points += 5
    else:
        points += 2
        notes.append(f"{len(h1_tags)} H1 tags (should be 1)")

    h1_text = h1_tags[0].get_text(strip=True)
    if title_text and h1_text:
        title_kw = extract_keywords(title_text)
        h1_kw = extract_keywords(h1_text)
        if title_kw and h1_kw:
            overlap = len(title_kw & h1_kw) / max(len(title_kw), 1)
            if overlap >= 0.5:
                points += 2
            else:
                notes.append("H1 doesn't match title keywords well")

    return {"points": points, "max": 7, "notes": notes}


def check_heading_hierarchy(soup):
    article = get_article_element(soup)
    if not article:
        return {"points": 0, "max": 6, "notes": ["No article content found"]}

    headings = article.find_all(re.compile(r"^h[2-6]$"))
    points = 0
    notes = []

    h2s = [h for h in headings if h.name == "h2"]
    if h2s:
        points += 3
        if len(h2s) >= 3:
            points += 1
    else:
        notes.append("No H2 headings in content")

    # Check for level skips
    levels = [int(h.name[1]) for h in headings]
    has_skip = False
    for i in range(1, len(levels)):
        if levels[i] > levels[i - 1] + 1:
            has_skip = True
            break
    if not has_skip and headings:
        points += 2
    elif has_skip:
        notes.append("Heading level skip detected")

    return {"points": points, "max": 6, "notes": notes}


def check_url_structure(url):
    parsed = urlparse(url)
    path = parsed.path.strip("/")
    slug = path.split("/")[-1] if "/" in path else path
    points = 0
    notes = []

    if len(slug) <= 75:
        points += 3
    else:
        notes.append(f"Slug too long ({len(slug)} chars)")

    if re.match(r"^[a-z0-9-]+$", slug):
        points += 2
    else:
        notes.append("Slug has non-ideal characters")

    slug_words = set(slug.split("-"))
    slug_stop = slug_words & STOP_WORDS
    if len(slug_stop) <= 1:
        points += 2
    else:
        notes.append(f"Slug has stop words: {slug_stop}")

    return {"points": points, "max": 7, "notes": notes}


def check_word_count(body_text):
    words = body_text.split()
    count = len(words)
    notes = [f"Word count: {count}"]

    if count >= 1500:
        points = 10
    elif count >= 1000:
        points = 8
    elif count >= 750:
        points = 5
    elif count >= 500:
        points = 3
    else:
        points = 1

    return {"points": points, "max": 10, "notes": notes}


def check_readability(body_text):
    grade = flesch_kincaid_grade(body_text)
    notes = [f"FK grade: {grade:.1f}"]

    if grade == 0:
        return {"points": 1, "max": 5, "notes": ["Insufficient text for readability"]}

    if 7 <= grade <= 12:
        points = 5
    elif 5 <= grade <= 14:
        points = 3
    else:
        points = 1

    return {"points": points, "max": 5, "notes": notes}


def check_keyword_in_headings(soup, title_text):
    article = get_article_element(soup)
    if not article or not title_text:
        return {"points": 0, "max": 5, "notes": ["No content or title"]}

    title_kw = extract_keywords(title_text)
    if not title_kw:
        return {"points": 3, "max": 5, "notes": ["No extractable keywords"]}

    h2s = article.find_all("h2")
    h2_texts = [h.get_text(strip=True) for h in h2s]
    matches = 0
    for h2_text in h2_texts:
        h2_words = extract_keywords(h2_text)
        if title_kw & h2_words:
            matches += 1

    notes = [f"{matches}/{len(h2s)} H2s contain title keywords"]

    if matches >= 2:
        points = 5
    elif matches >= 1:
        points = 3
    else:
        points = 0

    return {"points": points, "max": 5, "notes": notes}


def check_internal_links(soup, url):
    article = get_article_element(soup)
    if not article:
        return {"points": 0, "max": 10, "notes": ["No article content found"]}

    count = 0
    for a in article.find_all("a", href=True):
        href = a["href"]
        if href.startswith(("#", "mailto:", "tel:", "javascript:")):
            continue
        parsed = urlparse(href)
        if not parsed.netloc or SITE_DOMAIN in parsed.netloc:
            count += 1

    notes = [f"{count} internal links in article"]

    if count >= 5:
        points = 10
    elif count >= 3:
        points = 7
    elif count >= 1:
        points = 4
    else:
        points = 0

    return {"points": points, "max": 10, "notes": notes}


def check_external_links(soup):
    article = get_article_element(soup)
    if not article:
        return {"points": 1, "max": 5, "notes": ["No article content found"]}

    count = 0
    for a in article.find_all("a", href=True):
        href = a["href"]
        if href.startswith(("#", "mailto:", "tel:", "javascript:")):
            continue
        parsed = urlparse(href)
        if parsed.netloc and SITE_DOMAIN not in parsed.netloc:
            count += 1

    notes = [f"{count} external links in article"]

    if count >= 2:
        points = 5
    elif count >= 1:
        points = 3
    else:
        points = 1

    return {"points": points, "max": 5, "notes": notes}


def check_schema_markup(soup):
    points = 0
    notes = []
    has_article = False
    has_breadcrumb = False

    for script in soup.find_all("script", type="application/ld+json"):
        try:
            data = json.loads(script.string or "")
        except (json.JSONDecodeError, TypeError):
            continue

        items = data if isinstance(data, list) else [data]
        for item in items:
            item_type = item.get("@type", "")
            if isinstance(item_type, list):
                item_type = " ".join(item_type)
            if "Article" in item_type or "BlogPosting" in item_type:
                has_article = True
            if "BreadcrumbList" in item_type:
                has_breadcrumb = True

    if has_article:
        points += 5
    else:
        notes.append("Missing Article schema")
    if has_breadcrumb:
        points += 3
    else:
        notes.append("Missing BreadcrumbList schema")

    return {"points": points, "max": 8, "notes": notes}


def check_canonical(soup, url):
    link = soup.find("link", rel="canonical")
    points = 0
    notes = []

    if not link:
        notes.append("Missing canonical tag")
        return {"points": 0, "max": 5, "notes": notes}

    href = link.get("href", "").rstrip("/")
    current = url.rstrip("/")

    if href == current:
        points = 5
    else:
        points = 2
        notes.append(f"Canonical mismatch: {href}")

    return {"points": points, "max": 5, "notes": notes}


def check_open_graph(soup):
    points = 0
    notes = []

    og_title = soup.find("meta", property="og:title")
    og_desc = soup.find("meta", property="og:description")
    og_image = soup.find("meta", property="og:image")
    og_type = soup.find("meta", property="og:type")

    if og_title:
        points += 2
    else:
        notes.append("Missing og:title")

    if og_desc:
        points += 2
    else:
        notes.append("Missing og:description")

    if og_image:
        image_url = og_image.get("content", "")
        if image_url and "default" not in image_url.lower():
            points += 2
        else:
            points += 1
            notes.append("og:image may be default")
    else:
        notes.append("Missing og:image")

    if og_type and og_type.get("content", "") == "article":
        points += 1
    else:
        notes.append("Missing og:type=article")

    return {"points": points, "max": 7, "notes": notes}


def check_page_size(content_length):
    size_kb = content_length / 1024
    notes = [f"Page size: {size_kb:.0f} KB"]

    if size_kb < 200:
        points = 5
    elif size_kb < 500:
        points = 3
    else:
        points = 1

    return {"points": points, "max": 5, "notes": notes}


def check_viewport(soup):
    tag = soup.find("meta", attrs={"name": "viewport"})
    if not tag:
        return {"points": 0, "max": 5, "notes": ["Missing viewport meta"]}

    content = tag.get("content", "")
    if "width=device-width" in content:
        return {"points": 5, "max": 5, "notes": []}
    return {"points": 2, "max": 5, "notes": ["Viewport missing width=device-width"]}


# ─── Master Evaluation ──────────────────────────────────────────────────────

def evaluate_page(url, fetch_result):
    if fetch_result["error"] or (fetch_result["status_code"] and fetch_result["status_code"] != 200):
        error = fetch_result.get("error") or f"HTTP {fetch_result['status_code']}"
        return {"url": url, "score": 0, "error": error}

    soup = BeautifulSoup(fetch_result["html"], "html.parser")
    body_text = get_body_text(soup)

    title_tag = soup.find("title")
    title_text = title_tag.get_text(strip=True) if title_tag else ""

    scores = {
        "title": check_title(soup, url),
        "meta_description": check_meta_description(soup),
        "h1": check_h1(soup),
        "heading_hierarchy": check_heading_hierarchy(soup),
        "url_structure": check_url_structure(url),
        "word_count": check_word_count(body_text),
        "readability": check_readability(body_text),
        "keyword_in_headings": check_keyword_in_headings(soup, title_text),
        "internal_links": check_internal_links(soup, url),
        "external_links": check_external_links(soup),
        "schema": check_schema_markup(soup),
        "canonical": check_canonical(soup, url),
        "open_graph": check_open_graph(soup),
        "page_size": check_page_size(fetch_result["content_length"]),
        "viewport": check_viewport(soup),
    }

    total = sum(s["points"] for s in scores.values())
    return {"url": url, "score": min(100, round(total)), "details": scores, "error": None}


# ─── Main ────────────────────────────────────────────────────────────────────

def main():
    print(f"Loading URLs from {CSV_PATH}")
    rows, fieldnames = load_csv()
    urls = [row["url"] for row in rows]
    total = len(urls)

    print(f"SEO Blog Evaluator - {total} URLs to process")
    print(f"Concurrency: {CONCURRENCY} threads")
    print("-" * 60)

    # Phase 1: Fetch
    print("\n[Phase 1/2] Fetching pages...")
    fetch_results = fetch_all_urls(urls)

    success = sum(1 for r in fetch_results.values() if r["status_code"] == 200)
    failed = total - success
    print(f"  Fetched: {success} OK, {failed} failed")

    # Phase 2: Evaluate
    print("\n[Phase 2/2] Evaluating SEO factors...")
    results = {}
    for i, url in enumerate(urls, 1):
        result = evaluate_page(url, fetch_results[url])
        results[url] = result
        if result["error"]:
            print(f"  ERROR {url}: {result['error']}")
        if i % 50 == 0 or i == total:
            print(f"  Evaluated {i}/{total}")

    # Update CSV
    for row in rows:
        url = row["url"]
        row["Quality Score (0-100)"] = results[url]["score"]

    save_csv(rows, fieldnames)
    print(f"\nResults saved to {CSV_PATH}")

    # Summary stats
    scores = [results[url]["score"] for url in urls]
    sorted_scores = sorted(scores)
    print(f"\nScore Distribution:")
    print(f"  Average: {sum(scores) / len(scores):.1f}")
    print(f"  Median:  {sorted_scores[len(sorted_scores) // 2]}")
    print(f"  Min:     {min(scores)}")
    print(f"  Max:     {max(scores)}")

    brackets = {"0-20": 0, "21-40": 0, "41-60": 0, "61-80": 0, "81-100": 0}
    for s in scores:
        if s <= 20:
            brackets["0-20"] += 1
        elif s <= 40:
            brackets["21-40"] += 1
        elif s <= 60:
            brackets["41-60"] += 1
        elif s <= 80:
            brackets["61-80"] += 1
        else:
            brackets["81-100"] += 1

    print("\n  Bracket breakdown:")
    for bracket, count in brackets.items():
        bar = "#" * (count // 3)
        print(f"    {bracket:>6}: {count:>3} {bar}")

    # Show bottom 10
    print("\n  Bottom 10 URLs:")
    url_scores = sorted(results.items(), key=lambda x: x[1]["score"])
    for url, data in url_scores[:10]:
        slug = url.rstrip("/").split("/")[-1]
        print(f"    {data['score']:>3} - .../{slug}/")

    # Show top 10
    print("\n  Top 10 URLs:")
    for url, data in url_scores[-10:]:
        slug = url.rstrip("/").split("/")[-1]
        print(f"    {data['score']:>3} - .../{slug}/")


if __name__ == "__main__":
    main()
