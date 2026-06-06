---
title: "Robotic Bin Picking Systems | 3D Vision"
short_title: "Robotic Bin Picking Systems"
description: "Custom robotic bin picking systems — 3D vision-guided picking of randomly oriented parts from bins, totes, and gaylords. Request a quote."
keywords: "robotic bin picking systems, 3D vision bin picking, random bin picking robots, vision guided bin picking, gaylord bin picking, AI bin picking software"
primary_keyword: "robotic bin picking systems"
template: application.html
noindex: false
status: complete
hero_title: "Robotic Bin Picking Systems"
tagline: "3D vision-guided picking of randomly oriented parts from bins, totes, and gaylords — engineered for production."
parent_solution:
  name: "Robotic Bin Picking"
  url: "/solutions/bin-picking/"
related:
  - name: "Robotic Machine Tending Cells"
    url: "/applications/robotic-machine-tending-cells/"
    kicker: "Application"
  - name: "Automated Pick-and-Place Systems"
    url: "/applications/automated-pick-and-place-systems/"
    kicker: "Application"
  - name: "Flexible Feeding Systems"
    url: "/applications/flexible-feeding-systems/"
    kicker: "Application"
at_a_glance:
  - label: "Sensor methods"
    value: "Structured light, active stereo, time-of-flight"
  - label: "Pose accuracy"
    value: "±0.1–1 mm depending on sensor"
  - label: "Cycle time"
    value: "≈5–10 s per pick typical"
  - label: "Robots"
    value: "FANUC, ABB, Yaskawa, KUKA"
  - label: "Software"
    value: "Photoneo, Mech-Mind, iRVision, PickMaster Twin"
  - label: "End-of-arm tooling"
    value: "Vacuum, mechanical, magnetic, tool-change"
  - label: "Data"
    value: "Serialized; OPC UA / MQTT / SQL to MES"
  - label: "Standards"
    value: "ANSI/RIA R15.06, ISO 10218, ISO 13849"
faq:
  - q: "What is a robotic bin picking system?"
    a: "A robotic bin picking system is a production cell that uses a 3D vision sensor to locate randomly oriented parts inside a bin, tote, or gaylord, then commands an industrial robot to pick a single part and present it singulated to the next process. It runs at fixed cycle time, handles unsorted bulk part presentation, and serializes each pick for traceability."
  - q: "What is the difference between 2D vision picking and 3D bin picking?"
    a: "Two-dimensional vision picking assumes parts are lying flat on a known surface and only solves for X, Y, and rotation about the vertical axis. Three-dimensional bin picking solves the full six-degree-of-freedom pose — X, Y, Z, and three rotations — for parts piled randomly in a container. That additional information is what allows the robot to plan a collision-free approach into a cluttered bin instead of skimming parts off a flat tray."
  - q: "What pick rate and cycle time should I expect?"
    a: "Cycle times typically run between five and ten seconds per pick on well-scoped applications. The number is driven by scan time, robot speed, payload, and how aggressively the trajectory can be planned within the bin. When line takt is faster than a single robot can sustain, we either overlap the scan with robot motion, use a faster sensor, or split the work across two robots sharing one vision system."
  - q: "What part sizes work with robotic bin picking?"
    a: "Reliable bin picking with current sensors works well for parts roughly ten millimeters and larger in their smallest dimension. Below that, a flexible feeder with two-dimensional vision is usually the better fit. Above ten millimeters, the practical limit is set by the robot payload and reach — we have built cells for everything from small electronic components up to thirty-plus-kilogram castings out of gaylords."
  - q: "Can a bin picking cell handle multiple part numbers from the same bin?"
    a: "Yes. Modern AI vision software can identify and pick several distinct part types from a single mixed bin, route each variant to a different downstream destination, and switch grippers automatically through a tool changer when the parts need different end-of-arm tooling. The main scoping question is whether one universal gripper can hold every variant, or whether an automatic tool change is required."
  - q: "How do you handle shiny, dark, or oily parts?"
    a: "Surface finish is the single biggest variable in 3D vision performance, so we prototype every application with your actual production parts — not cleaned samples. Structured-light sensors with high-dynamic-range modes handle specular reflections that blind simpler sensors. For oily or scaled parts straight out of machining or forging, we select sensors and lighting that cut through the film, and we validate pick reliability with real parts before committing to a system architecture."
  - q: "What safety standards apply to robotic bin picking cells?"
    a: "All AMD bin picking cells comply with ANSI/RIA R15.06 and ISO 10218 for industrial robot safety. We perform risk assessments per ISO 12100 and design guarding, light curtains, area scanners, and safety-rated control circuits to the required ISO 13849 Performance Level. Collaborative configurations use power-and-force-limited robots per ISO/TS 15066."
  - q: "Can the cell integrate with our MES and SPC system?"
    a: "Yes. Every AMD bin picking cell serializes each pick — pose, grip confirmation, downstream verification, and timestamp — and pushes the data over OPC UA, MQTT, or direct SQL to your MES or historian. We routinely integrate with platforms such as Rockwell FactoryTalk, AVEVA Wonderware, Ignition, and SAP, and we expose pick-rate and bin-empty trending on the HMI for the operator."
---

If you are evaluating **robotic bin picking systems**, you are usually trying to solve one of three problems: an upstream feeder that can't handle the part geometry, an operator hand-sorting parts from gaylords with rising injury rates, or a downstream cell starving because parts arrive in bulk rather than oriented. We build the cell around whichever is biting you hardest.

AMD Machines has designed custom [bin picking automation](/solutions/bin-picking/) for more than thirty years, with over 2,500 machines delivered. A robotic bin picking system from AMD is engineered around your part — geometry, weight, surface finish, nesting behavior, takt, and downstream handoff — and integrated with the vision, controls, and traceability your line and your customers expect.

<figure class="app-figure" style="background-image:url('/static/images/applications/robotic-bin-picking-systems-1.webp')" role="img" aria-label="Robotic bin picking system with 3D vision sensor, six-axis robot, and gaylord of randomly oriented parts"><figcaption>Six-axis robotic bin picking cell: overhead 3D vision sensor, custom vacuum EOAT, and gaylord-to-conveyor singulation.</figcaption></figure>

## What is a robotic bin picking system?

A robotic bin picking system is a production cell that uses a 3D vision sensor to find randomly oriented parts inside a bin, tote, or gaylord, then commands an industrial robot to pick a single part and present it to the next process. It runs at deterministic cycle time, handles unsorted bulk presentation, and serializes each pick for traceability.

Compared with bowl feeders and manual sorting, a bin picking cell:

- Handles parts that bridge, tangle, or are too large or heavy for vibratory feed
- Removes the repetitive lifting and reaching task that drives ergonomic injury rates
- Maintains consistent cycle time across bin depth and part orientation
- Logs each pick — pose, grip confirmation, timestamp — to your MES

## How a robotic bin picking system works

1. **Scan** — a 3D vision sensor (Photoneo, Zivid, Keyence) acquires a point cloud of the bin and remaining parts in 200–800 ms.
2. **Segment** — AI software separates individual parts from the cluttered scan using CAD matching or trained deep-learning models.
3. **Pose estimation** — the system computes the 6-DOF position (X, Y, Z, Rx, Ry, Rz) of each candidate part to ±0.1–1 mm.
4. **Grasp plan** — the software ranks reachable parts, selects the highest-confidence pick, and computes an approach vector that clears bin walls and neighbors.
5. **Collision check** — the full approach-pick-extract-retreat trajectory is simulated against the bin, fixtures, and surrounding equipment before motion is released.
6. **Pick and confirm** — the robot executes the trajectory and the gripper (vacuum, mechanical, or magnetic) engages with sensed confirmation.
7. **Present and log** — the part lands in a singulated nest, conveyor, or downstream cell; the result is serialized to the MES.

## 3D vision methods compared

| Sensor method | Best for | Typical accuracy | Typical scan time | Representative hardware |
|---|---|---|---|---|
| Structured light | Shiny or dark parts; precision pose | ±0.1–0.3 mm | 300–800 ms | Photoneo PhoXi, Zivid Two |
| Active stereo | Mid-size parts at balanced speed and accuracy | ±0.2–0.5 mm | 150–400 ms | Keyence 3D, Cognex 3D-A5000 |
| Time-of-flight | Large parts, deep gaylords, lower-precision picks | ±1–3 mm | <100 ms | SICK Visionary-S, Basler ToF |
| Motion-aware (scan-on-the-fly) | Parts on moving conveyors or tight cycle times | ±0.3–1 mm | continuous | Photoneo MotionCam-3D |

We size the sensor to your part, bin depth, and required pose accuracy. Where appropriate we mount it on the robot wrist or on a linear axis so it can scan from multiple angles and resolve occlusions at the bottom of a gaylord.

## Key components and technologies

- **Robot and controller** — FANUC (LR Mate, M-10iD, M-20iD, M-710iC), ABB (IRB 1200, IRB 2600, IRB 4600), Yaskawa (GP series), or KUKA (KR Cybertech, KR Quantec), sized to payload, reach, and bin depth
- **3D vision sensor** — Photoneo PhoXi or MotionCam, Zivid Two, Keyence 3D, Cognex 3D-A5000, or SICK Visionary
- **Bin picking software** — Photoneo Bin Picking Studio, Mech-Mind Mech-Vision, FANUC 3D Vision iRVision, ABB PickMaster Twin, or MVTec HALCON
- **End-of-arm tooling** — vacuum (Schmalz, Piab), parallel and angular grippers (SCHUNK, Festo, OnRobot), or magnetic grippers for ferrous parts
- **Controls and HMI** — Allen-Bradley CompactLogix/ControlLogix or Siemens S7-1500, with FactoryTalk View or WinCC
- **Safety** — SICK or Banner light curtains and area scanners, dual-channel circuits per ISO 13849 PL d/e, risk assessment per ISO 12100
- **Data** — serialized logging to OPC UA, MQTT, or SQL; MES integration with Rockwell FactoryTalk, AVEVA, Ignition, or SAP

| Part attribute | Best gripper | Notes |
|---|---|---|
| Flat or smooth surface | Vacuum (Schmalz, Piab) | Fast and gentle; multi-cup sensing flags failed seals |
| Round shafts, tubes, no vacuum surface | Mechanical parallel/angular (SCHUNK, OnRobot) | Positive grip; tolerates small pose error |
| Oily or scaled ferrous parts | Electromagnetic (SCHUNK EMH) | Cuts through oil film; controlled release |
| Multi-SKU bin | SCHUNK SWS tool changer | Auto-swap between gripper types per part number |

<figure class="app-figure" style="background-image:url('/static/images/applications/robotic-bin-picking-systems-2.webp')" role="img" aria-label="Wrist-mounted 3D vision sensor scanning a deep gaylord for robotic bin picking"><figcaption>Wrist-mounted Photoneo sensor scans a deep gaylord from multiple angles to resolve bottom-of-bin occlusions.</figcaption></figure>

## Integration, controls, and traceability

<div class="app-callout">The gripper and the bin presentation make or break a bin picking project. We engineer the EOAT, the sensor mount, and the bin handling as one system — not as three catalog parts bolted together.</div>

Every AMD robotic bin picking system ships with:

- **Per-part serialized records** — pick number, 6-DOF pose, grip confirmation, downstream verification, timestamp
- **Upstream and downstream handshakes** — EtherNet/IP or PROFINET to [machine tending cells](/applications/robotic-machine-tending-cells/), [assembly stations](/solutions/assembly/), and [end-of-line test systems](/applications/end-of-line-test-systems/)
- **Recipe management** — barcode-driven setup loads gripper offsets, segmentation models, and place coordinates per part number
- **Bin-empty and pick-rate trending** on the HMI with rule-based alarms before the cell starves the line

## Industries we serve

- [**Automotive**](/industries/automotive/) — castings, forgings, and stampings fed from gaylords into machining and assembly
- [**Heavy equipment**](/industries/heavy-equipment/) — large machined housings, hydraulic blocks, and weldments
- [**Electronics**](/industries/electronics/) — small components delivered in totes for assembly feeding
- [**General manufacturing**](/industries/general-manufacturing/) — mixed-SKU kitting, fastener handling, and tote-to-line transfer

<figure class="app-figure" style="background-image:url('/static/images/applications/robotic-bin-picking-systems-3.webp')" role="img" aria-label="Robotic bin picking cell feeding singulated parts into a downstream CNC machine tending station"><figcaption>Bin-to-machine handoff: bin picking cell singulates parts into a downstream CNC machine tending station.</figcaption></figure>

## Why AMD Machines

We are not a robot reseller dropping a vision app on a stock arm. We engineer the entire cell in-house — mechanical, electrical, controls, EOAT, vision, safety, and data — against the part in your bin and the takt on your floor:

- 30+ years of custom automation and 2,500+ [robotic cells](/solutions/robotic-cells/) and machines delivered
- Sensor selection, EOAT, and bin presentation engineered together to minimize false picks
- One supplier for the [machine tending](/applications/robotic-machine-tending-cells/), [pick-and-place](/applications/automated-pick-and-place-systems/), and [flexible feeding](/applications/flexible-feeding-systems/) the cell connects to
- [Machine vision](/solutions/machine-vision/) and traceability designed in from day one

Have a part, a bin, and a takt time? That's enough to start. [Request a quote](/contact/) or send us your part print and we'll scope the cell around it.
