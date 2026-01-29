# Blog Content Improvement - Claude Code Instructions

## 🚨 START HERE - EVERY SESSION

1. **Read the tracking file**: `Instructions/blog_content_audit.csv`
2. **Find the next 3 blogs with is_shallow = "Yes" and no completion date**
3. **Update exactly 3 blogs** per session
4. **After each blog**: Update CSV - add today's date in a new "completed" column
5. **Build, test, and deploy**
6. **Verify site is live** before ending

---

## 🚨 CRITICAL RULES - NEVER BREAK

1. **NEVER change any URL** - The `url:` field must remain exactly as-is
2. **NEVER rename files**
3. **NEVER change titles**
4. **Build and test locally** before pushing
5. **Update the CSV tracker** after each blog
6. **Only 3 blogs per session** - no more

---

## Workflow

### Step 1: Check What Needs Updating
```bash
cd /Users/juan_erdmann/my-site-generator
```
Open `Instructions/blog_content_audit.csv` → find first 3 blogs needing updates (is_shallow = "Yes", no completed date)

### Step 2: Update Each Blog
For each of the 3 pending blogs:
1. Open `content/blog/[filename].md`
2. **DELETE** all generic boilerplate content
3. **WRITE** 800+ words of unique content following guidelines below
4. **UPDATE** frontmatter: description, keywords, read_time
5. **ADD** 2-3 internal links
6. **UPDATE** CSV: add today's date in completed column

### Step 3: Build and Test
```bash
python3 build.py
python3 -m http.server 8000 --directory output
```
Visit http://localhost:8000/blog/[slug]/ for each updated blog

### Step 4: Deploy
```bash
git add .
git commit -m "Improve blog content: [list the 3 blog names]"
git push origin main
```

### Step 5: Verify
Wait 2-3 minutes → check https://amdmachines.com/blog/[slug]/ for each

---

## Writing Guidelines

### Voice
- Write as **a senior automation engineer** sharing expertise
- Practical, not salesy
- Direct and confident

### Sound Human (Not AI)
- Use contractions (don't, won't, it's, we've)
- Vary sentence length
- Start some sentences with "And" or "But"
- Specific numbers and brand names (FANUC, ABB, Universal Robots, Keyence, Cognex, Yaskawa, KUKA, Epson, Omron)
- Industry jargon (cycle time, OEE, takt time, end effector, teach pendant, PLC, HMI)
- Parenthetical asides (like this)
- Informal phrases ("the truth is", "here's the thing", "bottom line")

### Content Requirements
- **800+ words minimum** unique to this topic
- **4-5 H2 sections** (##)
- **Specific examples** with real numbers
- **2-3 internal links**
- **No generic filler**

### DELETE These Boilerplate Sections
- "Key Benefits" generic bullets
- "Implementation Considerations" generic list
- "Best Practices" generic bullets
- "Looking Forward" generic predictions
- "Partner With AMD Machines" long CTA → replace with 1-2 sentence natural CTA

---

## Frontmatter Rules

### UPDATE:
```yaml
description: 'New 150-160 char description'
keywords: 'specific, relevant, keywords'
read_time: X  # words / 200
```

### NEVER CHANGE:
```yaml
title: 'Keep as-is'
url: /blog/existing-url/  # CRITICAL
date: 'keep existing'
category: Keep existing
template: blog-post.html
```

---

## Internal Links

### Solutions
- `/solutions/assembly/`
- `/solutions/robotic-cells/`
- `/solutions/machine-tending/`
- `/solutions/bin-picking/`
- `/solutions/palletizing/`
- `/solutions/material-handling/`
- `/solutions/machine-vision/`
- `/solutions/welding/`
- `/solutions/packaging/`
- `/solutions/dispensing/`
- `/solutions/screwdriving/`
- `/solutions/test-systems/`
- `/solutions/deburring/`
- `/solutions/grinding-polishing/`

### Services
- `/services/consulting/`
- `/services/maintenance-support/`
- `/services/robot-programming/`
- `/services/training/`
- `/services/digital-twins/`
- `/services/upgrades-retrofits/`

### Case Studies
- `/case-studies/automotive-powertrain-assembly/`
- `/case-studies/automotive-welding-cell/`
- `/case-studies/medical-device-assembly/`
- `/case-studies/consumer-electronics-assembly/`
- `/case-studies/electronics-vision-inspection/`
- `/case-studies/ev-battery-assembly/`
- `/case-studies/pharmaceutical-packaging/`

**Link naturally:** `When implementing [robotic machine tending](/solutions/machine-tending/), cycle time becomes critical...`

---

## Example Rewrite

### BEFORE (Bad):
```markdown
## Key Benefits
- **Increased productivity** through consistent operation...
- **Improved quality** with repeatable precision...
```

### AFTER (Good):
```markdown
## What Makes Delta Robots Different

If you've ever watched a delta robot, you know why they're called "spider robots." Those three parallel arms move blindingly fast - 150+ picks per minute in production.

The secret? Minimal moving mass. Unlike 6-axis robots with motors at each joint, delta robots keep motors at the base. The arms are just lightweight carbon fiber. Less mass = faster acceleration.

## When They Make Sense

Delta robots are specialists. They're right when you need:
- Cycle times under 0.5 seconds
- Payloads under 3kg
- Top-down conveyor access

For heavy payloads, look at [6-axis robots](/blog/6-axis-vs-scara-robots-which-is-right-for-your-application/) instead.
```

---

## Quick Commands

```bash
cd /Users/juan_erdmann/my-site-generator
python3 build.py
python3 -m http.server 8000 --directory output
git add . && git commit -m "Improve blogs: X, Y, Z" && git push origin main
```

---

## Troubleshooting

**Build fails:** `pip install jinja2 markdown pyyaml pillow`
**Site not updating:** Purge Cloudflare cache, hard refresh (Cmd+Shift+R)
**YAML errors:** Check indentation (2 spaces), quote special characters

---

*Each session: Check CSV → Update 3 blogs → Update CSV → Build → Deploy → Verify*
