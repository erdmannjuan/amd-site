# Current State: Title & Meta Description Audit
## Date: 2026-03-15

## Template behavior
The site template (`blog-post.html` via `base.html`) **automatically appends ` | AMD Machines`** to the title frontmatter value in the rendered `<title>` tag. New titles must account for this suffix.

Confirmed via: `output/blog/heavy-payload-handling-with-industrial-robots/index.html` line 6:
```
<title>Heavy Payload Handling with Industrial Robots | AMD Machines</title>
```

## Automated Assembly Machines file
- **File exists**: `content/blog/automated-assembly-machines.md` — confirmed present
- **DO NOT MODIFY** — in Google re-evaluation period per REFERENCE.md

## Current frontmatter for the 7 target pages

| # | Slug | File Path | Current Title | Current Description |
|---|------|-----------|---------------|---------------------|
| 1 | heavy-payload-handling-with-industrial-robots | `content/blog/heavy-payload-handling-with-industrial-robots.md` | Heavy Payload Handling with Industrial Robots | Technical guide to heavy payload handling with industrial robots covering robot selection, end-of-arm tooling, structural considerations, and safety requirements for loads from 100 kg to over 2,000 kg. |
| 2 | end-of-line-testing-strategies-for-quality-assurance | `content/blog/end-of-line-testing-strategies-for-quality-assurance.md` | End-of-Line Testing Strategies for Quality Assurance | Quality assurance through automated testing and inspection has become essential for manufacturers facing demanding specifications and cost pressures.. |
| 3 | robot-safety-standards-iso-10218-and-ts-15066-explained | `content/blog/robot-safety-standards-iso-10218-and-ts-15066-explained.md` | Robot Safety Standards: ISO 10218 and TS 15066 Explained | A practical engineering guide to ISO 10218-1, ISO 10218-2, and ISO/TS 15066 robot safety standards covering risk assessment, safeguarding, collaborative operations, and compliance for industrial automation. |
| 4 | assembly-line-balancing-for-optimal-efficiency | `content/blog/assembly-line-balancing-for-optimal-efficiency.md` | Assembly Line Balancing for Optimal Efficiency | Automated assembly represents a significant opportunity for manufacturers to improve quality, reduce costs, and increase capacity. The challenge lies in. |
| 5 | heat-staking-and-hot-plate-welding-applications | `content/blog/heat-staking-and-hot-plate-welding-applications.md` | Heat Staking and Hot Plate Welding Applications | Heat staking and hot plate welding provide fast, clean thermal joining for plastic assemblies. Learn process fundamentals, design guidelines, material selection, and quality control for both methods. |
| 6 | vision-guided-robotics-principles-and-applications | `content/blog/vision-guided-robotics-principles-and-applications.md` | Vision-Guided Robotics: Principles and Applications | Learn how vision-guided robotics uses cameras and algorithms to give industrial robots real-time spatial awareness for pick-and-place, assembly, and inspection tasks. |
| 7 | understanding-robot-payload-capacity-and-reach | `content/blog/understanding-robot-payload-capacity-and-reach.md` | Understanding Robot Payload Capacity and Reach | Learn how robot payload capacity and reach specs actually work, why rated payload isn't the whole story, and how to size robots correctly for your application. |

## Issues noted
- **Page 2** (end-of-line-testing): Description ends with double period `..` and is a generic sentence that doesn't describe the article content
- **Page 4** (assembly-line-balancing): Description ends with a period-terminated fragment `The challenge lies in.` — appears truncated
- **Pages 2 & 4**: Descriptions read like generic AI-generated intros rather than specific meta descriptions
- **All 7 titles**: Generic/descriptive style — none include specific technical terms that would differentiate in SERP results
