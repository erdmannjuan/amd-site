# AMD Machines — Claude Code Pipeline Guide

## How to Build Multi-Task Pipelines for Site Changes

This guide explains how to create bash scripts that break site changes into focused Claude Code tasks. Each task runs a dedicated Claude instance that reads CLAUDE.md, does one thing well, saves its work, and exits. The final instance assembles everything and deploys.

**Location:** Keep this file at `/Users/juan_erdmann/my-site-generator/PIPELINE-GUIDE.md`

---

## Why Pipelines Instead of One Big Prompt

When you give Claude one massive prompt with 15 things to do, you get generic work. Each task gets 5% of its attention. By splitting into individual instances:

- Each instance focuses on ONE section with full depth
- Earlier instances save research/analysis that later ones build on
- If one task fails, you don't lose everything
- Each task reads CLAUDE.md fresh, so site rules are always enforced
- You can re-run individual tasks without redoing the whole thing

---

## The Template

Copy the template below, replace the placeholder sections, and save it as a `.sh` file in your site folder.

```bash
#!/bin/bash

# ==============================================================================
# [PIPELINE NAME]: [Brief description]
# Run: cd /Users/juan_erdmann/my-site-generator && bash [filename].sh
# ==============================================================================

SITE_DIR="/Users/juan_erdmann/my-site-generator"
WORK_DIR="$SITE_DIR/seo/$(date +%Y-%m-%d)-[short-name]"
TIMEOUT=600  # 10 min per task — increase for complex tasks
CLAUDE_PID=""
LOG_FILE="$WORK_DIR/pipeline.log"
TOTAL_TASKS=0  # Set this to your actual task count
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
echo -e "${BOLD}[PIPELINE NAME]${NC}"
[ ! -f "$SITE_DIR/build.py" ] && echo "❌ build.py not found" && exit 1
[ ! -f "$SITE_DIR/CLAUDE.md" ] && echo "❌ CLAUDE.md not found" && exit 1
command -v claude &>/dev/null || { echo "❌ claude CLI not found"; exit 1; }
cd "$SITE_DIR"
mkdir -p "$WORK_DIR"
echo "Started: $(date)" > "$LOG_FILE"
echo -e "${GREEN}Pre-flight passed. Starting...${NC}"

# Context prefix — prepended to EVERY task prompt
CTX="IMPORTANT: First read CLAUDE.md in the current directory — it has critical site rules. Also read $WORK_DIR/REFERENCE.md for this specific project's rules.

"

# --- Write your REFERENCE.md here ---
cat > "$WORK_DIR/REFERENCE.md" << 'EOF'
# [Project Name] Reference
## Date: [date]

[Project-specific rules, keyword targets, style guide, etc.]
EOF

# ==============================================================================
# TASKS — Add your tasks below
# ==============================================================================

TOTAL_TASKS=3  # Update this

# TASK 1
run_claude 1 "Task name" \
"${CTX}[Your prompt here]" \
"$WORK_DIR/01-output.md"
[ $? -ne 0 ] && echo -e "${RED}Stopped at Task 1${NC}" && exit 1

# TASK 2
run_claude 2 "Task name" \
"${CTX}[Your prompt here]" \
"$WORK_DIR/02-output.md"
[ $? -ne 0 ] && echo -e "${RED}Stopped at Task 2${NC}" && exit 1

# TASK 3 — Final: assemble and deploy
run_claude 3 "Assemble and deploy" \
"${CTX}[Assembly + deploy prompt]" \
"$WORK_DIR/03-final.md"
[ $? -ne 0 ] && echo -e "${RED}Stopped at Task 3${NC}" && exit 1

# --- Done ---
trap - INT TERM
echo -e "${GREEN}${BOLD}Pipeline complete$(NC} — $(( ($(date +%s) - START_TIME) / 60 ))m"
echo "Output: $WORK_DIR"
```

---

## How to Write Tasks

### Rule 1: Every Prompt Starts with the Context Prefix

The `CTX` variable tells Claude to read CLAUDE.md and REFERENCE.md first. Never skip this.

```bash
run_claude 1 "Task name" \
"${CTX}Your actual instructions here..." \
"$WORK_DIR/01-output.md"
```

### Rule 2: One Job Per Task

Bad (too much for one instance):
> "Analyze the current page, rewrite the title, rewrite all content sections, add internal links, build, and deploy"

Good (focused):
> "Analyze the current page. Save your analysis to [file]."

### Rule 3: Tell Claude Exactly What File to Write

Every task must end with: "Write ONLY to $WORK_DIR/[filename]. Do NOT modify any site files."

The only exception is the final assembly task, which implements changes.

### Rule 4: Tell Claude What NOT to Do

Claude in dangerous mode will edit anything. Be explicit:
- "Do NOT modify any files in content/, templates/, or static/"
- "Do NOT run build.py"
- "Do NOT commit or push"

### Rule 5: Later Tasks Read Earlier Output

Task 3 can reference Task 1's output:
```
"Read $WORK_DIR/01-analysis.md for the current state of the page.
Read $WORK_DIR/02-new-content.md for the rewritten sections.
Now assemble them..."
```

### Rule 6: The Final Task Does Everything Dangerous

Only the LAST task should:
- Modify actual site files
- Run `python3 build.py`
- Run `git add . && git commit && git push`

All earlier tasks write to the work directory only.

---

## Common Pipeline Patterns

### Pattern A: SEO Page Rewrite (like the assembly machines project)

```
TOTAL_TASKS=7

Task 1: Analyze current page → save state
Task 2: Write new frontmatter → save
Task 3: Write opening + main section → save  
Task 4: Write supporting sections → save
Task 5: Write ROI/data section → save
Task 6: Write CTA/closing → save
Task 7: Read all saved work → assemble → quality check → implement → build → deploy
```

### Pattern B: New Page Creation

```
TOTAL_TASKS=5

Task 1: Research competitors + keyword gap → save analysis
Task 2: Write page outline + frontmatter → save
Task 3: Write main body content → save
Task 4: Write supporting content + internal links → save
Task 5: Assemble → create file in content/ → update config if needed → build → deploy
```

### Pattern C: Technical Fix (redirects, broken links, meta tags)

```
TOTAL_TASKS=3

Task 1: Audit the problem — crawl site, find all broken links/issues → save report
Task 2: Write the fixes — new redirects, updated meta tags, fixed links → save
Task 3: Implement fixes → build → verify → deploy
```

### Pattern D: Multi-Page Content Batch (e.g., rewrite 5 solution pages)

```
TOTAL_TASKS=7

Task 1: Audit all 5 pages → save analysis with current state of each
Task 2: Rewrite page 1 → save
Task 3: Rewrite page 2 → save
Task 4: Rewrite page 3 → save
Task 5: Rewrite page 4 → save
Task 6: Rewrite page 5 → save
Task 7: Implement all 5 → build → verify no broken links → deploy
```

### Pattern E: Design/Template Change

```
TOTAL_TASKS=4

Task 1: Analyze current template + CSS → save what exists and what needs changing
Task 2: Write new CSS/template code → save to work dir
Task 3: Review against all page types that use this template → save compatibility report
Task 4: Implement → build → visual check on 3-5 pages → deploy
```

---

## REFERENCE.md — What to Put In It

Every pipeline needs a REFERENCE.md in the work directory. This is the project-specific rules file that all tasks read. Include:

1. **Why we're doing this** — the problem statement with data (GSC numbers, rankings, etc.)
2. **Cannibalization rules** — which pages own which keywords (check CLAUDE.md rule 7)
3. **Target keywords** — from GSC or keyword research
4. **Writing style rules** — tone, word count, forbidden phrases
5. **Required internal links** — which pages must be linked and where
6. **Constraints** — what NOT to change (URLs, templates, other pages)

---

## Work Directory Structure

All pipelines save to `seo/[date]-[short-name]/` inside the site folder:

```
my-site-generator/
└── seo/
    ├── 2026-03-09-assembly-machines-rewrite/   ← today's project
    │   ├── REFERENCE.md
    │   ├── 00-current-state.md
    │   ├── 01-frontmatter.md
    │   ├── 02-opening-and-types.md
    │   ├── 03-applications-and-benefits.md
    │   ├── 04-roi-section.md
    │   ├── 05-planning-and-cta.md
    │   ├── 06-full-page.md
    │   └── pipeline.log
    │
    ├── 2026-03-15-solutions-assembly-rewrite/  ← future project
    │   ├── REFERENCE.md
    │   ├── ...
    │   └── pipeline.log
    │
    └── 2026-04-01-new-industry-pages/          ← another project
        ├── REFERENCE.md
        ├── ...
        └── pipeline.log
```

This creates a dated record of every change. When you need to audit what happened to a page, check the seo/ folder.

---

## Quick-Start Checklist

When you need to make a site change:

1. **Decide the scope.** What pages? What changes?
2. **Check CLAUDE.md rule 7.** Which pages own which keywords? Don't create cannibalization.
3. **Pull GSC data** if it's an SEO change. Export the relevant queries/pages.
4. **Copy the template** from above into a new `.sh` file in your site folder.
5. **Write REFERENCE.md content** with the project rules.
6. **Break the work into tasks.** One task = one focused output. Final task = assemble + deploy.
7. **Write each task prompt.** Start with `${CTX}`. End with "Write ONLY to [file]. Do NOT modify site files."
8. **Set `TOTAL_TASKS`** to the correct number.
9. **Run it:**
   ```bash
   cd /Users/juan_erdmann/my-site-generator
   bash [your-script].sh
   ```
10. **After deploy:** Purge Cloudflare cache. Submit URLs for re-indexing in GSC.

---

## Troubleshooting

| Problem | Fix |
|---|---|
| "You've hit your limit" | Wait for reset (check time in error) or set API key: `claude config set --global apiKey sk-ant-...` |
| Script exits immediately at Task 1 | Check `tail -50 [work-dir]/pipeline.log` for the error |
| Claude writes to wrong file | Make the output path more explicit in the prompt. Use full absolute paths. |
| Task times out | Increase `TIMEOUT` at top of script. Some tasks need 15+ minutes. |
| Claude edits site files in a non-final task | Add "Do NOT modify any files in content/, templates/, or static/" to the prompt |
| Cloudflare shows old content after deploy | Purge cache in Cloudflare dashboard: Caching → Purge Everything |
| Claude ignores CLAUDE.md rules | The `${CTX}` prefix tells it to read CLAUDE.md. If it still ignores rules, add specific reminders in the task prompt (e.g., "Remember: never change existing URL slugs per CLAUDE.md rule 3") |
| Pipeline ran but deploy didn't happen | Check if Task 7 (final task) actually ran git push. Look in pipeline.log: `grep 'git push' [work-dir]/pipeline.log` |
| Need to re-run just one task | Currently you re-run the whole script. The earlier tasks will overwrite their files but that's fine since they're deterministic. |

---

## Giving This to Claude (claude.ai)

If you're in a claude.ai conversation and want to create a pipeline, just say:

> "Read PIPELINE-GUIDE.md in my site folder. I need a pipeline to [describe the change]. Create the .sh file following the guide."

Claude will have the template, patterns, and rules to build it without you re-explaining everything.
