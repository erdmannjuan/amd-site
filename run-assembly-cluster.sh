#!/bin/bash
# =============================================================================
# AMD Machines — Assembly Cluster SEO Expansion
# Blog title/meta fix + Assembly page content expansion + FAQ schema + Deploy
#
# 7 isolated Claude instances, each with fresh context for max quality
# Uses temp files for prompts (macOS bash 3.2 compatible)
# =============================================================================

set -e

PROJECT_DIR="/Users/juan_erdmann/my-site-generator"
cd "$PROJECT_DIR"

TMPDIR_PROMPTS=$(mktemp -d)
trap 'rm -rf "$TMPDIR_PROMPTS"' EXIT

echo "============================================="
echo "Assembly Cluster SEO Expansion"
echo "Working directory: $(pwd)"
echo "============================================="
echo ""

# Verify CLAUDE.md
if [ ! -f "$PROJECT_DIR/CLAUDE.md" ]; then
  echo "ERROR: CLAUDE.md not found. Aborting."
  exit 1
fi
echo "CLAUDE.md found."
echo ""

# ---------------------------------------------------------
# TASK 1: Fix blog post title & meta description
# ---------------------------------------------------------
echo ">>> TASK 1: Fixing blog post title & meta description..."
echo ""

cat > "$TMPDIR_PROMPTS/task1.txt" << 'ENDPROMPT'
You are editing a static site built with Python + Jinja2. Content files are markdown with YAML frontmatter in the content/ directory.

Read CLAUDE.md first for project context.

Your ONLY job: update the title and description in the YAML frontmatter of the blog post about automated assembly machines. Find the file — it is likely at content/blog/automated-assembly-machines-a-selection-guide.md or content/blog/automated-assembly-machines.md or similar.

IMPORTANT: The Jinja2 template automatically appends " | AMD Machines" to the title field. Do NOT include "| AMD Machines" in the frontmatter title.

Make these exact changes:

- title: Automated Assembly Machines Selection Guide
- description: How to choose the right automated assembly machine. Compare rotary dial, linear transfer & robotic systems. Real ROI data from 2,500+ installations.

Do NOT change the H1, body content, URLs, or any other frontmatter fields.

After making changes, show me the old and new values.
ENDPROMPT

claude -p "$(cat "$TMPDIR_PROMPTS/task1.txt")" --dangerously-skip-permissions --max-turns 15

echo ""
echo "    TASK 1 complete."
echo ""

# ---------------------------------------------------------
# TASK 2: Write new assembly page content sections
# This is the main content instance — given keyword data
# and detailed writing instructions for max quality
# ---------------------------------------------------------
echo ">>> TASK 2: Expanding /solutions/assembly/ page with new content..."
echo ""

cat > "$TMPDIR_PROMPTS/task2.txt" << 'ENDPROMPT'
You are editing a static site built with Python + Jinja2. Content files are markdown with YAML frontmatter in the content/ directory.

Read CLAUDE.md first for project context. Then read the content file for the assembly page (content/solutions/assembly.md or content/solutions/assembly/index.md).

CONTEXT — WHY WE ARE DOING THIS:
The /solutions/assembly/ page currently ranks position 20-40 for high-volume assembly keywords that should be on page 1. The problem is the page lacks content that directly addresses these search terms. Here is the keyword data from Ahrefs and Google Search Console:

- "assembly automation" — 4,508 impressions/month, position 36, 0 clicks
- "assembly equipment" — 3,574 impressions/month, position 24.8, 1 click
- "automated assembly system" — 3,562 impressions/month, position 33.9, 0 clicks
- "automated assembly" — 3,324 impressions/month, position 29.4, 0 clicks
- "assembly machine" — 2,931 impressions/month, position 37.2, 0 clicks
- "automated assembly line" — 3,922 impressions/month, position 19, 0 clicks

This page is the COMMERCIAL intent page. There is a separate blog post at /blog/automated-assembly-machines-a-selection-guide/ that handles INFORMATIONAL intent ("what is assembly automation", "types of assembly machines"). Do NOT duplicate what the blog covers. This page should focus on: what AMD Machines builds, why customers choose us, what equipment we integrate, and what results we deliver.

YOUR JOB: Add TWO new H2 sections to the assembly page. Insert them in logical positions within the existing content.

NEW SECTION 1: ## What Is Assembly Automation?
Insert this BEFORE the existing "## Why Custom Assembly Automation Matters" section.
Write 200-250 words. Cover:
- A concise definition of assembly automation (2-3 sentences)
- What assembly automation equipment includes (mention: rotary dial machines, linear transfer systems, robotic assembly cells, vibratory feeders, torque tools, vision systems, press-fit stations)
- How automated assembly systems differ from manual processes (cycle time, consistency, traceability)
- End with a transition sentence to "Why Custom Assembly Automation Matters"

Naturally use these keywords in the text (do NOT stuff them — they should read naturally):
- "assembly automation" (use 2-3 times)
- "assembly equipment" (use 1-2 times)
- "automated assembly system" (use 1-2 times)

NEW SECTION 2: ## Manual vs. Automated Assembly
Insert this AFTER "## Why Custom Assembly Automation Matters" and BEFORE "## Automated Assembly Line Configurations".
Write 250-300 words. Cover:
- A brief intro (2 sentences) about when manual assembly makes sense vs when automation pays off
- A markdown comparison table with columns: | Factor | Manual Assembly | Automated Assembly |
  Rows should cover: Cycle Time, Labor Cost, Quality/Defect Rate, Throughput, Traceability, Changeover Flexibility, Upfront Cost, 3-Year TCO
  Use realistic numbers from AMD Machines' experience (you can reference the 40-60% labor savings and sub-1% scrap rates already on the page)
- A 2-3 sentence paragraph after the table explaining that the breakeven point is typically 14-24 months
- End with a CTA sentence: "Ready to see what automation could save your line? [Get a free quote](/contact/)."

Naturally use these keywords:
- "automated assembly" (use 2-3 times)
- "automated assembly line" (use 1-2 times)
- "assembly machine" (use 1-2 times)

WRITING RULES:
- Match the tone of the existing page — direct, technical but accessible, confident without being salesy
- Do NOT add any links except the /contact/ CTA at the end of section 2
- Do NOT change any existing content, headings, or frontmatter
- Do NOT add content to any other sections
- Keep markdown formatting clean — no HTML tags
- The page voice is first-person plural ("we build", "our machines", "we've delivered")

After making changes, show me both new sections and confirm where you inserted them.
ENDPROMPT

claude -p "$(cat "$TMPDIR_PROMPTS/task2.txt")" --dangerously-skip-permissions --max-turns 30

echo ""
echo "    TASK 2 complete."
echo ""

# ---------------------------------------------------------
# TASK 3: Expand FAQ section with keyword-rich questions
# ---------------------------------------------------------
echo ">>> TASK 3: Adding new FAQ entries to assembly page..."
echo ""

cat > "$TMPDIR_PROMPTS/task3.txt" << 'ENDPROMPT'
You are editing a static site built with Python + Jinja2. Content files are markdown with YAML frontmatter in the content/ directory.

Read CLAUDE.md first. Then read the assembly page content file (content/solutions/assembly.md or content/solutions/assembly/index.md).

Find the existing "## Frequently Asked Questions" section on the assembly page.

Your ONLY job: add 4 new FAQ entries to the EXISTING FAQ section. Add them AFTER the last existing FAQ entry. Do NOT remove or modify any existing FAQs.

Write these 4 new Q&A pairs:

FAQ 1:
Q: What types of assembly automation equipment does AMD Machines integrate?
A: Write 60-80 words covering the range of equipment: rotary dial and indexing machines, linear transfer systems, robotic assembly cells (FANUC, ABB, Yaskawa), vibratory and centrifugal feeders, servo press-fit stations, multi-spindle screwdrivers, dispensing systems, and vision inspection. Mention that every system is custom-engineered around the customer's specific part geometry and production targets.

FAQ 2:
Q: How much does an automated assembly system cost?
A: Write 60-80 words. Be honest: typical custom assembly machines range from $250K to $2M+ depending on station count, cycle time requirements, and complexity. Mention that ROI breakeven is typically 14-24 months based on labor savings and throughput gains. Reference the 40-60% labor cost reduction. End with: Contact us for a budgetary estimate based on your specific requirements.

FAQ 3:
Q: What is the difference between a rotary dial and linear transfer assembly line?
A: Write 80-100 words. Rotary dial: compact footprint, 4-16 stations, high speed, best for small parts with fixed variants. Linear transfer: longer, modular, 6-40+ stations, easier to add/remove stations, better for complex multi-step processes or when future expansion is needed. Both achieve sub-1% defect rates. The choice depends on part size, station count, cycle time, and floor space. AMD Machines builds both and can recommend the right architecture.

FAQ 4:
Q: Can existing manual assembly processes be automated?
A: Write 60-80 words. Yes — this is what AMD Machines specializes in. Reference 30+ years and 2,500+ machines. Most projects start with a process audit where engineers evaluate the manual workflow, identify automation opportunities, and design a phased approach. Mention that even partial automation (automating the bottleneck stations) can deliver significant ROI.

WRITING RULES:
- Match the format of existing FAQs on the page (likely ### for questions, paragraph for answers)
- Do NOT change any existing FAQs or other content
- Keep the voice technical but accessible, first-person plural
- Do NOT add links inside FAQ answers (schema markup works better without links)

After making changes, show me all 4 new FAQ entries.
ENDPROMPT

claude -p "$(cat "$TMPDIR_PROMPTS/task3.txt")" --dangerously-skip-permissions --max-turns 20

echo ""
echo "    TASK 3 complete."
echo ""

# ---------------------------------------------------------
# TASK 4: Add FAQ structured data (JSON-LD)
# ---------------------------------------------------------
echo ">>> TASK 4: Adding FAQ structured data (JSON-LD schema)..."
echo ""

cat > "$TMPDIR_PROMPTS/task4.txt" << 'ENDPROMPT'
You are editing a static site built with Python + Jinja2. Content files are markdown with YAML frontmatter. Templates are in the templates/ directory.

Read CLAUDE.md first. Then read the assembly page content file to find ALL FAQ entries (both old and newly added ones).

Your job: add FAQ structured data (JSON-LD) to the assembly page so Google can show FAQ rich results in search.

APPROACH — Pick ONE of these based on how the site is built:

OPTION A (preferred): If the assembly page content file supports adding raw HTML or a frontmatter field for structured data, add the JSON-LD directly to the content file or its frontmatter.

OPTION B: If there is a template that renders solution pages (like templates/solution.html or templates/page.html), check if there is already a block or variable for structured data. If so, add the FAQ schema for the assembly page specifically.

OPTION C: If neither A nor B works cleanly, add a <script type="application/ld+json"> block at the end of the assembly page content file (many static site generators pass this through).

The JSON-LD should follow this format:
{
  "@context": "https://schema.org",
  "@type": "FAQPage",
  "mainEntity": [
    {
      "@type": "Question",
      "name": "question text here",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "answer text here"
      }
    }
  ]
}

Include ALL FAQ entries from the assembly page (both the original ones and the 4 new ones we just added).

IMPORTANT:
- The JSON must be valid — escape any quotes in the text
- Do NOT change any visible content on the page
- Do NOT modify any other pages or templates (unless adding a reusable structured data block)
- If you modify a template, make sure it only adds FAQ schema when the page has FAQ data

After making changes, show me where you placed the JSON-LD and how many FAQ entries it contains.
ENDPROMPT

claude -p "$(cat "$TMPDIR_PROMPTS/task4.txt")" --dangerously-skip-permissions --max-turns 25

echo ""
echo "    TASK 4 complete."
echo ""

# ---------------------------------------------------------
# TASK 5: Cross-linking between blog and assembly page
# ---------------------------------------------------------
echo ">>> TASK 5: Strengthening cross-links between blog post and assembly page..."
echo ""

cat > "$TMPDIR_PROMPTS/task5.txt" << 'ENDPROMPT'
You are editing a static site built with Python + Jinja2. Content files are markdown with YAML frontmatter in the content/ directory.

Read CLAUDE.md first. Pay attention to Internal Linking Rules.

Your job: ensure strong bidirectional linking between the assembly solutions page and the assembly machines blog post. Read both files first:

1. The assembly page: content/solutions/assembly.md or content/solutions/assembly/index.md
2. The blog post: find it in content/blog/ — it is about automated assembly machines / selection guide

CHECK AND FIX THESE LINKS:

FROM BLOG POST → ASSEMBLY PAGE:
- The blog post should have a prominent link to /solutions/assembly/ near the introduction (within the first 2-3 paragraphs). The anchor text should be something like "automated assembly line systems" or "custom assembly automation solutions".
- The blog post should also link to /solutions/assembly/ in the conclusion/getting started section. Anchor text like "explore our assembly automation systems" or "get a quote for your assembly project".
- If these links already exist, verify them and move on. If not, add them.

FROM ASSEMBLY PAGE → BLOG POST:
- The assembly page should have one link to the blog post. Find a natural place — perhaps in the "What Is Assembly Automation?" section or near the comparison table. Anchor text like "read our complete guide to choosing an automated assembly machine" or "assembly machine selection guide".
- Only add ONE link from assembly → blog. Do not over-link.

FROM BLOG POST → OTHER SOLUTION PAGES:
- The blog post should link to /solutions/robotic-cells/ at least once (when it mentions robotic assembly cells). Verify or add.
- The blog post should link to /solutions/welding/ if welding is mentioned. Verify or add.
- The blog post should link to /contact/ for CTA. Verify or add.

RULES:
- All links must use relative paths (e.g., /solutions/assembly/) — never www.amdmachines.com
- All links must use /solutions/* paths — never /automated-solutions/*
- Insert links naturally into existing text — do NOT create "Related Links" sections
- Do NOT change any headings, titles, meta descriptions, or frontmatter
- Do NOT remove any existing links
- If a link already exists to the target, skip it

After making changes, list every link you added or verified.
ENDPROMPT

claude -p "$(cat "$TMPDIR_PROMPTS/task5.txt")" --dangerously-skip-permissions --max-turns 30

echo ""
echo "    TASK 5 complete."
echo ""

# ---------------------------------------------------------
# TASK 6: Build the site
# ---------------------------------------------------------
echo ">>> TASK 6: Building the site..."
echo ""

python3 build.py

echo ""
echo "    Build complete."
echo ""

# ---------------------------------------------------------
# TASK 7: Full verification of all changes
# ---------------------------------------------------------
echo ">>> TASK 7: Verifying all changes in generated HTML..."
echo ""

cat > "$TMPDIR_PROMPTS/task7.txt" << 'ENDPROMPT'
I just built a static site. The generated HTML files are in the output/ directory. Verify ALL of the following changes were applied correctly.

CHECK 1 — Blog post title/meta:
Read output/blog/automated-assembly-machines-a-selection-guide/index.html (or output/blog/automated-assembly-machines/index.html — find it):
- <title> should be: Automated Assembly Machines Selection Guide | AMD Machines
- <meta name="description"> should start with: How to choose the right automated assembly machine
- Report PASS or FAIL

CHECK 2 — Assembly page new content:
Read output/solutions/assembly/index.html:
- Should contain an H2 "What Is Assembly Automation?" BEFORE "Why Custom Assembly Automation Matters"
- Should contain an H2 "Manual vs. Automated Assembly" with a comparison table
- The table should have rows for Cycle Time, Labor Cost, Quality/Defect Rate, etc.
- Report PASS or FAIL

CHECK 3 — Assembly page new FAQs:
In the same assembly output file:
- Should contain FAQ: "What types of assembly automation equipment does AMD Machines integrate?"
- Should contain FAQ: "How much does an automated assembly system cost?"
- Should contain FAQ: "What is the difference between a rotary dial and linear transfer assembly line?"
- Should contain FAQ: "Can existing manual assembly processes be automated?"
- Report PASS or FAIL

CHECK 4 — FAQ structured data:
In the assembly output file:
- Should contain a <script type="application/ld+json"> block
- Should contain "@type": "FAQPage"
- Should contain all FAQ questions (old + new)
- The JSON should be valid
- Report PASS or FAIL

CHECK 5 — Cross-linking:
- Assembly page should link to the blog post (check for /blog/automated-assembly-machines)
- Blog post should link to /solutions/assembly/ (at least 2 links)
- Blog post should link to /solutions/robotic-cells/
- Blog post should link to /contact/
- Report PASS or FAIL

CHECK 6 — No broken patterns:
- No links on assembly page or blog post should use www.amdmachines.com
- No links should use /automated-solutions/ paths
- Title tag should NOT contain doubled "| AMD Machines | AMD Machines"
- Report PASS or FAIL

For each check, report PASS or FAIL with specific details on what is wrong if FAIL.
ENDPROMPT

claude -p "$(cat "$TMPDIR_PROMPTS/task7.txt")" --dangerously-skip-permissions --max-turns 25

echo ""
echo "    TASK 7 complete."
echo ""

# ---------------------------------------------------------
# DEPLOY: Commit + Push
# ---------------------------------------------------------
echo "============================================="
echo "ALL TASKS COMPLETE — DEPLOYING"
echo "============================================="
echo ""

git add .
git commit -m "SEO: Assembly cluster expansion — new content sections, FAQ schema, blog title fix, cross-linking"
git push origin main

echo ""
echo "============================================="
echo "DEPLOYED SUCCESSFULLY"
echo "============================================="
echo ""
echo "Changes deployed:"
echo "  1. Blog post: new title & meta description"
echo "  2. Assembly page: +2 new H2 sections (~500 words)"
echo "  3. Assembly page: +4 new FAQ entries"
echo "  4. Assembly page: FAQ structured data (JSON-LD)"
echo "  5. Cross-links: blog <-> assembly page strengthened"
echo ""
echo "Next steps:"
echo "  1. Purge Cloudflare cache"
echo "  2. Test FAQ rich results: https://search.google.com/test/rich-results"
echo "  3. Monitor GSC in 2-3 weeks for:"
echo "     - CTR changes on /solutions/assembly/"
echo "     - Position changes for 'assembly automation' cluster"
echo "     - FAQ rich result appearances"
echo ""
