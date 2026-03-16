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

---

## Deployment Record

- **Deployed:** 2026-03-09
- **Commit:** 846dc285
- **Pushed to:** main → Cloudflare Pages (auto-deploy)
- **Summary:** Complete rewrite from "Selection Guide" (educational framing) to manufacturer capability page. Title changed to "Custom Automated Assembly Machines | Design, Build & Integration". Category changed from Trends → Assembly. Body rewritten in engineer-to-engineer tone with worked ROI example, comparison table, specific cycle times and volume ranges. All 13 required internal links added (was missing 5). All 6 required keyword variants now present. Word count increased from ~1,175 to ~1,938. Zero "solution" in body text. H1 generated from title via blog-post template (single H1).
