---
title: "Automated Dispensing Systems | AMD Machines"
short_title: "Automated Dispensing Systems"
description: "Custom automated dispensing systems — adhesive, sealant, and 2K dispensing with vision-verified beads. Engineered to your part and takt. Request a quote."
keywords: "automated dispensing systems, robotic adhesive dispensing, automated sealant dispensing, fluid dispensing machines, FIPG dispensing system, two-component dispensing equipment, automated bead inspection"
primary_keyword: "automated dispensing systems"
template: application.html
noindex: false
status: complete
hero_title: "Automated Dispensing Systems"
tagline: "Adhesive, sealant, and 2K dispensing — robot or gantry — with closed-loop bead inspection and serialized records."
parent_solution:
  name: "Dispensing"
  url: "/solutions/dispensing/"
related:
  - name: "Custom Automated Assembly Machines"
    url: "/applications/custom-assembly-machines/"
    kicker: "Application"
  - name: "Automated Functional Test Stations"
    url: "/applications/automated-functional-test-stations/"
    kicker: "Application"
  - name: "Machine Vision Inspection Stations"
    url: "/applications/machine-vision-inspection-stations/"
    kicker: "Application"
at_a_glance:
  - label: "Materials"
    value: "1K & 2K adhesives, RTV silicone, polyurethane, UV-cure, thermal interface, conformal coat"
  - label: "Pump types"
    value: "Progressive cavity, piston, jet valve, 2K meter-mix, time-pressure"
  - label: "Volume accuracy"
    value: "±1% piston, ±1–2% PC pump, ±3–5% jet"
  - label: "Bead width"
    value: "±0.1–0.2 mm with closed-loop inspection"
  - label: "Dispense speed"
    value: "50–500 mm/s by valve and motion platform"
  - label: "Configurations"
    value: "6-axis robotic, Cartesian gantry, fixed-station, rotary-index"
  - label: "Vendors"
    value: "Nordson EFD/ASYMTEK, Graco, Viscotec, Scheugenpflug, Musashi, Techcon"
  - label: "Data"
    value: "Serialized; OPC UA / MQTT / SQL to MES"
faq:
  - q: "What is an automated dispensing system?"
    a: "An automated dispensing system is a production machine that meters and applies a controlled amount of adhesive, sealant, lubricant, or other fluid to a part without manual intervention. A pump or jet valve delivers the material along a programmed path traced by a robot or gantry, and the controls coordinate fixturing, dispense parameters, inline inspection, and pass-or-reject sorting at production cycle time."
  - q: "What types of materials can be dispensed automatically?"
    a: "Practically any pumpable fluid: one-part and two-part epoxies, cyanoacrylates, UV-cure adhesives, RTV silicones, polyurethane sealants, anaerobic thread lockers, thermal greases, conformal coatings, lubricating oils and greases, solder paste, and potting compounds. The key parameter is viscosity, which decides whether the right tool is a progressive cavity pump, a piston dispenser, a jet valve, or a two-component meter-mix system."
  - q: "How accurate are automated dispensing systems?"
    a: "Volumetric accuracy depends on the pump. Piston dispensers hold ±1% or better for dot and shot work. Progressive cavity pumps hold ±1–2% on continuous beads. Jet valves run ±3–5% per drop and average under ±2% across a pattern. Bead position accuracy comes from the motion platform — linear-motor gantries reach ±0.02 mm path accuracy, and 6-axis robots typically run ±0.1 mm at dispense speed. Real-world accuracy requires temperature control of the material and a maintained valve."
  - q: "How is bead quality verified in real time?"
    a: "Closed-loop bead inspection. A 2D camera or laser-profile sensor — Keyence, Cognex, or similar — images the bead immediately after dispense and checks width, position, continuity, and presence. Laser profilers add height and cross-section measurement, which is the only reliable way to catch a slow valve drift before it becomes a leak escape. Weight verification on the part is also used for potting and other fill-volume applications."
  - q: "What is the difference between a robotic dispensing cell and a gantry dispensing system?"
    a: "A 6-axis robotic dispensing cell — typically FANUC, ABB, or KUKA — follows 3D contours and is the right choice for complex housings, panels, and parts that need consistent standoff over curvature. A Cartesian gantry is faster and more accurate on flat or low-profile parts such as PCBs and lids, with linear-motor models reaching 500+ mm/s. The decision is driven by part geometry, takt time, and the future product roadmap on that line."
  - q: "How do you handle two-component (2K) adhesives without curing in the mixer?"
    a: "Pot life is managed in three ways. The static mixer is sized to the flow rate so material does not dwell long enough to gel; automatic purge cycles flush the mixer during idle periods; and pressure transducers downstream of the mixer alarm before a clog becomes a defect. For very short pot-life chemistries we use dynamic mixers with active cleaning. Mix-ratio accuracy is held to ±1% or better with gear or piston metering."
  - q: "Can the dispensing system integrate with our MES and SPC system?"
    a: "Yes. Every AMD dispensing station serializes each cycle, timestamps the result, and pushes data over OPC UA, MQTT, or direct SQL to your MES, historian, or quality database. We support real-time SPC charting and Cpk on the HMI, and we routinely integrate with Rockwell FactoryTalk, AVEVA, Ignition, and SAP. Recipe management driven by a barcode scan loads dispense path, volume, speed, and inspection thresholds per part number."
  - q: "How fast can an automated dispensing system run?"
    a: "Cycle times depend on pattern length and valve technology. A single dot dispense takes 0.1–0.3 seconds. A 200 mm perimeter gasket bead at 150 mm/s runs about 1.8 seconds including approach and retract. A jet-valve conformal coat on a 150 cm² PCB runs 5–8 seconds. Potting cycles depend on fill volume — a 5 mL cavity typically takes 3–5 seconds. When the dispense time exceeds the line takt we move to a multi-station gantry or rotary architecture."
---

If you are evaluating **automated dispensing systems** for adhesive, sealant, or fluid application, the wrong choice is usually a pump that doesn't match your material, a motion platform that can't hold bead width through corners, or a station with no real bead inspection — so a slow valve drift only shows up at downstream leak or pull test. We build the station around all three problems at once.

AMD Machines has engineered custom [dispensing systems](/solutions/dispensing/) for more than thirty years, with over 2,500 machines delivered. An automated dispensing system from AMD is built around your material chemistry, part geometry, target bead spec, and takt time — and integrated with the controls, vision, and traceability your customers and auditors expect.

<figure class="app-figure" style="background-image:url('/static/images/applications/automated-dispensing-systems-1.webp')" role="img" aria-label="Robotic automated dispensing system applying a form-in-place gasket bead with inline laser bead inspection"><figcaption>Robotic FIPG dispensing cell: 6-axis path control, progressive-cavity pump, and inline laser bead profiling.</figcaption></figure>

## What is an automated dispensing system?

An automated dispensing system is a production machine that meters and applies a controlled amount of adhesive, sealant, lubricant, or other fluid to a part along a programmed path — without an operator holding a gun. A robot or gantry traces the path, the pump or jet valve delivers volume, and inline inspection verifies the bead before the part leaves the station.

Compared to manual dispensing, an automated station:

- Holds bead width and volume within tight, deterministic tolerances every cycle
- Eliminates operator "extra just to be safe" overuse — typical material savings of 30–50%
- Verifies every bead with vision or laser profiling instead of spot-checking
- Logs serialized data — recipe, volume, dispense pressure, inspection result — to your MES

## How an automated dispensing system works

1. **Part identification** — barcode, DataMatrix, or RFID read at infeed loads the matching recipe; no scan, no dispense.
2. **Load and locate** — the part lands in a nest with hardened locators, or a [vision](/solutions/machine-vision/) routine reads fiducials and corrects the dispense path for unit-to-unit variation.
3. **Pre-dispense check** — surface presence, fiducial position, and (where required) plasma or wipe pretreatment are verified before material flows.
4. **Dispense** — the robot or gantry traces the path while the pump or jet valve delivers metered volume; speed, pressure, and Z-height are coordinated through corners and contours.
5. **Inline bead inspection** — a 2D camera or laser profiler measures width, height, position, continuity, and presence immediately after dispense.
6. **Sort and log** — pass, rework, or reject is routed automatically; serialized record pushes to MES with every dispense parameter and inspection reading.
7. **Cure or handoff** — UV, heat, or downstream handoff to assembly, [pressing](/applications/servo-press-assembly-stations/), or [functional test](/applications/automated-functional-test-stations/).

## Dispensing methods compared

| Method | Best for | Typical volume accuracy | Representative vendors |
|---|---|---|---|
| Progressive cavity (PC) pump | Medium-to-high viscosity (50k–500k cP): RTV silicone, FIPG, structural epoxy | ±1–2% on continuous bead | Viscotec, Nordson EFD, Graco |
| Piston dispenser | Precise shot metering: medical adhesives, lubricant dots, solder paste | ±1% or better | Nordson EFD Ultimus/7V, Techcon, Scheugenpflug |
| Jet valve | High-speed, small-volume dots: conformal coat, underfill, micro-bond | ±3–5% per drop, <±2% averaged | Nordson ASYMTEK DJ-9500, Musashi ML-5000X |
| Two-component meter-mix | Reactive 1:1 to 100:1: structural epoxy, polyurethane, 2K silicone | ±1% mix-ratio, ±1% volume | Graco PR70, Scheugenpflug DosP/DosC, Nordson EFD 2K |
| Time-pressure | Low-cost, low-viscosity work: thread lockers, low-criticality dots | ±5–10% | Nordson EFD Ultimus V, Techcon TS Series |

Many production lines combine methods — a jet valve for high-speed adhesive dots on a PCB plus a piston dispenser for a downstream potting cavity, or PC-pumped FIPG for the primary seal with 2K meter-mix for a secondary structural bond.

## Key components of an AMD dispensing station

- **Pump or valve** — Nordson EFD, Nordson ASYMTEK, Graco, Viscotec, Scheugenpflug, Musashi, or Techcon, sized to material viscosity, shot size, and cycle time
- **Material conditioning** — heated hoses, jacketed valves, and material temperature controllers holding ±1 °C; chilled lines for cyanoacrylates and other temperature-sensitive chemistries
- **Motion platform** — see below
- **Inline bead inspection** — Keyence LJ-X8000 laser profiler, Cognex In-Sight 2800, or Keyence CV-X 2D vision
- **Controls and HMI** — Allen-Bradley CompactLogix/ControlLogix or Siemens S7-1500, with FactoryTalk View or WinCC
- **Safety system** — dual-channel circuits per ISO 13849, interlocked guarding, UV containment where applicable
- **Sortation and data** — pass/rework/reject routing, reject-bin lockout, serialized records to your MES

<figure class="app-figure" style="background-image:url('/static/images/applications/automated-dispensing-systems-2.webp')" role="img" aria-label="Two-component automated dispensing system with meter-mix unit, heated lines, and serialized data capture"><figcaption>Two-component meter-mix station: gear-metered ratio control, heated supply, and PLC-driven dispense sequence.</figcaption></figure>

| Motion platform | Typical hardware | Best for |
|---|---|---|
| 6-axis robotic cell | FANUC LR Mate 200iD, M-10iD; ABB IRB 4600; KUKA KR 10 | 3D contours, large housings, panels |
| Cartesian gantry | Festo, Bosch Rexroth, IAI; ball-screw or linear motor | Flat parts: PCBs, lids, gaskets, panels |
| Fixed-station | Servo stage or [rotary dial](/solutions/assembly/) indexing under fixed valve | High-volume dedicated lines, sub-2 s dispense |

## Integration, controls, and traceability

A good dispensing station is a data-producing station. Every AMD automated dispensing system ships with:

- **Per-part serialized records** — part ID, recipe, volume, dispense pressure, bead-inspection result, operator, timestamp
- **Real-time SPC** — width, height, and volume trended with rule-based alarming on the HMI
- **Recipe management** — barcode scan loads path, speed, volume, and inspection thresholds per part number
- **MES integration** — OPC UA, MQTT, ODBC/SQL, or REST push to Rockwell FactoryTalk, AVEVA, Ignition, SAP, or a custom historian
- **Material monitoring** — reservoir level, pressure, and temperature logged; low-level and out-of-spec alarming for unattended operation

<div class="app-callout">The dispense defects that hurt most aren't the obvious ones — they're the slow valve drifts that look fine to the eye. Closed-loop bead inspection on every part is what catches them before they reach your customer.</div>

## Industries we serve

- [**Automotive**](/industries/automotive/) — FIPG transmission and powertrain gaskets, structural body bonding, EV battery cell potting and cold-plate sealing
- [**Electronics**](/industries/electronics/) — conformal coating, underfill, and selective adhesive bonding on PCBs and modules
- [**Appliances**](/industries/appliances/) — door-liner gaskets, motor potting, and fluid-handling seal beads
- [**Heavy equipment**](/industries/heavy-equipment/) — hydraulic component sealing, hose-end potting, and structural adhesive bonding
- [**Aerospace and defense**](/industries/aerospace/) — sensor potting, fastener locking, and FAI/PPAP-controlled bond beads

## Why AMD Machines

We are not a pump reseller bolting a Nordson or Graco unit onto a frame. We engineer the entire station in-house — mechanical, electrical, controls, fluid power, vision, and data — against the part on your bench and the takt on your floor:

- 30+ years of custom automation and 2,500+ machines delivered
- Pump selection and material conditioning matched to your chemistry, not the other way around
- Inline bead inspection sized to your reject threshold with measurement-system margin
- One supplier for the [assembly automation](/solutions/assembly/), [robotic cell](/solutions/robotic-cells/), and [downstream test](/applications/automated-leak-test-stations/) the dispenser integrates with

Have a part, a material datasheet, and a takt time? That's enough to start. [Request a quote](/contact/) or send us your part print and we will scope the station around it.
