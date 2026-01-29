# Current Blog Update Batch

## Instructions for Claude Code

**READ THIS FIRST**: This file contains the current batch of blogs to update. After completing this batch:
1. Build the site: `python3 build.py`
2. Test locally: `python3 -m http.server 8000 --directory output`
3. Commit and push: `git add . && git commit -m "Improve blog content batch X" && git push origin main`
4. Update the COMPLETED section below
5. Ask user to refresh CURRENT_BATCH.md with next batch

---

## 🚨 CRITICAL RULES

1. **NEVER change the `url:` field** in frontmatter
2. **NEVER rename files**
3. **Test build locally** before pushing
4. Write content that sounds like an engineer, not AI

---

## Current Batch: #1 (10 blogs)

### Blog 1: delta-robots-for-high-speed-pick-and-place-applications.md
- **Path**: `content/blog/delta-robots-for-high-speed-pick-and-place-applications.md`
- **Current Score**: 0 (F - Boilerplate)
- **Category**: Robotics
- **Target**: 800+ words, 4-5 sections, 2-3 internal links
- **Suggested Links**: `/solutions/packaging/`, `/solutions/assembly/`, `/blog/6-axis-vs-scara-robots-which-is-right-for-your-application/`
- **Key Topics to Cover**: Speed specs (150+ PPM), payload limits (1-3kg), working envelope, parallel kinematics, food/pharma applications, comparison to SCARA
- [ ] Completed

### Blog 2: collaborative-robots-in-manufacturing-a-complete-guide.md
- **Path**: `content/blog/collaborative-robots-in-manufacturing-a-complete-guide.md`
- **Current Score**: 0 (F - Boilerplate)
- **Category**: Robotics
- **Target**: 800+ words, 4-5 sections, 2-3 internal links
- **Suggested Links**: `/solutions/assembly/`, `/solutions/machine-tending/`, `/case-studies/medical-device-assembly/`
- **Key Topics to Cover**: ISO/TS 15066 safety standards, force limiting, speed monitoring, payload ratings by brand (UR, FANUC, ABB), real ROI examples, best applications
- [ ] Completed

### Blog 3: 6-axis-vs-scara-robots-which-is-right-for-your-application.md
- **Path**: `content/blog/6-axis-vs-scara-robots-which-is-right-for-your-application.md`
- **Current Score**: 0 (F - Boilerplate)
- **Category**: Robotics
- **Target**: 800+ words, 4-5 sections, 2-3 internal links
- **Suggested Links**: `/solutions/assembly/`, `/solutions/machine-tending/`, `/blog/scara-robot-applications-in-assembly/`
- **Key Topics to Cover**: Degrees of freedom comparison, reach vs footprint, cycle time differences, cost comparison, specific brand recommendations, decision matrix
- [ ] Completed

### Blog 4: robot-end-effectors-grippers-tools-and-custom-solutions.md
- **Path**: `content/blog/robot-end-effectors-grippers-tools-and-custom-solutions.md`
- **Current Score**: 0 (F - Boilerplate)
- **Category**: Robotics
- **Target**: 800+ words, 4-5 sections, 2-3 internal links
- **Suggested Links**: `/solutions/bin-picking/`, `/solutions/material-handling/`, `/solutions/assembly/`
- **Key Topics to Cover**: Gripper types (vacuum, mechanical, magnetic, soft), tool changers, force sensors, custom EOAT design, vendor options (Schunk, Robotiq, ATI)
- [ ] Completed

### Blog 5: understanding-robot-payload-capacity-and-reach.md
- **Path**: `content/blog/understanding-robot-payload-capacity-and-reach.md`
- **Current Score**: 0 (F - Boilerplate)
- **Category**: Robotics
- **Target**: 800+ words, 4-5 sections, 2-3 internal links
- **Suggested Links**: `/solutions/material-handling/`, `/solutions/palletizing/`, `/contact/`
- **Key Topics to Cover**: How payload is measured (at wrist vs tool tip), moment/inertia ratings, reach vs payload tradeoffs, oversizing recommendations, specific robot comparisons
- [ ] Completed

### Blog 6: scara-robot-applications-in-assembly.md
- **Path**: `content/blog/scara-robot-applications-in-assembly.md`
- **Current Score**: 0 (F - Boilerplate)
- **Category**: Robotics
- **Target**: 800+ words, 4-5 sections, 2-3 internal links
- **Suggested Links**: `/solutions/assembly/`, `/solutions/screwdriving/`, `/case-studies/consumer-electronics-assembly/`
- **Key Topics to Cover**: SCARA advantages (speed, repeatability, footprint), ideal applications, electronics assembly examples, comparison to cartesian, brand options (Epson, FANUC, Yamaha)
- [ ] Completed

### Blog 7: robot-safety-standards-iso-10218-and-ts-15066-explained.md
- **Path**: `content/blog/robot-safety-standards-iso-10218-and-ts-15066-explained.md`
- **Current Score**: 0 (F - Boilerplate)
- **Category**: Robotics
- **Target**: 800+ words, 4-5 sections, 2-3 internal links
- **Suggested Links**: `/solutions/robotic-cells/`, `/services/consulting/`, `/contact/`
- **Key Topics to Cover**: ISO 10218-1 & 10218-2 breakdown, TS 15066 collaborative applications, risk assessment process, safety-rated functions, guarding requirements, power & force limiting
- [ ] Completed

### Blog 8: selecting-the-right-robot-for-your-application.md
- **Path**: `content/blog/selecting-the-right-robot-for-your-application.md`
- **Current Score**: 0 (F - Boilerplate)
- **Category**: Robotics
- **Target**: 800+ words, 4-5 sections, 2-3 internal links
- **Suggested Links**: `/solutions/`, `/services/consulting/`, `/contact/`
- **Key Topics to Cover**: Selection criteria checklist, payload/reach/speed requirements, environment considerations (IP rating, cleanroom), TCO analysis, brand comparison framework
- [ ] Completed

### Blog 9: programming-industrial-robots-online-vs-offline-methods.md
- **Path**: `content/blog/programming-industrial-robots-online-vs-offline-methods.md`
- **Current Score**: 0 (F - Boilerplate)
- **Category**: Robotics
- **Target**: 800+ words, 4-5 sections, 2-3 internal links
- **Suggested Links**: `/services/robot-programming/`, `/services/digital-twins/`, `/solutions/robotic-cells/`
- **Key Topics to Cover**: Teach pendant programming, offline simulation software (RoboDK, RobotStudio, ROBOGUIDE), advantages of each, when to use which, programming time estimates
- [ ] Completed

### Blog 10: cobot-safety-standards-and-risk-assessment.md
- **Path**: `content/blog/cobot-safety-standards-and-risk-assessment.md`
- **Current Score**: 0 (F - Boilerplate)
- **Category**: Robotics
- **Target**: 800+ words, 4-5 sections, 2-3 internal links
- **Suggested Links**: `/solutions/assembly/`, `/services/consulting/`, `/blog/robot-safety-standards-iso-10218-and-ts-15066-explained/`
- **Key Topics to Cover**: Risk assessment methodology, body part contact limits, speed/force monitoring, safety-rated zones, documentation requirements, common misconceptions
- [ ] Completed

---

## ✅ COMPLETED THIS BATCH

| # | Filename | Date | Notes |
|---|----------|------|-------|
| | | | |

---

## Writing Quick Reference

### Voice
- Write as a senior automation engineer
- Be practical, direct, helpful
- Use contractions (don't, it's, we've)
- Include specific numbers and brand names

### Structure
Each blog needs:
- 800+ words minimum
- 4-5 H2 sections (##)
- 2-3 internal links
- Specific examples and numbers
- Natural CTA at end (1-2 sentences max)

### Frontmatter to Update
```yaml
description: 'New 150-160 char description'  # UPDATE
keywords: 'specific, relevant, keywords'      # UPDATE
read_time: X                                  # UPDATE (words/200)
```

### DO NOT CHANGE
```yaml
title: 'Keep exactly as-is'
url: /blog/keep-exactly-as-is/
date: 'keep existing'
category: Keep existing
```

---

## After Completing Batch

1. Run: `python3 build.py`
2. Test: `python3 -m http.server 8000 --directory output`
3. Verify each blog at http://localhost:8000/blog/[slug]/
4. Commit: `git add . && git commit -m "Improve blog content: batch 1 - robotics fundamentals"`
5. Push: `git push origin main`
6. Wait 2-3 minutes
7. Verify at https://amdmachines.com/blog/[slug]/
8. Update COMPLETED section above
9. Tell user to refresh with next batch
