# AMD Machines Website - Codex Operating Instructions

Last Codex handoff pass: 2026-05-06

This repository powers the live AMD Machines website at `https://amdmachines.com`.
Treat every edit as production SEO work. The site is not a toy branch or a local
prototype.

This file is the Codex entry point. In a future Codex session, point the agent at
`/Users/juan_erdmann/my-site-generator` and have it read `AGENTS.md` before
changing files. `CLAUDE.md` is retained for historical Claude workflows, but
`AGENTS.md` is the current safe operating guide for Codex.

## Site Facts

| Item | Value |
| --- | --- |
| Company | AMD Machines, Advanced Manufacturing Development LLC |
| Canonical domain | `https://amdmachines.com` |
| Hosting | Cloudflare Pages, `amd-site.pages.dev` |
| Repo | `github.com/erdmannjuan/amd-site` |
| Local path | `/Users/juan_erdmann/my-site-generator` |
| Stack | Python static site generator, Markdown, YAML frontmatter, Jinja2, plain CSS |
| Core commercial emphasis | Assembly systems, custom automation, robotic cells, welding automation |
| Deploy branch | `main` |

## Non-Negotiable SEO Rules

1. Use only the non-www domain in canonicals, sitemap entries, structured data,
   and absolute internal URLs: `https://amdmachines.com`.
2. Solution pages live under `/solutions/*`. Do not create new
   `/automated-solutions/*` pages.
3. Never rename an existing URL slug without adding a 301 redirect in
   `_redirects`.
4. Never create duplicate topic pages. Expand the canonical page instead.
5. Do not change existing title tags, meta descriptions, H1s, or URL fields
   casually. Those are ranking-sensitive.
6. Every page must have exactly one H1.
7. New pages need internal links from at least 3 existing pages and should link
   out to at least 2 existing pages.
8. Every image must have useful alt text plus explicit width and height when it
   is rendered with `<img>`.
9. Blog posts support solution pages. They should target educational intent and
   link to the relevant commercial solution page.
10. Build and audit before calling work complete.

## Canonical Keyword Map

Do not create competing pages for these terms.

| Primary keyword cluster | Canonical page |
| --- | --- |
| robotic cell, robot cell, robotic cells | `/solutions/robotic-cells/` |
| welding automation, automated welding | `/solutions/welding/` |
| automated assembly, assembly automation, assembly line | `/solutions/assembly/` |
| leak detection, test systems, leak testing | `/solutions/test-systems/` |
| machine tending, CNC tending | `/solutions/machine-tending/` |
| custom automation, automated equipment | `/solutions/custom-automation/` |
| marking, traceability | `/solutions/marking-traceability/` |
| industrial automation equipment | `/industries/` |
| automated assembly machines guide content | `/blog/automated-assembly-machines/` |

Note: the legacy guide slug
`/blog/automated-assembly-machines-a-selection-guide/` redirects to
`/blog/automated-assembly-machines/`.

## Current Repository Shape

- `build.py` deletes and regenerates `output/`, copies static assets, copies
  `_headers` and `_redirects`, builds pages, paginates blog/category indexes,
  builds case-study industry pages, generates `sitemap.xml`, and writes the blog
  search index.
- `config.yaml` owns the main navigation, solution lists, industry lists,
  service lists, social/contact data, and site URL.
- `templates/base.html` owns metadata, canonical tags, shared Organization and
  Breadcrumb schemas, header, footer, analytics, and the shared footer form.
- `templates/homepage.html` is the main visual/style reference.
- `templates/solution.html` adds Service JSON-LD and renders most solution pages.
- `templates/blog-post.html` adds BlogPosting JSON-LD and related internal links.
- `static/css/style.css` contains the global design system.
- `static/js/main.js` handles mobile nav, dropdowns, header scroll behavior,
  HubSpot form submission, smooth scroll, and related-content testing.
- `output/` is generated deployment output and is tracked. Running the build can
  refresh `output/sitemap.xml` lastmod dates.
- `.github/workflows/deploy.yml` deploys to GitHub Pages on `main` pushes. The
  live Cloudflare Pages host also updates from GitHub, but it can lag the push by
  a few minutes. Verify both `amdmachines.com` and `amd-site.pages.dev`.

Content inventory from the onboarding pass:

- 421 markdown files under `content/`
- 358 blog posts
- 20 solution markdown files, including the solutions index
- 13 industry markdown files, including the industries index
- 11 case-study markdown files, including the index
- 9 service markdown files, including the services index

## Known Audit Findings To Keep In Mind

The 2026-05-06 Codex onboarding pass found:

1. `python3 build.py` succeeds.
2. `csscompressor` is not installed, so CSS minification is skipped. This is
   optional, not a build blocker.
3. `python3 scripts/seo-crawler.py` reports 149 broken internal links, but all
   149 are covered by static `_redirects` rules whose targets exist.
4. Two generated pages conflict with 301 redirect rules:
   - `/solutions/deburring/` redirects to `/solutions/`
   - `/blog/calculating-roi-for-industrial-automation-projects/` redirects to
     `/blog/roi-of-robotic-automation/`
5. The deburring conflict is the sharper SEO issue because the page is generated,
   linked from navigation/content, and listed in the sitemap, but production
   redirects it away.
6. The generated and live sitemaps use `https://amdmachines.com` and do not list
   `www.amdmachines.com`.
7. The SEO crawler reports 270 meta descriptions longer than 160 characters and
   one duplicate title pair:
   - `/industries/heavy-equipment/`
   - `/blog/heavy-equipment-manufacturing-automation/`
8. `/about/` has one missing image alt warning for
   `/static/images/facility-hero.jpg`.

Before major SEO/content work, decide whether to fix the redirect conflicts
first. Do not add more deburring links until the live `/solutions/deburring/`
behavior is intentional.

## Standard Local Workflow

Start every change with:

```bash
git status --short
python3 build.py
python3 scripts/seo-crawler.py
```

For local preview:

```bash
python3 -m http.server 8000 --directory output
```

Then check representative pages:

```bash
curl -I http://localhost:8000/
curl -I http://localhost:8000/solutions/welding/
curl -I http://localhost:8000/sitemap.xml
```

For live deployment verification:

```bash
curl -I -L https://www.amdmachines.com/
curl -I -L https://amdmachines.com/sitemap.xml
curl -I -L https://amdmachines.com/automated-solutions/welding/
curl -I -L https://amdmachines.com/solutions/deburring/
```

For content verification after a push, fetch the page body, not only headers:

```bash
curl -L -H "Cache-Control: no-cache" "https://amdmachines.com/?v=verify" -o /tmp/amd-homepage.html
rg -n "expected text" /tmp/amd-homepage.html
curl -L -H "Cache-Control: no-cache" "https://amd-site.pages.dev/?v=verify" -o /tmp/amd-pages-homepage.html
rg -n "expected text" /tmp/amd-pages-homepage.html
```

Expected healthy signals:

- `www` redirects to `https://amdmachines.com/`.
- Legacy `/automated-solutions/*` paths 301 to `/solutions/*`.
- Sitemap returns 200 and only includes non-www URLs.
- Canonical pages return 200 unless there is an intentional 301.

## Change Discipline

- Prefer editing source files in `content/`, `templates/`, `static/`, and
  `config.yaml`; rebuild after source edits.
- Do not hand-edit generated `output/` except for emergency inspection or a
  clearly intentional generated-output adjustment.
- If a change affects URLs, navigation, titles, H1s, schema, or internal links,
  run the crawler and inspect `_redirects`.
- For new solution pages, first search existing content for the target keyword:

```bash
rg -n "target keyword|close variant" content config.yaml templates
```

- For blog improvements, keep the existing `url:`, `title:`, `date:`,
  `category:`, and `template:` unless the user explicitly asks for a larger SEO
  migration.
- Deployment is GitHub to Cloudflare Pages. Do not commit, push, or deploy unless
  the user asks for that step.

## Writing And Design Voice

- Write like a senior automation engineer: practical, direct, specific.
- Use real manufacturing vocabulary: cycle time, OEE, takt time, PLC, HMI,
  end effector, fixture, throughput, traceability, commissioning.
- Avoid generic AI boilerplate such as vague "key benefits" sections.
- Keep homepage style as the visual reference: restrained industrial design,
  clear CTAs, strong internal links, and no ornamental redesigns without cause.

## Deployment Checklist

Use this only when the user explicitly wants production updated.

1. Confirm `git status --short` and identify unrelated user changes.
2. Build with `python3 build.py`.
3. Run `python3 scripts/seo-crawler.py`.
4. Review sitemap for canonical domain:

```bash
rg -n "www\\.amdmachines\\.com|https://amdmachines.com" output/sitemap.xml
```

5. Commit source and generated output intentionally.
6. Push to the deployment branch requested by the user, normally `main`.
7. Confirm the remote branch contains the commit:

```bash
git ls-remote origin refs/heads/main
```

8. Check GitHub workflow status when useful:

```bash
gh run list --limit 5
```

9. Verify live HTTP status, redirects, and page content with `curl`.
10. If content does not appear immediately, wait a few minutes and re-check both
    `amdmachines.com` and `amd-site.pages.dev`; Cloudflare can lag even after
    the GitHub workflow succeeds.
