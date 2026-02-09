#!/bin/bash
# =============================================================================
# AMD Machines SEO Update Script
# Runs Phase 1 (title/meta) and Phase 2 (H1, H2, internal links) via Claude Code
# Each task spawns a fresh Claude instance with --dangerously-skip-permissions
#
# NOTE: Uses temp files for prompts to avoid macOS bash 3.2 heredoc bug
# =============================================================================

set -e  # Exit on any error

PROJECT_DIR="/Users/juan_erdmann/my-site-generator"
cd "$PROJECT_DIR"

TMPDIR_PROMPTS=$(mktemp -d)
trap 'rm -rf "$TMPDIR_PROMPTS"' EXIT

echo "============================================="
echo "AMD Machines SEO Update Script"
echo "Working directory: $(pwd)"
echo "============================================="
echo ""

# ---------------------------------------------------------
# STEP 0: Verify CLAUDE.md is in place
# ---------------------------------------------------------
echo ">>> STEP 0: Verifying CLAUDE.md is in place..."
if [ -f "$PROJECT_DIR/CLAUDE.md" ]; then
  echo "    CLAUDE.md found."
else
  echo "    WARNING: CLAUDE.md not found in project root."
  echo "    Place the updated CLAUDE.md in $PROJECT_DIR before continuing."
  exit 1
fi
echo ""

# ---------------------------------------------------------
# TASK 1: Phase 1 — Title tag & meta description updates
# (Already completed successfully — skipping)
# ---------------------------------------------------------
echo ">>> TASK 1: SKIPPED (already completed in previous run)"
echo ""

# ---------------------------------------------------------
# TASK 2: Phase 2a — H1 updates on 3 pages
# ---------------------------------------------------------
echo ">>> TASK 2: Updating H1 headings on 3 pages..."
echo ""

cat > "$TMPDIR_PROMPTS/task2.txt" << 'ENDPROMPT'
You are editing a static site built with Python + Jinja2. Content files are markdown with YAML frontmatter in the content/ directory.

Read CLAUDE.md first for project context.

Your ONLY job: change the H1 heading (the main # heading in the markdown content) on these 3 pages. Do NOT change title tags, meta descriptions, URLs, or any other content.

Find each file and make these exact H1 changes:

PAGE 1: /solutions/assembly/ (content file for the assembly page)
- Find the H1 that says: Custom Assembly Systems
- Change it to: Automated Assembly Systems

PAGE 2: /solutions/ (content file for the solutions index page)
- Find the H1 that says: Our Solutions
- Change it to: Automation Solutions

PAGE 3: /industries/ (content file for the industries index page)
- Find the H1 that says: Industries We Serve
- Change it to: Industrial Automation Equipment by Industry

Only change the H1 markdown heading (the line starting with single #). Do NOT touch H2s, body text, YAML frontmatter, or anything else in these files.

After making all 3 changes, list what you changed so I can verify.
ENDPROMPT

claude -p "$(cat "$TMPDIR_PROMPTS/task2.txt")" --dangerously-skip-permissions --max-turns 25

echo ""
echo "    TASK 2 complete."
echo ""

# ---------------------------------------------------------
# TASK 3: Phase 2b — H2 renames on assembly page
# ---------------------------------------------------------
echo ">>> TASK 3: Renaming 3 H2 headings on assembly page..."
echo ""

cat > "$TMPDIR_PROMPTS/task3.txt" << 'ENDPROMPT'
You are editing a static site built with Python + Jinja2. Content files are markdown with YAML frontmatter in the content/ directory.

Read CLAUDE.md first for project context.

Your ONLY job: rename 3 H2 headings on the assembly page. Do NOT change any content underneath the headings — only change the heading text itself. Do NOT change the H1, title, meta, or any other headings on this page.

Find the assembly page content file (content/solutions/assembly.md or content/solutions/assembly/index.md) and make these exact changes:

H2 RENAME 1:
- Find: ## Machine Configurations: Choosing the Right Architecture
- Change to: ## Automated Assembly Line Configurations

H2 RENAME 2:
- Find: ## Core Assembly Operations We Integrate
- Change to: ## Assembly Automation Equipment & Operations

H2 RENAME 3:
- Find: ## The ROI of Custom Assembly Automation
- Change to: ## Assembly Automation ROI & Cost Analysis

Do NOT rename any other H2s on this page. Keep all content under each heading exactly as-is.

After making all 3 changes, list what you changed so I can verify.
ENDPROMPT

claude -p "$(cat "$TMPDIR_PROMPTS/task3.txt")" --dangerously-skip-permissions --max-turns 25

echo ""
echo "    TASK 3 complete."
echo ""

# ---------------------------------------------------------
# TASK 4: Phase 2c — Internal linking across pages
# ---------------------------------------------------------
echo ">>> TASK 4: Adding internal links across pages..."
echo ""

cat > "$TMPDIR_PROMPTS/task4.txt" << 'ENDPROMPT'
You are editing a static site built with Python + Jinja2. Content files are markdown with YAML frontmatter in the content/ directory.

Read CLAUDE.md first for project context. Pay special attention to the Internal Linking Rules.

Your job: add contextual internal links between pages. Insert links naturally within existing body text — do NOT create new "Related Links" sections at the bottom of pages. Find a natural sentence where the topic is already mentioned and turn the relevant phrase into a link.

IMPORTANT RULES:
- All links must use relative paths (e.g., /solutions/assembly/) — never use www.amdmachines.com
- All links must use /solutions/* paths — never /automated-solutions/*
- Do NOT change any headings, titles, meta descriptions, or URLs
- Do NOT remove any existing content — only add links to existing text
- If a link already exists to the target page, skip that one

Here are the links to add:

LINKS TO /solutions/assembly/ (from other pages):

1. FROM /solutions/ hub page: In the Assembly Systems section, ensure there is a link to /solutions/assembly/. If the section mentions assembly systems but does not link to the page, add: [automated assembly systems](/solutions/assembly/)

2. FROM /solutions/robotic-cells/: Find where assembly is mentioned (likely in applications or the flexible robotic assembly cells section). Add a contextual link like: For dedicated assembly lines, see our [automated assembly systems](/solutions/assembly/).

3. FROM /blog/automated-assembly-machines-a-selection-guide/ (or similar slug — find the assembly machines blog post): Add a prominent link near the introduction or conclusion: Explore our [automated assembly line systems and equipment](/solutions/assembly/) or [contact us for a free consultation](/contact/).

LINKS TO /solutions/welding/ (from other pages):

4. FROM /solutions/ hub page: In the Welding Automation section, ensure there is a link to /solutions/welding/.

5. FROM /solutions/robotic-cells/: Find where welding is mentioned. Add: For dedicated welding systems, see our [welding automation solutions](/solutions/welding/).

LINKS TO /solutions/robotic-cells/ (from other pages):

6. FROM /solutions/assembly/: In the Flexible Robotic Assembly Cells subsection, add: Learn more about our [robotic cell capabilities](/solutions/robotic-cells/).

7. FROM /solutions/welding/: In the cell configurations or welding cells section, add: See our full [robotic cell solutions](/solutions/robotic-cells/) for applications beyond welding.

LINKS TO /industries/ (from solution pages):

8. FROM /solutions/assembly/: In the applications or industry section, add: See all the [industries we serve with automation equipment](/industries/).

9. FROM /solutions/robotic-cells/: Add: Explore the [industries using robotic automation](/industries/).

LINKS FROM /solutions/assembly/ (to other pages):

10. FROM /solutions/assembly/ TO /solutions/robotic-cells/: In the Flexible Robotic Assembly Cells section, link the phrase "robotic cells" to /solutions/robotic-cells/.

11. FROM /solutions/assembly/ TO /solutions/test-systems/: Verify the existing "learn more about our test systems" link points to /solutions/test-systems/ (not /automated-solutions/test-systems/). Fix if needed.

LINK AUDIT:
12. Check all "Frequently Paired With" and "Customers Also Viewed" sections on /solutions/assembly/, /solutions/robotic-cells/, and /solutions/welding/. Verify every link uses /solutions/* paths. Fix any that use /automated-solutions/* paths.

After making changes, list every link you added or fixed so I can verify.
ENDPROMPT

claude -p "$(cat "$TMPDIR_PROMPTS/task4.txt")" --dangerously-skip-permissions --max-turns 50

echo ""
echo "    TASK 4 complete."
echo ""

# ---------------------------------------------------------
# TASK 5: Build the site
# ---------------------------------------------------------
echo ">>> TASK 5: Building the site..."
echo ""

python3 build.py

echo ""
echo "    Build complete."
echo ""

# ---------------------------------------------------------
# TASK 6: Verify the changes in output
# ---------------------------------------------------------
echo ">>> TASK 6: Verifying changes in generated HTML..."
echo ""

cat > "$TMPDIR_PROMPTS/task6.txt" << 'ENDPROMPT'
I just built a static site. The generated HTML is in the output/ directory. Verify these changes were applied correctly by reading the HTML files:

1. Check output/solutions/robotic-cells/index.html:
   - <title> should be: Robotic Cells for Manufacturing & Assembly | AMD Machines
   - <meta name="description"> should start with: Custom robotic cells for CNC machine tending
   - H1 should be: Custom Robotic Cells (unchanged)

2. Check output/solutions/index.html:
   - <title> should be: Automated Assembly & Automation Solutions | AMD Machines
   - H1 should be: Automation Solutions

3. Check output/solutions/welding/index.html:
   - <title> should be: Welding Automation Systems & Equipment | AMD Machines
   - H1 should be: Welding Automation Systems (unchanged)

4. Check output/solutions/assembly/index.html:
   - <title> should be: Automated Assembly Line Systems & Equipment | AMD Machines
   - H1 should be: Automated Assembly Systems
   - H2s should include: Automated Assembly Line Configurations, Assembly Automation Equipment & Operations, Assembly Automation ROI & Cost Analysis
   - Should contain links to /solutions/robotic-cells/ and /industries/

5. Check output/industries/index.html:
   - <title> should be: Industrial Automation Equipment by Industry | AMD Machines
   - H1 should be: Industrial Automation Equipment by Industry

For each page, report PASS or FAIL with details on what is wrong.

Also check that NO internal links use www.amdmachines.com or /automated-solutions/ paths in any of these 5 files.
ENDPROMPT

claude -p "$(cat "$TMPDIR_PROMPTS/task6.txt")" --dangerously-skip-permissions --max-turns 25

echo ""
echo "    TASK 6 complete."
echo ""

# ---------------------------------------------------------
# DONE — Manual steps remaining
# ---------------------------------------------------------
echo "============================================="
echo "ALL TASKS COMPLETE"
echo "============================================="
echo ""
echo "Manual steps remaining:"
echo ""
echo "  1. Preview locally:"
echo "     python3 -m http.server 8000 --directory output"
echo "     Open http://localhost:8000 and spot-check pages"
echo ""
echo "  2. If everything looks good, commit and deploy:"
echo "     git add ."
echo "     git commit -m 'SEO: Phase 1+2 title tags, H1s, H2s, internal links'"
echo "     git push origin main"
echo ""
echo "  3. Purge Cloudflare cache after deploy"
echo ""
echo "  4. Monitor GSC in 1-3 weeks for CTR changes"
echo ""
