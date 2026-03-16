#!/bin/bash

# ==============================================================================
# PHASE 1: Title & Meta Description Rewrites for Zero-Click Pages
# Run: cd /Users/juan_erdmann/my-site-generator && bash phase1-title-meta.sh
# ==============================================================================

SITE_DIR="/Users/juan_erdmann/my-site-generator"
WORK_DIR="$SITE_DIR/seo/$(date +%Y-%m-%d)-title-meta-rewrites"
TIMEOUT=600
CLAUDE_PID=""
LOG_FILE="$WORK_DIR/pipeline.log"
TOTAL_TASKS=2
START_TIME=$(date +%s)

# Colors
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
BLUE='\033[0;34m'; CYAN='\033[0;36m'; BOLD='\033[1m'
DIM='\033[2m'; NC='\033[0m'

# --- Cleanup on Ctrl+C ---
cleanup() {
    echo ""
    echo -e "${RED}⛔ Interrupted. Cleaning up...${NC}"
    if [ -n "$CLAUDE_PID" ] && kill -0 "$CLAUDE_PID" 2>/dev/null; then
        kill "$CLAUDE_PID" 2>/dev/null || true
        sleep 2
        kill -9 "$CLAUDE_PID" 2>/dev/null || true
    fi
    pgrep -f "claude.*dangerously" | while read pid; do
        kill "$pid" 2>/dev/null || true
    done
    echo -e "${YELLOW}Work saved in: $WORK_DIR${NC}"
    exit 1
}
trap cleanup INT TERM

# --- Run a Claude task ---
run_claude() {
    local task_num="$1" task_name="$2" prompt="$3" output_file="$4"
    
    echo ""
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BOLD}  TASK $task_num/$TOTAL_TASKS: $task_name${NC}"
    local now=$(date +%s); local diff=$((now - START_TIME))
    echo -e "${DIM}  $(date '+%H:%M:%S') | Timeout: ${TIMEOUT}s | Elapsed: $((diff/60))m $((diff%60))s${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${CYAN}  → Expected output: $(basename "$output_file")${NC}"
    
    local prompt_file="$WORK_DIR/.task${task_num}_prompt.txt"
    echo "$prompt" > "$prompt_file"
    
    cat "$prompt_file" | claude -p --dangerously-skip-permissions >> "$LOG_FILE" 2>&1 &
    CLAUDE_PID=$!
    echo -e "${DIM}  → PID: $CLAUDE_PID${NC}"
    
    local elapsed=0
    local spinner=('⠋' '⠙' '⠹' '⠸' '⠼' '⠴' '⠦' '⠧' '⠇' '⠏')
    while kill -0 "$CLAUDE_PID" 2>/dev/null; do
        sleep 3; elapsed=$((elapsed + 3))
        local spin_idx=$(( (elapsed / 3) % 10 ))
        local file_info=""
        if [ -f "$output_file" ]; then
            local sz=$(wc -c < "$output_file" 2>/dev/null | tr -d ' ')
            [ "$sz" -gt 50 ] && file_info=" ${GREEN}(${sz} bytes)${NC}"
        fi
        printf "\r${DIM}  ${spinner[$spin_idx]} %3ds / %ds${NC}%b          " "$elapsed" "$TIMEOUT" "$file_info"
        if [ "$elapsed" -ge "$TIMEOUT" ]; then
            echo ""; echo -e "${YELLOW}  ⚠️ TIMEOUT${NC}"
            kill "$CLAUDE_PID" 2>/dev/null; sleep 2; kill -9 "$CLAUDE_PID" 2>/dev/null
            CLAUDE_PID=""; rm -f "$prompt_file"; return 1
        fi
    done
    
    wait "$CLAUDE_PID" 2>/dev/null; local ec=$?; CLAUDE_PID=""; rm -f "$prompt_file"
    echo ""
    if [ "$ec" -eq 0 ]; then
        echo -e "${GREEN}  ✅ Done (${elapsed}s)${NC}"
        [ -f "$output_file" ] && echo -e "${GREEN}     $(basename "$output_file"): $(wc -l < "$output_file" | tr -d ' ') lines${NC}"
    else
        echo -e "${RED}  ❌ Failed (exit $ec)${NC}"; tail -15 "$LOG_FILE" | sed 's/^/     /'; return 1
    fi
}

# --- Pre-flight ---
echo -e "${BOLD}Phase 1: Title & Meta Description Rewrites${NC}"
[ ! -f "$SITE_DIR/build.py" ] && echo "❌ build.py not found" && exit 1
[ ! -f "$SITE_DIR/CLAUDE.md" ] && echo "❌ CLAUDE.md not found" && exit 1
command -v claude &>/dev/null || { echo "❌ claude CLI not found"; exit 1; }
cd "$SITE_DIR"
mkdir -p "$WORK_DIR"
echo "Started: $(date)" > "$LOG_FILE"
echo -e "${GREEN}Pre-flight passed. Starting...${NC}"

# Context prefix
CTX="IMPORTANT: First read CLAUDE.md in the current directory — it has critical site rules. Also read $WORK_DIR/REFERENCE.md for this specific project's rules.

"

# --- REFERENCE.md ---
cat > "$WORK_DIR/REFERENCE.md" << 'EOF'
# Phase 1: Title & Meta Description Rewrites
## Date: March 15, 2026

## Why
GSC data shows multiple pages ranking in top 5-10 positions with hundreds or thousands of impressions and ZERO clicks. The titles and meta descriptions are not compelling enough to earn clicks from the SERP.

## Scope
Change ONLY the title and description fields in YAML frontmatter. Do NOT change:
- H1 headings
- Body content
- Category, keywords, slug, date, template, or any other frontmatter fields
- Any other files on the site

## CRITICAL: Do NOT touch this file
The blog post at /blog/automated-assembly-machines/ was just rewritten last week and is in a Google re-evaluation period. Do NOT modify its content file in any way. Any change will reset the recovery clock.

## Pages and new values

### 1. heavy-payload-handling-with-industrial-robots
- title: "How Robots Handle Heavy Loads: Payload Sizing, Gantries & Floor-Track Systems"
- description: "How industrial robots handle heavy loads from 200 kg to 7,000 kg — payload sizing, floor-track systems, overhead gantries, and EOAT selection. From engineers who've built 2,500+ systems."

### 2. end-of-line-testing-strategies-for-quality-assurance
- title: "End-of-Line Testing: Methods, Equipment & System Design"
- description: "How to design an end-of-line test system — leak, electrical, vision, and functional test methods. Test fixture design, data integration, and first-pass yield optimization."

### 3. robot-safety-standards-iso-10218-and-ts-15066-explained
- title: "ISO 10218 & ISO/TS 15066 Explained: Robot Safety Standards for Integrators"
- description: "Practical guide to ISO 10218 and ISO/TS 15066 robot safety standards — risk assessment, safeguarding requirements, speed and force limits, and what they mean for your cell design."

### 4. assembly-line-balancing-for-optimal-efficiency
- title: "Assembly Line Balancing: Cycle Time Analysis & Station Optimization"
- description: "How to balance an assembly line — takt time calculation, station loading, bottleneck identification, and buffer sizing. Methods we use across 2,500+ production systems."

### 5. heat-staking-and-hot-plate-welding-applications
- title: "Hot Plate Welding & Heat Staking: Process Guide for Plastic Assembly"
- description: "Hot plate welding and heat staking for thermoplastic assembly — process parameters, material compatibility, joint design, and equipment selection for production environments."

### 6. vision-guided-robotics-principles-and-applications
- title: "Vision-Guided Robotics: How 2D and 3D Vision Systems Guide Industrial Robots"
- description: "How vision-guided robotics works — 2D vs 3D sensing, calibration methods, part localization, and real-world applications in assembly, bin picking, and machine tending."

### 7. understanding-robot-payload-capacity-and-reach
- title: "Robot Payload & Reach: How to Size an Industrial Robot Correctly"
- description: "Why the rated payload on a spec sheet isn't the whole story — wrist moments, inertia loads, EOAT weight, and the 25-30% headroom rule for sizing industrial robots."

## Style notes for titles
- Lead with the topic, not the brand
- Include specific technical terms that match search queries
- The site template may append " | AMD Machines" automatically — check before editing so you don't double it up

## Style notes for meta descriptions
- 150-160 characters max
- Include a specific detail or number that signals depth
- Match the search intent (informational — these are engineers researching)
- No marketing fluff, no exclamation marks
EOF

# ==============================================================================
# TASKS
# ==============================================================================

# TASK 1: Audit current frontmatter — save before state
run_claude 1 "Audit current frontmatter" \
"${CTX}Find the content markdown files for these 7 blog posts and extract their CURRENT title and description from the YAML frontmatter. Use find and grep/head to locate them:

1. heavy-payload-handling-with-industrial-robots
2. end-of-line-testing-strategies-for-quality-assurance
3. robot-safety-standards-iso-10218-and-ts-15066-explained
4. assembly-line-balancing-for-optimal-efficiency
5. heat-staking-and-hot-plate-welding-applications
6. vision-guided-robotics-principles-and-applications
7. understanding-robot-payload-capacity-and-reach

For each file, record:
- The exact file path
- The current title field value
- The current description field value
- Whether the site template appends ' | AMD Machines' to the title tag (check a built HTML file in output/ or public/ to confirm)

Also confirm that the automated-assembly-machines content file EXISTS but DO NOT open or modify it.

Write your findings to $WORK_DIR/01-current-state.md in a clean table format. Include the exact file paths — Task 2 will need them.

Do NOT modify any files in content/, templates/, or static/. Do NOT run build.py." \
"$WORK_DIR/01-current-state.md"
[ $? -ne 0 ] && echo -e "${RED}Stopped at Task 1${NC}" && exit 1

# TASK 2: Apply changes, build, verify, deploy
run_claude 2 "Apply title/meta changes, build, verify, deploy" \
"${CTX}Read $WORK_DIR/01-current-state.md for the exact file paths and current values of all 7 pages.

Read $WORK_DIR/REFERENCE.md for the new title and description values for each page.

Now do the following:

STEP 1: For each of the 7 files, update ONLY the title and description fields in the YAML frontmatter. Use the exact values from REFERENCE.md. Do NOT change any other frontmatter fields. Do NOT change any body content below the frontmatter closing ---.

STEP 2: Run python3 build.py to rebuild the site.

STEP 3: Verify the build output. For each of the 7 pages, check the built HTML file and confirm:
- The <title> tag contains the new title (check whether ' | AMD Machines' is appended by the template — if so, the frontmatter title should NOT include it)
- The <meta name=\"description\"> tag contains the new description
- The <h1> tag is UNCHANGED from the value in 01-current-state.md
- No www.amdmachines.com URLs appear in the built HTML

STEP 4: Verify sitemap.xml includes all 7 URLs.

STEP 5: Run git add -A && git commit -m 'Phase 1: Title and meta description rewrites for 7 zero-click pages' && git push

STEP 6: Write a verification report to $WORK_DIR/02-verification.md showing:
- Each page: old title → new title, old description → new description
- HTML verification results (title tag, meta tag, H1 unchanged)
- Sitemap check result
- Git push result
- List of 7 URLs to submit for re-indexing in GSC

CRITICAL: Do NOT modify the automated-assembly-machines content file. If you see it, skip it entirely." \
"$WORK_DIR/02-verification.md"
[ $? -ne 0 ] && echo -e "${RED}Stopped at Task 2${NC}" && exit 1

# --- Done ---
trap - INT TERM
END_TIME=$(date +%s)
ELAPSED=$(( (END_TIME - START_TIME) / 60 ))
echo ""
echo -e "${GREEN}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}${BOLD}  Pipeline complete — ${ELAPSED}m${NC}"
echo -e "${GREEN}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${YELLOW}NEXT STEPS:${NC}"
echo -e "  1. Purge Cloudflare cache"
echo -e "  2. Submit these URLs for re-indexing in GSC:"
echo -e "     - https://amdmachines.com/blog/heavy-payload-handling-with-industrial-robots/"
echo -e "     - https://amdmachines.com/blog/end-of-line-testing-strategies-for-quality-assurance/"
echo -e "     - https://amdmachines.com/blog/robot-safety-standards-iso-10218-and-ts-15066-explained/"
echo -e "     - https://amdmachines.com/blog/assembly-line-balancing-for-optimal-efficiency/"
echo -e "     - https://amdmachines.com/blog/heat-staking-and-hot-plate-welding-applications/"
echo -e "     - https://amdmachines.com/blog/vision-guided-robotics-principles-and-applications/"
echo -e "     - https://amdmachines.com/blog/understanding-robot-payload-capacity-and-reach/"
echo -e "  3. Check $WORK_DIR/02-verification.md for results"
echo ""
echo -e "Output: $WORK_DIR"
