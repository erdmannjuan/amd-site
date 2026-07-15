---
title: "Machine Vision Inspection Stations"
short_title: "Machine Vision Inspection Stations"
description: "Custom machine vision inspection stations — Cognex, Keyence, AI defect detection, vision-guided robotics. Engineered for your part. Request a quote."
keywords: "machine vision inspection stations, automated optical inspection systems, AOI station, vision inspection equipment, automated visual inspection, 2D 3D vision inspection, deep learning vision inspection, vision guided robotics"
primary_keyword: "machine vision inspection stations"
template: application.html
noindex: false
status: complete
hero_title: "Machine Vision Inspection Stations"
tagline: "High-speed 2D, 3D, and AI vision for presence, measurement, defect detection, and verification — fixtured, lit, and data-logged for production."
parent_solution:
  name: "Machine Vision"
  url: "/solutions/machine-vision/"
related:
  - name: "Automated Functional Test Stations"
    url: "/applications/automated-functional-test-stations/"
    kicker: "Application"
  - name: "Part Marking & Traceability Systems"
    url: "/applications/part-marking-traceability-systems/"
    kicker: "Application"
  - name: "End-of-Line Test Systems"
    url: "/applications/end-of-line-test-systems/"
    kicker: "Application"
at_a_glance:
  - label: "Inspection types"
    value: "Presence/absence, dimensional, defect, OCR/OCV, color, 3D profile"
  - label: "Vision platforms"
    value: "Cognex In-Sight, VisionPro, ViDi; Keyence CV-X, XG-X, AI"
  - label: "Cameras"
    value: "2D area-scan, line-scan, smart cameras, 3D laser profilers"
  - label: "Measurement repeatability"
    value: "±0.005–0.025 mm typical with calibrated optics"
  - label: "Cycle time"
    value: "Sub-100 ms to a few seconds per inspection"
  - label: "Configurations"
    value: "Standalone, in-line, rotary, multi-camera, robot-mounted"
  - label: "Data"
    value: "Serialized images + results; OPC UA / MQTT / SQL to MES"
  - label: "Standards"
    value: "IATF 16949 MSA, PPAP, Gauge R&R"
faq:
  - q: "What is a machine vision inspection station?"
    a: "A machine vision inspection station is a production machine that uses one or more cameras, controlled lighting, and image-processing software to inspect every part at full line speed. It checks features such as presence, dimensions, surface defects, color, and printed or marked codes, then routes each part to pass, reject, or rework with a serialized data record. Unlike a manual visual inspection, it inspects 100 percent of production with consistent, quantifiable pass/fail criteria."
  - q: "What is the difference between 2D and 3D machine vision inspection?"
    a: "Two-dimensional vision captures a flat image and is best for presence/absence, in-plane measurements, OCR, barcode reading, and surface defect detection. Three-dimensional vision adds height data using laser triangulation, structured light, stereo, or time-of-flight, which is required for true geometric measurements such as flatness, gap and flush, weld bead profile, volume, or warp. Most production stations use 2D for the majority of checks and add 3D only for the features that need height information."
  - q: "When should we use deep learning AI vision instead of traditional rule-based vision?"
    a: "Rule-based vision wins when the defect can be defined geometrically — an edge that should be straight, a hole that should be a known diameter, a feature that should be in a known location. Deep learning wins when the defect varies naturally from part to part and cannot be expressed as a fixed rule — cosmetic surface defects on textured materials, weave or grain irregularities, food product appearance, and complex anomaly classification. We deploy Cognex ViDi and Keyence AI modules trained on labeled images of your actual parts, often alongside traditional tools in the same station."
  - q: "How accurate are vision measurement systems compared to a CMM?"
    a: "Vision measurement systems typically achieve ±0.005 to ±0.025 mm repeatability with calibrated optics and telecentric lenses. That is below CMM accuracy, which reaches ±0.001 to ±0.003 mm, but it is more than sufficient for 100 percent inline process control. Vision measurements complete in milliseconds versus seconds or minutes for a CMM probe, so the typical pattern is vision inline on every part and a CMM offline for periodic correlation audits."
  - q: "How do you avoid false rejects on a vision inspection station?"
    a: "Most false rejects come from inconsistent lighting, marginal contrast, fixture compliance, or thresholds tuned on too few samples. We prototype lighting on your actual production parts before committing to a design, design enclosed light shrouds to eliminate ambient interference, use industrial LED controllers with regulated current for long-term stability, and tune thresholds against statistically meaningful sample sets. Gauge R&R is run against known-good and known-bad master parts before the station ships."
  - q: "What cycle time can a machine vision inspection station achieve?"
    a: "Smart-camera 2D inspections typically complete in 50 to 500 milliseconds per view, so a single-view station easily keeps up with lines running at 60 to 120 parts per minute. Multi-camera stations parallelize views to hold cycle time on complex parts. Line-scan cameras inspect continuously moving webs and parts at meters per second. When inspection time exceeds line takt on a complex part, we split views across a rotary or multi-station architecture so throughput matches the line."
  - q: "Can the vision station integrate with our MES and traceability database?"
    a: "Yes. Every AMD vision inspection station serializes each result with part ID, recipe, every measured feature, pass/fail status, operator, and timestamp, and can archive the raw image linked to the serial number. Data pushes over OPC UA, MQTT, Ethernet/IP, ODBC/SQL, or REST to Rockwell FactoryTalk, AVEVA Wonderware, Ignition, SAP, or a custom historian. For regulated environments we configure controlled access and audit-trail logging."
  - q: "Can we add a vision inspection station to an existing line?"
    a: "Usually yes. We retrofit standalone vision stations into existing conveyors, add cameras to existing robotic cells, or mount inspection over manual workstations. We survey line layout, conveyor height, lighting environment, takt time, and upstream and downstream handoffs, then engineer the frame, optics, and controls for minimum disruption. Many retrofits are installed during a planned shutdown weekend."
---

If you are evaluating **machine vision inspection stations** for your line, you are usually trying to solve one of three problems: defects escaping to the customer and driving PPM, manual inspectors who cannot keep up with takt or vary by shift, or the need for serialized image records on every part instead of sampled clipboards. We build the station around whichever is biting you hardest.

AMD Machines has designed custom [machine vision systems](/solutions/machine-vision/) and inspection stations for more than thirty years, with over 2,500 machines delivered. A vision inspection station from AMD is engineered around your part — its geometry, the defects you have to catch, the lighting environment, takt time, and reject criteria — and integrated with the controls and traceability your customers and auditors expect.

<figure class="app-figure" style="background-image:url('/static/images/applications/machine-vision-inspection-stations-1.webp')" role="img" aria-label="Machine vision inspection station with multi-camera array, controlled lighting, and pass/fail sorting"><figcaption>Multi-camera 2D vision station: enclosed lighting, calibrated optics, and serialized pass/fail sorting at the outfeed.</figcaption></figure>

## What is a machine vision inspection station?

A machine vision inspection station is a production machine that uses cameras, controlled lighting, and image-processing software to inspect every part at full line speed and route it to pass, reject, or rework. It replaces sampled manual visual inspection with deterministic, repeatable, 100 percent inspection — and a serialized data record on every unit.

- Detects presence, position, and orientation
- Measures dimensions, gaps, angles, and GD&T features
- Classifies surface defects (scratches, porosity, contamination, color)
- Reads barcodes, 2D codes, and OCR/OCV text
- Captures 3D profiles for height, flatness, and weld geometry

## How a machine vision inspection station works

1. **Part identification** — barcode, DataMatrix, or RFID at infeed loads the correct inspection recipe; no scan, no inspection.
2. **Present and trigger** — the part lands in a nest or passes under the camera; an encoder, photo-eye, or PLC strobes the capture trigger.
3. **Illuminate and capture** — pulsed LED lighting (dome, darkfield, backlight, coaxial, or structured) fires while the camera exposes; for high-speed motion, exposure runs under 100 µs to freeze the part.
4. **Process** — the vision controller runs the inspection recipe: pattern match, calipers, blob analysis, OCR, color tools, or a trained deep-learning model.
5. **Decide** — every measurement is graded against high/low limits; rule-based or AI logic returns pass, reject, or fault.
6. **Log and sort** — the serialized record (and optionally the image) pushes to MES in real time, and the diverter routes the part to the correct lane.
7. **Self-monitor** — automatic exposure and gain trim compensate for LED drift; a golden-image cycle at shift start confirms the station is still in control.

## Vision inspection methods compared

| Method | Best for | Typical specs | Notes |
|---|---|---|---|
| 2D smart-camera inspection | Single-view presence, dimensional, OCR, 1D/2D code read | ±0.01–0.05 mm; 50–500 ms cycle | Cognex In-Sight 2800/3800, Keyence CV-X — all-in-one IP67 |
| PC-based 2D vision | Multi-camera, high resolution, complex measurement | Sub-pixel edge ±0.005 mm | Cognex VisionPro, Keyence XG-X; GigE/CoaXPress area-scan |
| Line-scan vision | Continuous webs, cylinders, long parts at high speed | >2 m/s, no parallax stitching | Teledyne DALSA Linea, Basler racer; 4K–16K pixels wide |
| 3D laser triangulation | Weld bead, gap-and-flush, surface profile, height | µm-level Z resolution | Keyence LJ-X8000, Cognex DSMax/DS1300 |
| Structured-light 3D | Freeform surfaces, dense point clouds on cast/machined parts | Sub-mm point spacing | Stereo projection systems for full-surface scans |
| Time-of-flight / stereo 3D | Robot guidance, large-object localization, [bin picking](/solutions/bin-picking/) | mm-level XYZ | FANUC 3DV/600, Keyence 3D-LJV, ifm O3D |
| Deep learning (AI) vision | Cosmetic defects, textured surfaces, variable anomalies | 95–99%+ classification | Cognex ViDi, Keyence AI; 50–200 labeled images to train |
| OCR / OCV + code reading | Lot codes, date codes, DataMatrix, label verification | 99.5%+ read rate | Cognex DataMan, Keyence SR-X; verifies against batch recipe |

<div class="app-callout">Lighting and optics determine roughly 80 percent of a vision system's success — not the camera spec. We prototype lighting on your actual production parts, in production lot variation, before locking the design.</div>

## Key components and technologies

- **Vision controllers and smart cameras** — Cognex In-Sight 2800/3800, VisionPro, ViDi; Keyence CV-X, XG-X, AI series
- **Area-scan and line-scan cameras** — Basler ace and racer, FLIR Blackfly, Teledyne DALSA Genie/Linea
- **3D sensors** — Keyence LJ-X8000 series, Cognex DSMax, FANUC 3DV/600 for robot guidance
- **Industrial lighting** — Smart Vision Lights, Advanced Illumination, CCS, Effilux; dome, darkfield, backlight, coaxial, structured
- **Optics** — Computar, Edmund Optics, Schneider telecentric lenses; polarizers, filters, beam-splitters as needed
- **Controls and HMI** — Allen-Bradley CompactLogix/ControlLogix or Siemens S7-1500 with FactoryTalk View or WinCC
- **Networking and I/O** — Ethernet/IP, PROFINET, OPC UA bridges to PLC, MES, and image archive

| Subsystem | Typical hardware |
|---|---|
| Smart camera / vision controller | Cognex In-Sight, Keyence CV-X / XG-X |
| Area-scan camera | Basler, FLIR, Teledyne DALSA |
| 3D profiler | Keyence LJ-X8000, Cognex DSMax |
| Lighting | Smart Vision Lights, CCS, Advanced Illumination |
| PLC / motion | Allen-Bradley, Siemens, Beckhoff |

<figure class="app-figure" style="background-image:url('/static/images/applications/machine-vision-inspection-stations-2.webp')" role="img" aria-label="3D laser profiler inspecting a weld bead on a robotic welding cell for height, width, and porosity"><figcaption>3D laser profiler in a robotic cell: scans every weld for bead width, height, undercut, and porosity at line speed.</figcaption></figure>

## Integration, controls, and traceability

A green light on a vision controller is not a quality record. Every AMD machine vision inspection station ships with the data the floor and the audit need:

- **Per-part serialized records** — part ID, recipe, every measured feature, pass/fail, operator, timestamp
- **Image archive** — pass/reject images linked to the serial number for engineering review and customer escapes
- **MES integration** — OPC UA, MQTT, Ethernet/IP, ODBC/SQL, or REST push to FactoryTalk, AVEVA, Ignition, SAP, or a custom historian
- **Recipe management** — barcode-driven setup loads cameras, tools, limits, and lighting per part variant in under 100 ms
- **SPC and audit reporting** — X-bar/R, Cpk, trend alarms, and exportable test reports for [process optimization](/services/process-optimization/) reviews

## Industries we serve

- [**Automotive**](/industries/automotive/) — machined castings, sealing surfaces, fasteners, EV battery and motor components
- [**Electronics**](/industries/electronics/) — PCBA AOI, connector verification, label and code reading
- [**Aerospace and defense**](/industries/aerospace/) — dimensional verification and surface inspection held to FAI and PPAP
- [**Appliances**](/industries/appliances/) and [**consumer products**](/industries/consumer/) — cosmetic surface inspection, color, assembly verification
- [**Food and beverage**](/industries/food-beverage/) — fill level, cap presence, label and date-code verification

<figure class="app-figure" style="background-image:url('/static/images/applications/machine-vision-inspection-stations-3.webp')" role="img" aria-label="Vision-guided robotic cell using a Cognex camera to locate and pick parts from a conveyor"><figcaption>Vision-guided robotic cell: a calibrated 2D camera locates parts on a conveyor and feeds pick coordinates to the robot controller.</figcaption></figure>

## Why AMD Machines

We are not a camera reseller bolting a Cognex unit to a frame. We engineer the entire inspection station in-house — mechanical, optical, lighting, controls, vision algorithms, and data — against your part, your defects, and your line:

- 30+ years of custom automation and 2,500+ machines delivered
- Lighting and optics prototyped on your production parts before design lock
- Traditional rule-based and deep-learning AI tools deployed side-by-side, sized to the actual defect
- One supplier for the [assembly automation](/solutions/assembly/), [robotic cells](/solutions/robotic-cells/), and [marking and traceability](/applications/part-marking-traceability-systems/) the inspection station integrates with

Have a part, a list of defects to catch, and a takt time? That's enough to start. [Request a quote](/contact/) or send us sample parts and we'll prototype the inspection around them.
