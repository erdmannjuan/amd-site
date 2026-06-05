#!/usr/bin/env python3
"""
Validate a single application page after an agent has populated it.
Exit 0 = passes quality gate; non-zero = fails (with reasons printed).

Usage: python3 scripts/validate_application_page.py content/applications/<slug>.md
Thresholds can be overridden via env: MIN_WORDS, MIN_INTERNAL_LINKS, MIN_FAQ.
"""
import sys, os, re

try:
    import yaml
except ImportError:
    print("FAIL: pyyaml not installed")
    sys.exit(2)

MIN_WORDS = int(os.environ.get("MIN_WORDS", "800"))
MIN_INTERNAL_LINKS = int(os.environ.get("MIN_INTERNAL_LINKS", "5"))
MIN_FAQ = int(os.environ.get("MIN_FAQ", "3"))

# Pages that were intentionally removed — must never be linked
FORBIDDEN_LINKS = [
    "/industries/medical/",
    "/industries/pharmaceutical/",
    "/case-studies/medical-device-assembly/",
    "/case-studies/pharmaceutical-packaging/",
]

def fail(msgs):
    print("VALIDATION: FAIL")
    for m in msgs:
        print("  - " + m)
    sys.exit(1)

def main():
    if len(sys.argv) < 2:
        print("FAIL: no file given"); sys.exit(2)
    path = sys.argv[1]
    if not os.path.exists(path):
        print(f"FAIL: {path} not found"); sys.exit(2)

    raw = open(path, encoding="utf-8").read()
    if not raw.startswith("---"):
        fail(["no YAML frontmatter"])
    parts = raw.split("---", 2)
    if len(parts) < 3:
        fail(["malformed frontmatter (need opening and closing ---)"])
    try:
        fm = yaml.safe_load(parts[1]) or {}
    except yaml.YAMLError as e:
        fail([f"frontmatter is not valid YAML: {e}"])
    body = parts[2]

    errs = []

    # Completion flags
    if str(fm.get("status", "")).lower() != "complete":
        errs.append(f"frontmatter status is '{fm.get('status')}', expected 'complete'")
    if fm.get("noindex") not in (False, None, "false", "False"):
        errs.append(f"noindex is '{fm.get('noindex')}', expected false (page must be indexable when complete)")

    # Title / meta lengths
    title = (fm.get("title") or "").strip()
    desc = (fm.get("description") or "").strip()
    if not title:
        errs.append("title is empty")
    elif len(title) > 60:
        errs.append(f"title is {len(title)} chars (>60)")
    if not desc:
        errs.append("description is empty")
    elif len(desc) > 155:
        errs.append(f"description is {len(desc)} chars (>155)")

    # Primary keyword retained
    if not (fm.get("primary_keyword") or "").strip():
        errs.append("primary_keyword missing from frontmatter")

    # Body word count
    words = len(re.findall(r"\b\w+\b", body))
    if words < MIN_WORDS:
        errs.append(f"body has ~{words} words (< {MIN_WORDS})")

    # Single H1 rule: template renders the H1, body must not contain a markdown H1
    if re.search(r"(?m)^\s*#\s+\S", body):
        errs.append("body contains a markdown H1 ('# ...') — use ## / ### only (template renders the H1)")

    # Internal links
    internal = re.findall(r"\]\((/[^)]+)\)", body)  # markdown links to root-relative paths
    internal += re.findall(r'href="(/[^"]+)"', body)  # any inline html links
    internal = [l for l in internal if not l.startswith("/static/")]
    if len(internal) < MIN_INTERNAL_LINKS:
        errs.append(f"only {len(internal)} internal links (< {MIN_INTERNAL_LINKS})")

    # Forbidden links
    for f in FORBIDDEN_LINKS:
        if f in body:
            errs.append(f"links to removed page {f}")

    # www links forbidden
    if re.search(r"https?://www\.amdmachines\.com", body):
        errs.append("links to www.amdmachines.com (use relative / non-www)")

    # FAQ schema source
    faq = fm.get("faq") or []
    if not isinstance(faq, list) or len(faq) < MIN_FAQ:
        errs.append(f"faq frontmatter has {len(faq) if isinstance(faq, list) else 0} items (< {MIN_FAQ})")

    if errs:
        fail(errs)

    print(f"VALIDATION: PASS ({words} words, {len(internal)} internal links, {len(faq)} faq items, title {len(title)}c, meta {len(desc)}c)")
    sys.exit(0)

if __name__ == "__main__":
    main()
