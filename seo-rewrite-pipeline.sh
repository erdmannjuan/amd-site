#!/bin/bash

# ==============================================================================
# SEO Rewrite Pipeline: /blog/automated-assembly-machines/
#
# Copy to site folder then run:
#   cp ~/Downloads/seo-rewrite-pipeline.sh /Users/juan_erdmann/my-site-generator/
#   cd /Users/juan_erdmann/my-site-generator
#   bash seo-rewrite-pipeline.sh
# ==============================================================================

SITE_DIR="/Users/juan_erdmann/my-site-generator"
SEO_DIR="$SITE_DIR/seo/2026-03-09-assembly-machines-rewrite"
TIMEOUT=600
CLAUDE_PID=""
LOG_FILE="$SEO_DIR/pipeline.log"
TOTAL_TASKS=7
START_TIME=$(date +%s)

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
DIM='\033[2m'
NC='\033[0m'

# ==============================================================================
# CLEANUP — kill Claude on Ctrl+C or error
# ==============================================================================

cleanup() {
    echo ""
    echo -e "${RED}${BOLD}⛔ Pipeline interrupted. Cleaning up...${NC}"
    
    if [ -n "$CLAUDE_PID" ] && kill -0 "$CLAUDE_PID" 2>/dev/null; then
        echo -e "${RED}   Killing Claude process $CLAUDE_PID...${NC}"
        kill "$CLAUDE_PID" 2>/dev/null || true
        sleep 2
        if kill -0 "$CLAUDE_PID" 2>/dev/null; then
            echo -e "${RED}   Force killing...${NC}"
            kill -9 "$CLAUDE_PID" 2>/dev/null || true
        fi
    fi
    
    # Kill any orphaned claude processes from this pipeline
    pgrep -f "claude.*dangerously" | while read pid; do
        kill "$pid" 2>/dev/null || true
    done
    
    echo -e "${GREEN}   ✓ Cleaned up${NC}"
    echo -e "${YELLOW}   Work saved so far in: $SEO_DIR${NC}"
    exit 1
}

trap cleanup INT TERM

# ==============================================================================
# HELPERS
# ==============================================================================

timestamp() { date '+%H:%M:%S'; }

elapsed_total() {
    local now=$(date +%s)
    local diff=$((now - START_TIME))
    printf "%dm %ds" "$((diff / 60))" "$((diff % 60))"
}

run_claude() {
    local task_num="$1"
    local task_name="$2"
    local prompt="$3"
    local output_file="$4"
    
    echo ""
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BOLD}  TASK $task_num/$TOTAL_TASKS: $task_name${NC}"
    echo -e "${DIM}  Started: $(timestamp) | Timeout: ${TIMEOUT}s | Pipeline elapsed: $(elapsed_total)${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${CYAN}  → Launching Claude (--dangerously-skip-permissions)${NC}"
    echo -e "${CYAN}  → CLAUDE.md will be read as first instruction${NC}"
    echo -e "${CYAN}  → Expected output: $(basename "$output_file")${NC}"
    
    # Write prompt to a temp file to avoid argument length limits
    local prompt_file="$SEO_DIR/.task${task_num}_prompt.txt"
    echo "$prompt" > "$prompt_file"
    
    # Launch Claude — read prompt from stdin via cat
    cat "$prompt_file" | claude -p --dangerously-skip-permissions >> "$LOG_FILE" 2>&1 &
    CLAUDE_PID=$!
    
    echo -e "${DIM}  → PID: $CLAUDE_PID${NC}"
    
    local elapsed=0
    local spinner=('⠋' '⠙' '⠹' '⠸' '⠼' '⠴' '⠦' '⠧' '⠇' '⠏')
    local spin_idx=0
    
    while kill -0 "$CLAUDE_PID" 2>/dev/null; do
        sleep 3
        elapsed=$((elapsed + 3))
        spin_idx=$(( (spin_idx + 1) % 10 ))
        
        local file_info=""
        if [ -f "$output_file" ]; then
            local cur_size
            cur_size=$(wc -c < "$output_file" 2>/dev/null | tr -d ' ')
            if [ "$cur_size" -gt 50 ]; then
                file_info=" ${GREEN}(writing: ${cur_size} bytes)${NC}"
            fi
        fi
        
        printf "\r${DIM}  ${spinner[$spin_idx]} Running... %3ds / %ds${NC}%b          " "$elapsed" "$TIMEOUT" "$file_info"
        
        if [ "$elapsed" -ge "$TIMEOUT" ]; then
            echo ""
            echo -e "${YELLOW}  ⚠️  TIMEOUT after ${TIMEOUT}s — killing Claude${NC}"
            kill "$CLAUDE_PID" 2>/dev/null || true
            sleep 2
            kill -9 "$CLAUDE_PID" 2>/dev/null || true
            CLAUDE_PID=""
            echo -e "${RED}  Check log: tail -50 $LOG_FILE${NC}"
            rm -f "$prompt_file"
            return 1
        fi
    done
    
    wait "$CLAUDE_PID" 2>/dev/null
    local exit_code=$?
    CLAUDE_PID=""
    rm -f "$prompt_file"
    
    echo ""
    
    if [ "$exit_code" -eq 0 ]; then
        echo -e "${GREEN}  ✅ $task_name — done in ${elapsed}s${NC}"
        if [ -f "$output_file" ]; then
            local size lines
            size=$(wc -c < "$output_file" | tr -d ' ')
            lines=$(wc -l < "$output_file" | tr -d ' ')
            echo -e "${GREEN}     Output: $(basename "$output_file") — ${lines} lines, ${size} bytes${NC}"
        else
            echo -e "${YELLOW}  ⚠️  Output file not found yet: $(basename "$output_file")${NC}"
            echo -e "${YELLOW}     Checking log for errors...${NC}"
            tail -10 "$LOG_FILE" | sed 's/^/     /'
        fi
    else
        echo -e "${RED}  ❌ $task_name — FAILED (exit code: $exit_code)${NC}"
        echo -e "${RED}  Last 20 lines of log:${NC}"
        tail -20 "$LOG_FILE" | sed 's/^/     /'
        return 1
    fi
    
    return 0
}

# ==============================================================================
# PRE-FLIGHT
# ==============================================================================

echo ""
echo -e "${BOLD}╔══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BOLD}║        SEO REWRITE PIPELINE — ASSEMBLY MACHINES            ║${NC}"
echo -e "${BOLD}╚══════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "  ${DIM}Target:${NC}      /blog/automated-assembly-machines/"
echo -e "  ${DIM}Working dir:${NC} $SEO_DIR"
echo -e "  ${DIM}Timeout:${NC}     ${TIMEOUT}s per task"
echo -e "  ${DIM}Mode:${NC}        ${RED}--dangerously-skip-permissions${NC}"
echo -e "  ${DIM}Context:${NC}     CLAUDE.md read by each instance as first instruction"
echo -e "  ${DIM}Tasks:${NC}       $TOTAL_TASKS sequential Claude instances"
echo ""

echo -e "${CYAN}  → Pre-flight checks...${NC}"

if [ ! -f "$SITE_DIR/build.py" ]; then
    echo -e "${RED}  ❌ build.py not found${NC}"; exit 1
fi
echo -e "${GREEN}  ✓ build.py${NC}"

if [ ! -f "$SITE_DIR/CLAUDE.md" ]; then
    echo -e "${RED}  ❌ CLAUDE.md not found in $SITE_DIR${NC}"; exit 1
fi
echo -e "${GREEN}  ✓ CLAUDE.md ($(wc -l < "$SITE_DIR/CLAUDE.md" | tr -d ' ') lines)${NC}"

if ! command -v claude &> /dev/null; then
    echo -e "${RED}  ❌ claude CLI not in PATH${NC}"; exit 1
fi
echo -e "${GREEN}  ✓ Claude CLI${NC}"

echo -e "${DIM}  Testing Claude...${NC}"
TEST_RESULT=$(echo "respond with only the word OK" | claude -p --dangerously-skip-permissions 2>&1)
if echo "$TEST_RESULT" | grep -qi "OK"; then
    echo -e "${GREEN}  ✓ Claude responding${NC}"
else
    echo -e "${YELLOW}  ⚠️  Claude test returned: $TEST_RESULT${NC}"
    echo -e "${YELLOW}  Continuing anyway — may work with longer prompts${NC}"
fi

cd "$SITE_DIR"
echo -e "${GREEN}  ✓ Directory: $(pwd)${NC}"

mkdir -p "$SEO_DIR"
echo -e "${GREEN}  ✓ Output dir created${NC}"

echo "Pipeline started: $(date)" > "$LOG_FILE"

echo ""
echo -e "${GREEN}${BOLD}  All checks passed. Launching pipeline...${NC}"
echo -e "${DIM}  Logs: $LOG_FILE${NC}"
echo -e "${DIM}  Ctrl+C to stop and kill Claude at any time${NC}"

# ==============================================================================
# REFERENCE DOC
# ==============================================================================

echo ""
echo -e "${CYAN}  → Writing REFERENCE.md...${NC}"

cat > "$SEO_DIR/REFERENCE.md" << 'REFEOF'
# SEO Rewrite Reference — /blog/automated-assembly-machines/
## Date: March 9, 2026

Each section written by a dedicated Claude instance for depth and quality.

## Why We're Doing This
- 26,512 impressions, 10 clicks, 0.04% CTR over 28 days
- Position slipping: 14.8 → 16.2
- SERP dominated by manufacturer capability pages (Tri-Mation, PAR, Taylor Winfield, JR Automation)
- Our page titled "Selection Guide", categorized "Trends" — wrong signals

## Cannibalization Rules
- `/solutions/assembly/` OWNS: "assembly automation," "assembly systems," "assembly line"
- `/blog/automated-assembly-machines/` OWNS: "automated assembly machines," "automated assembly machinery," "automated assembly equipment"
- Blog MUST link to `/solutions/assembly/`

## Target Keywords (7-day GSC, all 0 clicks)
| Query | Impressions | Position |
|---|---|---|
| automated assembly machinery | 1,022 | 4.9 |
| automated assembly machines | 470 | 6.9 |
| assembly automation | 378 | 22.4 |
| automated assembly system | 373 | 11.0 |
| automatic assembly machine | 283 | 11.9 |
| assembly line equipment | 275 | 14.1 |
| assembly machine | 271 | 18.9 |
| automated assembly line | 259 | 21.6 |
| assembly equipment | 256 | 17.5 |
| automated assembly | 241 | 15.9 |
| automated assembly systems | 131 | 13.5 |
| automated assembly equipment | 122 | 9.3 |

## Writing Style
- Engineer-to-engineer, match assembly line balancing post tone
- Specific numbers, short paragraphs (2-4 sentences)
- No filler, no exclamation marks
- Max 2 uses of "solution" in entire body
- No "cutting-edge," "state-of-the-art," "world-class"

## Required Internal Links
- `/solutions/assembly/`, `/solutions/robotic-cells/`, `/solutions/screwdriving/`
- `/solutions/servo-pressing/`, `/solutions/dispensing/`, `/solutions/machine-vision/`
- `/solutions/welding/`, `/solutions/thermal-processing/`
- `/blog/roi-of-robotic-automation/`, `/blog/assembly-line-balancing-for-optimal-efficiency/`
- `/industries/medical/`, `/industries/automotive/`, `/contact/`

## Keywords That MUST Appear (currently missing)
- "automated assembly machinery", "automated assembly systems"
- "assembly line equipment", "automatic assembly machine"
- "automated assembly equipment", "assembly automation" (sparingly)
REFEOF

echo -e "${GREEN}  ✓ REFERENCE.md created${NC}"

# ==============================================================================
# Common prefix for all prompts — tells Claude to read CLAUDE.md first
# ==============================================================================

CONTEXT_PREFIX="IMPORTANT: Before doing anything, read the file CLAUDE.md in the current directory. It contains critical site rules, SEO protections, URL rules, and cannibalization guards you MUST follow. Also read $SEO_DIR/REFERENCE.md for the specific SEO rewrite rules and keyword targets.

"

# ==============================================================================
# TASK 1
# ==============================================================================

run_claude 1 "Analyzing current page" \
"${CONTEXT_PREFIX}You are analyzing a blog post for an SEO rewrite. Your ONLY job is analysis — do not change any site content files.

1. Find the content file:
   find content/blog -name '*automated-assembly-machines*' -type f

2. Read the FULL content of that file.

3. Read the assembly line balancing post for tone reference:
   cat content/blog/assembly-line-balancing-for-optimal-efficiency.md

4. Write your analysis to $SEO_DIR/00-current-state.md:
   - EXACT FILE PATH of the content file
   - FULL CURRENT FRONTMATTER (copy verbatim)
   - SECTION OUTLINE: every H1, H2, H3 with approximate word count per section
   - TONE COMPARISON: 5 specific observations on how the assembly line balancing post differs
   - INTERNAL LINKS: every internal link in the page with anchor text

Write ONLY to $SEO_DIR/00-current-state.md. Do NOT modify any files in content/, templates/, or static/." \
"$SEO_DIR/00-current-state.md"

if [ $? -ne 0 ]; then echo -e "${RED}Pipeline stopped at Task 1.${NC}"; exit 1; fi

# ==============================================================================
# TASK 2
# ==============================================================================

run_claude 2 "Writing new frontmatter" \
"${CONTEXT_PREFIX}Read $SEO_DIR/00-current-state.md for the current frontmatter.

Write new frontmatter to $SEO_DIR/01-frontmatter.md:

1. COMPLETE YAML frontmatter — copy every existing field, only change:
   - title: 'Custom Automated Assembly Machines | Design, Build & Integration'
   - description: 'We design and build custom automated assembly machines — rotary indexing, linear transfer, and robotic systems. 30 years, 2,500+ machines delivered. Get a quote.'
   - category: change Trends to Assembly (check format: grep -l 'category' content/blog/*.md | head -5 | xargs head -15)
   - keywords: automated assembly machines, automated assembly machinery, automated assembly systems, automated assembly equipment, assembly automation
   - Keep date, template, slug, everything else unchanged

2. New H1: Automated Assembly Machines: Custom Systems Built for Your Process

3. Brief rationale for each change

Write ONLY to $SEO_DIR/01-frontmatter.md. Do NOT modify any site files." \
"$SEO_DIR/01-frontmatter.md"

if [ $? -ne 0 ]; then echo -e "${RED}Pipeline stopped at Task 2.${NC}"; exit 1; fi

# ==============================================================================
# TASK 3
# ==============================================================================

run_claude 3 "Writing opening + types section (main content)" \
"${CONTEXT_PREFIX}Read $SEO_DIR/00-current-state.md for current content.

Also read the assembly line balancing post — match its tone exactly:
cat content/blog/assembly-line-balancing-for-optimal-efficiency.md

Write to $SEO_DIR/02-opening-and-types.md — production-ready markdown:

## SECTION 1: Opening (replaces intro + What Are Automated Assembly Machines)

2 paragraphs:
- P1: AMD as builder. 2,500+ machines, 30 years. Rotary, linear, robotic, hybrid. Automotive, medical, consumer, electronics. Concept through commissioning.
- P2: Architecture choice determines throughput, flexibility, cost-per-part. How we approach selection from experience.

First-person plural. Confident. Concrete. Match assembly line balancing post.

## SECTION 2: Types of Automated Assembly Systems

Rewrite 4 subsections DEEPER and MORE OPINIONATED:

### Rotary Indexing Machines
What it is (1-2 sentences). When AMD recommends it. When it does NOT work. Real numbers: 8-15 stations, 3-8 sec/index.

### Linear Transfer Systems
Our most common architecture — why. 6-40+ stations, scalable, independent cycle times.

### Robotic Assembly Cells
Link to /solutions/robotic-cells/. 10-30 sec cycle, widest part range. Program change in minutes.

### Collaborative Robot Stations
Honest about limitations. Where cobots actually make sense vs overhyped.

After all 4, add COMPARISON TABLE:
| System Type | Best For | Typical Cycle Time | Volume Sweet Spot | Changeover Time | Relative Cost |
|---|---|---|---|---|---|
| Rotary Indexing | High-volume, balanced ops, compact | 3-8 sec/index | 500K-5M+ units/yr | Hours to days | \$\$ |
| Linear Transfer | Scalable, varying cycle times, larger parts | 5-15 sec/station | 100K-2M units/yr | Hours | \$\$-\$\$\$ |
| Robotic Cells | Medium volume, high mix, complex motions | 10-30 sec/cycle | 10K-500K units/yr | Minutes | \$\$\$ |
| Cobot Stations | Low volume, shared workspace | 15-45 sec/cycle | 1K-100K units/yr | Minutes | \$ |

Then DECISION PARAGRAPH with engineering judgment. Include 'automated assembly machinery' naturally.

Target: ~800-1000 words. Deep engineering substance.

Write ONLY to $SEO_DIR/02-opening-and-types.md. Do NOT modify any site files." \
"$SEO_DIR/02-opening-and-types.md"

if [ $? -ne 0 ]; then echo -e "${RED}Pipeline stopped at Task 3.${NC}"; exit 1; fi

# ==============================================================================
# TASK 4
# ==============================================================================

run_claude 4 "Writing condensed applications + benefits" \
"${CONTEXT_PREFIX}Read $SEO_DIR/00-current-state.md to see the bloated current sections.

Write to $SEO_DIR/03-applications-and-benefits.md — production-ready markdown:

## Assembly Processes We Integrate (H2)
REPLACES 5 H3s. Max 2 paragraphs.
P1: What AMD integrates with inline links: /solutions/screwdriving/, /solutions/servo-pressing/, /solutions/dispensing/, /solutions/machine-vision/, /solutions/thermal-processing/, /solutions/welding/.
P2: Integration engineering — making processes work together at speed. Include 'automated assembly machinery'.

## What Changes After Automation (H2)
REPLACES 5 H3s. 1 paragraph.
Numbers: 80-90% defect drop, 4-8x throughput, one operator for multiple stations.
Traceability for regulated industries. Links: /industries/medical/, /industries/automotive/.
Include 'automated assembly equipment'. Reference /blog/assembly-line-balancing-for-optimal-efficiency/.

Target: ~300-400 words total.

Write ONLY to $SEO_DIR/03-applications-and-benefits.md. Do NOT modify any site files." \
"$SEO_DIR/03-applications-and-benefits.md"

if [ $? -ne 0 ]; then echo -e "${RED}Pipeline stopped at Task 4.${NC}"; exit 1; fi

# ==============================================================================
# TASK 5
# ==============================================================================

run_claude 5 "Writing ROI section" \
"${CONTEXT_PREFIX}Read $SEO_DIR/00-current-state.md for the current weak ROI section.

Also read the assembly line balancing post for worked-example tone:
cat content/blog/assembly-line-balancing-for-optimal-efficiency.md

Write to $SEO_DIR/04-roi-section.md — production-ready markdown:

## Assembly Automation ROI (H2)
Concrete worked example:
- 4-station rotary, small electromechanical component
- Current: 3 operators at \$22/hr, 180 units/hr, 4.2% defects, two shifts
- Post-automation: 1 operator, 450 units/hr, 0.3% defects
- Math: ~\$140K labor + ~\$60K quality savings, \$200K+ capacity. System \$350K-\$500K, payback 14-18 months
- General: 12-24 month payback typical
- Link /blog/roi-of-robotic-automation/

Include 'automated assembly systems' and 'assembly line equipment' naturally.

Target: ~250-350 words.

Write ONLY to $SEO_DIR/04-roi-section.md. Do NOT modify any site files." \
"$SEO_DIR/04-roi-section.md"

if [ $? -ne 0 ]; then echo -e "${RED}Pipeline stopped at Task 5.${NC}"; exit 1; fi

# ==============================================================================
# TASK 6
# ==============================================================================

run_claude 6 "Writing planning + CTA" \
"${CONTEXT_PREFIX}Read $SEO_DIR/00-current-state.md for the current generic planning section.

Write to $SEO_DIR/05-planning-and-cta.md — production-ready markdown:

## Planning an Automated Assembly Machine Project (H2)
AMD-specific. 2-3 short paragraphs:
P1: What AMD needs from customer (parts/drawings, volumes, cycle times, quality specs).
P2: AMD lifecycle (concept, design, build, FAT, install, commissioning, support) — all in-house.
P3 (optional): Ongoing support, spare parts, modifications.
Include 'automatic assembly machine' naturally.

## Getting Started (H2)
CTA. 2-3 sentences. 30 years, 2,500+ machines. Link /solutions/assembly/ and /contact/. Direct, not salesy.

Target: ~300-400 words.

Write ONLY to $SEO_DIR/05-planning-and-cta.md. Do NOT modify any site files." \
"$SEO_DIR/05-planning-and-cta.md"

if [ $? -ne 0 ]; then echo -e "${RED}Pipeline stopped at Task 6.${NC}"; exit 1; fi

# ==============================================================================
# TASK 7: ASSEMBLE + DEPLOY
# ==============================================================================

run_claude 7 "FINAL — Assembling, verifying, deploying" \
"${CONTEXT_PREFIX}You are the final assembler. 6 previous Claude instances each wrote one section. Your job: assemble, verify, implement, build, deploy.

Step 1: Read ALL source files in order:
- $SEO_DIR/00-current-state.md (get the EXACT FILE PATH of the content file)
- $SEO_DIR/01-frontmatter.md (new frontmatter + H1)
- $SEO_DIR/02-opening-and-types.md (opening + types)
- $SEO_DIR/03-applications-and-benefits.md (applications + benefits)
- $SEO_DIR/04-roi-section.md (ROI)
- $SEO_DIR/05-planning-and-cta.md (planning + CTA)

Step 2: Read the actual current content file on disk (path from 00-current-state.md)

Step 3: Assemble complete page → save to $SEO_DIR/06-full-page.md
Order: frontmatter, H1, opening, types, applications, benefits, ROI, planning, CTA

Step 4: Quality checks on 06-full-page.md (FIX any failures):
- H1 contains 'Automated Assembly Machines'
- 'solution' max 2 times in body
- No exclamation marks
- No filler phrases
- All internal links from REFERENCE.md present
- All keyword variants from REFERENCE.md appear at least once
- Word count ~1800-2200
- Links to /solutions/assembly/
- No www.amdmachines.com URLs

Step 5: Replace actual content file with assembled content (overwrite, same path)

Step 6: Build and verify
python3 build.py
Check title, meta, H1, sitemap, no www URLs in output

Step 7: Deploy
git add .
git commit -m 'SEO rewrite: /blog/automated-assembly-machines/ — commercial repositioning, content consolidation, internal linking (March 9 2026)'
git push origin main

Step 8: Append deployment record to $SEO_DIR/REFERENCE.md (timestamp, commit hash, summary)

Report everything." \
"$SEO_DIR/06-full-page.md"

if [ $? -ne 0 ]; then echo -e "${RED}Pipeline stopped at Task 7.${NC}"; exit 1; fi

# ==============================================================================
# DONE
# ==============================================================================

trap - INT TERM

echo ""
echo -e "${GREEN}${BOLD}╔══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}${BOLD}║                    PIPELINE COMPLETE                         ║${NC}"
echo -e "${GREEN}${BOLD}╚══════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "  ${DIM}Total time:${NC}  $(elapsed_total)"
echo -e "  ${DIM}Output dir:${NC}  $SEO_DIR"
echo -e "  ${DIM}Full log:${NC}    $LOG_FILE"
echo ""

echo -e "${BOLD}  Generated files:${NC}"
for f in "$SEO_DIR"/*.md; do
    [ -f "$f" ] && echo -e "    ${GREEN}✓${NC} $(basename "$f") ${DIM}($(wc -l < "$f" | tr -d ' ') lines)${NC}"
done

echo ""
echo -e "${BOLD}  Next steps:${NC}"
echo -e "    1. Review: ${CYAN}cat $SEO_DIR/06-full-page.md${NC}"
echo -e "    2. Check: ${CYAN}https://amdmachines.com/blog/automated-assembly-machines/${NC}"
echo -e "    3. Submit URL for re-indexing in Google Search Console"
echo -e "    4. ${RED}Do NOT touch this page for 6 weeks${NC}"
echo ""
