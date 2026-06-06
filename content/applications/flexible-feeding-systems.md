---
title: "Flexible Feeding Systems"
short_title: "Flexible Feeding Systems"
description: "Custom vision-based flexible feeding systems — high-mix part presentation, fast changeover, engineered to your takt. Request a quote."
keywords: "flexible feeding systems, vision-based flexible feeders, flexible part feeders, flex feeder systems, Asyril Asycube, FlexiBowl, multi-part flexible feeding, vision-guided part feeding"
primary_keyword: "flexible feeding systems"
template: application.html
noindex: false
status: complete
hero_title: "Flexible Feeding Systems"
tagline: "Vision-based flexible feeders that present multiple parts to a robot with minute-level changeover."
parent_solution:
  name: "Material Handling"
  url: "/solutions/material-handling/"
related:
  - name: "Automated Pick-and-Place Systems"
    url: "/applications/automated-pick-and-place-systems/"
    kicker: "Application"
  - name: "Custom Automated Assembly Machines"
    url: "/applications/custom-assembly-machines/"
    kicker: "Application"
  - name: "Machine Vision Inspection Stations"
    url: "/applications/machine-vision-inspection-stations/"
    kicker: "Application"
at_a_glance:
  - label: "Pickable part size"
    value: "~1–150 mm"
  - label: "Pickable part weight"
    value: "Up to ~200 g"
  - label: "Throughput"
    value: "20–80 picks per minute"
  - label: "Changeover"
    value: "1–10 min (recipe-driven)"
  - label: "Platforms"
    value: "Asyril Asycube, ARS FlexiBowl, Omron FlexFactory"
  - label: "Vision"
    value: "Cognex, Keyence, Asyril SmartSight"
  - label: "Robots"
    value: "SCARA, six-axis, delta (FANUC, ABB, Yaskawa, Epson)"
  - label: "Data"
    value: "Serialized; OPC UA / MQTT / SQL to MES"
faq:
  - q: "What is a flexible feeding system?"
    a: "A flexible feeding system is a vision-guided alternative to a hard-tooled vibratory bowl. Parts are dispensed onto a flat or contoured surface, a camera locates parts that are correctly oriented and reachable, a robot picks only those, and the surface re-tumbles the rest. The same feeder handles multiple part numbers with recipe-driven changeover instead of dedicated tooling."
  - q: "How is a flexible feeder different from a vibratory bowl feeder?"
    a: "A vibratory bowl is custom-tooled for one part and orients mechanically as parts travel up a hardened track. It is fast and reliable for a single high-volume part but slow and expensive to change over, and it can damage soft or cosmetic surfaces. A flexible feeder presents parts to a camera and lets the robot do the selection, so the same hardware feeds many part numbers, changes over in minutes, and handles fragile parts without track wear."
  - q: "What part sizes and weights can a flexible feeder handle?"
    a: "Most industrial flexible feeders pick parts roughly 1 to 150 mm and up to about 200 grams. Asyril Asycube modules from 50 mm to 530 mm cover small precision parts; ARS FlexiBowl scales up to about 150 mm; conveyor-based platforms suit flat or thin parts. The right platform depends on part envelope, weight, surface finish, and how often you need to change over."
  - q: "How fast can a flexible feeding system run?"
    a: "Typical throughput is 20 to 80 robot picks per minute, depending on part size, vision cycle, and robot reach. Small precision parts on a piezo feeder with a SCARA or delta arm reach the upper end; larger parts on a rotating disc with a six-axis arm run lower. When required takt exceeds a single robot, we run multi-feeder or multi-robot cells in parallel."
  - q: "How quickly can I change over to a different part?"
    a: "Recipe-driven changeover on a flexible feeder is typically 1 to 10 minutes. A barcode or HMI selection loads the vibration profile, vision job, gripper offsets, and robot pick pattern for the new part. If the gripper is universal across the family, changeover is software only; if a quick-change end-of-arm tool is required, it adds a minute or two."
  - q: "What vision and robot brands do you integrate?"
    a: "On vision we use Cognex In-Sight 2D and 3D-A1000, Keyence CV-X and IX-G, and Asyril SmartSight where the platform requires it. On robots we use FANUC SR SCARA, LR Mate and M-1iA delta; Epson T-series SCARA; ABB IRB 1200; and Yaskawa GP series. We pick the combination to match part envelope, takt, and your plant's controls standard."
  - q: "Can a flexible feeder handle multiple part numbers in the same run?"
    a: "Yes, with limits. The same vision job can identify several similar parts if the system can differentiate them visually or by handshake from upstream, and the robot can sort to multiple destinations. For genuinely different parts, we run them as separate recipes one batch at a time, with sub-minute changeover between recipes."
  - q: "How do you handle parts that won't orient on the feeder?"
    a: "Parts the vision system cannot find in a pickable pose simply stay on the platform and get re-tumbled by the next vibration or backflip cycle. We tune the vibration profile so the steady-state pickable ratio supports the required pick rate, and we trend the recirculation count on the HMI so a part with a poor pickable yield is caught at sample build, not in production."
---

If you are evaluating **flexible feeding systems**, you are usually looking at one of three problems: a dedicated vibratory bowl that will not pay back on lower-volume part numbers, a changeover that eats hours every time a new SKU comes through, or a small-part assembly where a human is still kitting screws and clips into a robot's reach. We size the feeder, the vision, and the robot together to solve whichever is biting you hardest.

AMD Machines has designed custom [material handling automation](/solutions/material-handling/) for more than thirty years, with over 2,500 machines delivered. A flexible feeding system from AMD is engineered around your part — geometry, weight, surface finish, presentation rate, and changeover frequency — and integrated with the vision, robot, and traceability your [assembly cell](/solutions/assembly/) expects.

<figure class="app-figure" style="background-image:url('/static/images/applications/flexible-feeding-systems-1.webp')" role="img" aria-label="Vision-based flexible feeding system with piezo feeder, overhead camera, and SCARA robot picking small parts"><figcaption>Vision-guided flexible feeder with overhead camera and SCARA pick — high-mix part presentation without hard-tooled bowls.</figcaption></figure>

## What is a flexible feeding system?

A flexible feeding system is a vision-guided alternative to a hard-tooled vibratory bowl: parts are dispensed onto a flat or contoured surface, a camera locates correctly oriented parts, a robot picks only those, and the surface re-tumbles the rest. The same feeder handles multiple part numbers with recipe-driven changeover.

Compared with a dedicated bowl, a flexible feeder:

- Handles many part numbers without re-tooling the bowl
- Changes over in minutes instead of hours
- Treats fragile or cosmetic parts gently — no track wear or jam impact
- Adds vision data — locate, verify, reject — to every pick

## How a flexible feeding system works

1. **Bulk hopper dispense** — a metered hopper or elevator drops a small batch of parts onto the feeder platform.
2. **Spread and present** — controlled vibration, rotation, or a "backflip" pulse spreads parts into a thin layer in the field of view.
3. **Vision locate** — a 2D or 3D camera (Cognex In-Sight, Keyence CV-X, or Asyril SmartSight) identifies parts in a pickable pose.
4. **Robot pick** — a SCARA, six-axis, or delta robot picks only the candidates the vision system has approved.
5. **Re-orient the rest** — parts not in a pickable pose get re-tumbled by the next vibration or flip cycle.
6. **Top-up and clean-out** — the hopper replenishes as the population drops; the platform clears at the end of a run.

That sequence sustains 20–80 robot picks per minute on most industrial parts, with single-part placement repeatability driven by the robot, not the feeder.

## Flexible feeder types compared

Different platforms suit different part envelopes — picking the wrong one wastes throughput or changeover time. The main options:

| Feeder type | Mechanism | Best for | Typical part size | Typical rate |
|---|---|---|---|---|
| 3-axis piezo (Asyril Asycube) | Programmable 3-axis piezo vibration with backflip | Small precision parts, electronics, watch components | 0.1–40 mm | 30–80 ppm |
| Rotating-disc (ARS FlexiBowl) | Rotating disc + vertical impulse to reorient | Medium parts, screws, plastic moldings | 5–150 mm | 20–60 ppm |
| Conveyor-based (Omron FlexFactory) | Backlit conveyor with overhead camera and recirculation | Flat or thin parts, stamped metal, gaskets | 5–100 mm | 30–60 ppm |
| Multi-zone vibratory (custom) | Linear or radial vibration plates with vision | Narrow part families at higher volume | 10–80 mm | 40–80 ppm |

We size the feeder to your part envelope and your changeover frequency, not to a preferred vendor.

## Key components and technologies

- **Feeder platform** — Asyril Asycube 50 / 80 / 240 / 380 / 530, ARS FlexiBowl 200 / 350 / 500 / 650 / 800, Omron FlexFactory, or a custom multi-plate vibratory feeder
- **Bulk hopper or elevator** — controlled metering with low-level sensing to keep platform population stable without overload
- **Vision** — Cognex In-Sight 2D or 3D-A1000, Keyence CV-X / IX-G, or Asyril SmartSight, with backlight or front-lit illumination sized to part contrast and reflectivity
- **Robot and EOAT** — FANUC (SR-3iA SCARA, LR Mate, M-1iA delta), Epson T-series SCARA, ABB IRB 1200, or Yaskawa GP series; grippers from Schmalz (vacuum), SMC, Festo, or SCHUNK (mechanical) sized to part and acceleration
- **Controls and HMI** — Allen-Bradley CompactLogix or Siemens S7-1500 PLC, with FactoryTalk View or WinCC HMI and recipe storage per part number
- **Safety** — light curtains or area scanners (SICK, Banner), dual-channel circuits per ISO 13849 PL d/e
- **Data** — serialized logging via OPC UA, MQTT, or SQL to your MES, with rejected-pose and recirculation counters as process-health signals

<figure class="app-figure" style="background-image:url('/static/images/applications/flexible-feeding-systems-2.webp')" role="img" aria-label="Multi-feeder flexible feeding cell with six-axis robot, Cognex vision, and bulk hoppers"><figcaption>Multi-feeder cell: bulk hoppers, vision-guided platforms, and a six-axis robot serving an assembly station.</figcaption></figure>

## Integration, controls, and traceability

<div class="app-callout">A flexible feeder that does not talk to the cell around it is just an expensive vibrating plate — the value is in the handshake with the robot, the recipe, and the data.</div>

Every AMD flexible feeding system ships with:

- **Per-pick records** — part ID, locate confidence, pick pose, grip confirmation, timestamp — serialized to the MES
- **Recipe-driven changeover** — barcode scan loads vibration profile, vision job, gripper offsets, and robot pick patterns for the new part number
- **Real-time process health** — pickable-population ratio, recirculation count, and starve/jam trending on the HMI, with alarms before the line is starved
- **Upstream and downstream handshakes** — EtherNet/IP, PROFINET, or EtherCAT to conveyors, [assembly stations](/solutions/assembly/), and [machine vision inspection stations](/applications/machine-vision-inspection-stations/)

## Industries we serve

- [**Automotive**](/industries/automotive/) — clips, springs, valves, and fasteners feeding sub-assembly
- [**Electronics**](/industries/electronics/) — connectors, contacts, and small molded parts feeding [pick-and-place](/applications/automated-pick-and-place-systems/) lines
- [**Appliances**](/industries/appliances/) — knobs, brackets, and small molded parts feeding [assembly](/solutions/assembly/)
- [**Consumer products**](/industries/consumer/) — caps, closures, and small plastic components feeding packaging and kitting

<figure class="app-figure" style="background-image:url('/static/images/applications/flexible-feeding-systems-3.webp')" role="img" aria-label="Flexible feeder integrated into a robotic assembly cell with serialized pick data and recipe-driven changeover"><figcaption>Flexible feeder integrated into a robotic assembly cell — recipe-driven changeover and serialized pick data to the MES.</figcaption></figure>

## Why AMD Machines

We are not a feeder reseller. We engineer the entire flexible feeding cell in-house — feeder selection, vision, EOAT, robot, controls, safety, and MES integration — against the part on your bench and the takt on your floor:

- 30+ years of custom automation and 2,500+ machines delivered
- Feeder, vibration profile, vision job, and EOAT tuned to your specific part — not a catalog cell
- One supplier for the [assembly automation](/solutions/assembly/), [machine vision](/solutions/machine-vision/), and [marking and traceability](/solutions/marking-traceability/) the feeder integrates with
- Recipe and data architecture built in from day one, not bolted on after runoff

Have a part, a target pick rate, and the number of SKUs you need it to feed? That is enough to start. [Request a quote](/contact/) or send us your part print and we will scope the feeder around it.
