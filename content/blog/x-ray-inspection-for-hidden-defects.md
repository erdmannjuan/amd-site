---
title: X-Ray Inspection for Hidden Defects
description: Technical guide to industrial X-ray and CT inspection for detecting hidden
  defects in solder joints, castings, welds, and assembled products in automated manufacturing.
keywords: X-ray inspection, CT inspection, industrial radiography, solder joint inspection,
  casting defects, weld inspection, automated X-ray, non-destructive testing, NDT
date: '2025-10-04'
author: AMD Machines Team
category: Vision & QC
read_time: 8
template: blog-post.html
url: /blog/x-ray-inspection-for-hidden-defects/
---

## Why X-Ray Inspection Exists in Manufacturing

Some defects cannot be found by looking at the outside of a part. A solder joint on a BGA package may appear perfect from above while hiding voids that compromise electrical and thermal performance. A cast aluminum housing may have internal porosity that weakens the structure under load. A welded joint may contain lack-of-fusion defects buried within the weld cross-section.

For these hidden defects, X-ray inspection is the primary non-destructive method that lets manufacturers see inside their products without cutting them apart. As manufacturing tolerances tighten and quality requirements grow more demanding — particularly in automotive, aerospace, medical device, and electronics manufacturing — X-ray inspection has moved from a sampling-based laboratory technique to an inline automated process running at production speed.

## How Industrial X-Ray Inspection Works

The basic principle is straightforward. An X-ray source emits radiation that passes through the object being inspected. Denser materials absorb more radiation than less dense materials. A detector on the opposite side of the object captures the transmitted radiation and creates an image where density variations appear as contrast differences.

Voids, cracks, inclusions, and porosity show up because they have different density than the surrounding material. A void in a solder joint appears darker than the surrounding solder. A tungsten inclusion in an aluminum weld appears brighter because tungsten is denser than aluminum.

### 2D Radiography vs. Computed Tomography

Traditional 2D X-ray inspection produces a flat projection image — similar to a medical chest X-ray. This works well for many applications but has a fundamental limitation: features at different depths within the part are superimposed on each other in the image, making it difficult to determine the exact location and size of a defect.

Computed tomography (CT) solves this by taking hundreds or thousands of 2D projections at different angles as the part rotates, then mathematically reconstructing a full 3D volumetric model. CT allows you to slice through the part in any plane, measure internal dimensions, and precisely characterize defects in three dimensions.

The tradeoff is time and cost. A 2D X-ray image can be captured in seconds. A full CT scan might take several minutes to tens of minutes depending on resolution requirements, part size, and the number of projections. For inline production inspection, 2D radiography remains the dominant approach. CT is more commonly used for first-article inspection, failure analysis, and sampling-based quality programs.

## Key Applications in Manufacturing

### Solder Joint Inspection in Electronics

X-ray inspection is essential for modern electronics assemblies using BGA (ball grid array), QFN (quad flat no-lead), and other bottom-terminated component packages. These components have solder connections underneath the package body where optical or camera-based inspection cannot see them.

Common defects detectable by X-ray include:

- **Solder voids** — gas pockets within the solder joint that reduce mechanical strength and thermal conductivity. Most specifications limit void area to 25-50% of the pad area, though critical applications in automotive and aerospace may be more restrictive.
- **Bridging** — unintended solder connections between adjacent pads or balls that create short circuits.
- **Head-in-pillow defects** — a condition where the solder ball partially melts and contacts the pad but does not fully wet, creating a visually acceptable but electrically unreliable joint.
- **Missing or misaligned balls** — absent or shifted solder connections that leave open circuits.

Automated X-ray inspection (AXI) systems for electronics can inspect assemblies at rates compatible with SMT production lines, typically processing one board every 30-90 seconds depending on the number of inspection regions and the image analysis required.

### Casting Inspection

Cast metal components — aluminum die castings, iron sand castings, investment castings — are prone to internal defects that result from the solidification process. Shrinkage porosity, gas porosity, hot tears, and inclusions can all occur within the casting where they are invisible from the surface.

X-ray inspection of castings is well-established, with ASTM E505 (for aluminum and magnesium) and ASTM E186/E446 (for steel) providing reference radiograph standards that define acceptable defect levels by severity grade. Automated systems compare inspection images against these standards using image analysis algorithms, reducing the subjectivity inherent in manual radiograph interpretation.

For structural castings in automotive and aerospace applications — suspension knuckles, engine blocks, turbine housings — X-ray inspection is often a mandatory requirement in the part qualification process.

### Weld Inspection

Radiographic inspection of welds reveals internal discontinuities that surface-only methods like visual inspection or dye penetrant testing cannot detect. Lack of fusion, incomplete penetration, slag inclusions, and internal porosity all show up clearly in radiographic images.

Industrial radiography of welds has traditionally been performed using film-based methods, but digital radiography (DR) using flat-panel detectors has largely replaced film in production environments. DR offers immediate image availability, better dynamic range, lower operating cost (no film or chemical processing), and easier integration with automated inspection and data management systems.

For a broader overview of weld quality methods including surface techniques, see our guide on [weld inspection methods](/blog/weld-inspection-methods-visual-ut-and-radiographic/).

## X-Ray System Components and Selection

An automated X-ray inspection system consists of several key subsystems, and understanding each helps with specification and selection.

### X-Ray Source

The X-ray tube generates the radiation. Key parameters include:

- **Voltage (kV)** — determines penetration capability. Higher voltage penetrates thicker or denser materials. Electronics inspection typically uses 60-130 kV. Casting inspection may require 150-320 kV or higher.
- **Focal spot size** — determines image resolution. Smaller focal spots produce sharper images but have lower power output. Microfocus tubes with spot sizes under 10 micrometers are used for high-resolution electronics inspection. Standard focus tubes with larger spots are adequate for casting and weld inspection.
- **Target material** — tungsten is most common. Some specialized applications use molybdenum or other target materials for specific energy spectrum characteristics.

### Detector

Flat-panel detectors using amorphous silicon with a scintillator layer are the current standard for most industrial X-ray systems. Key specifications include pixel size (which affects resolution), active area (which determines the field of view), and dynamic range (which affects the ability to image features across a range of material thicknesses in a single exposure).

Image intensifier tubes are still used in some older systems and in applications requiring real-time imaging at high frame rates, but flat-panel detectors have largely superseded them for new installations.

### Manipulation System

The part must be positioned between the source and detector, and in many cases rotated or translated to inspect multiple regions or angles. For CT scanning, the manipulation system must provide precise, smooth rotation. For 2D inspection of large or complex assemblies, multi-axis manipulation allows the system to image specific regions of interest at optimal viewing angles.

### Image Analysis Software

Modern X-ray inspection systems use automated image analysis to detect and classify defects without operator interpretation. For electronics, algorithms measure void percentage, detect bridging, and verify ball presence and position. For castings, algorithms compare images against reference standards and flag regions exceeding acceptance criteria.

The quality of the image analysis software is often more important than the hardware specifications in determining overall system performance. Poorly tuned algorithms produce either excessive false rejects (reducing throughput and increasing costs) or missed defects (defeating the purpose of inspection).

## Radiation Safety

X-ray inspection equipment produces ionizing radiation, and proper shielding and safety controls are non-negotiable. Cabinet-style systems enclose the X-ray source, part, and detector within a lead-lined enclosure with safety interlocks that prevent X-ray generation when any access door is open. These systems are typically classified as "cabinet X-ray systems" under 21 CFR 1020.40 and, when properly designed and maintained, present no radiation hazard to operators.

Open-beam systems used for large parts or field inspection require additional controls: restricted access areas, dosimetry monitoring for personnel, and trained radiation safety officers. Regulatory requirements vary by jurisdiction but generally follow standards from organizations like the NRC and state radiation control programs.

For any X-ray inspection installation, involve your radiation safety officer early in the planning process. Shielding calculations, room design, and regulatory filings take time and should not be afterthoughts.

## Integration with Automated Production

Integrating X-ray inspection into an automated production line requires careful consideration of cycle time, material handling, and data flow.

Cycle time is the primary constraint. If the production line runs at 30-second takt time and the X-ray system needs 60 seconds per part, you either need two inspection stations in parallel or you need to limit inspection to a statistical sample. For electronics, modern AXI systems are fast enough for 100% inline inspection of most board designs. For casting inspection, the longer exposure times often necessitate offline batch inspection or sampling.

Material handling integration includes loading and unloading the part from the inspection station, positioning it correctly for imaging, and routing it to the appropriate downstream path based on pass/fail results. Reject handling — what happens to a part that fails inspection — needs to be defined clearly, including quarantine procedures and disposition authority.

Data integration with your [statistical process control](/blog/statistical-process-control-in-automated-testing/) system allows X-ray inspection results to feed back into process monitoring. Trending void percentages in solder joints over time, for example, can reveal reflow oven profile drift before it causes outright failures. This transforms X-ray inspection from a simple accept/reject gate into a process monitoring tool.

## Practical Considerations for Implementation

Before investing in X-ray inspection capability, consider these practical factors:

**Define what you are looking for.** X-ray inspection is powerful but not omniscient. You need to know the specific defect types, sizes, and locations you expect to find. This drives the system specification — voltage, focal spot size, detector resolution, and viewing geometry all depend on the inspection requirements.

**Establish acceptance criteria before buying equipment.** What constitutes an acceptable part and what does not? Reference standards, customer specifications, and industry standards should define this before the system is installed. Calibrating the image analysis algorithms requires clear, unambiguous acceptance criteria.

**Plan for ongoing operation.** X-ray tubes have finite lifetimes, typically 2,000-10,000 hours depending on type and operating conditions. Replacement tubes are expensive. Factor tube replacement costs and lead times into your maintenance planning and [spare parts strategy](/blog/spare-parts-strategy-for-automation-equipment/).

**Train your team.** Even with automated image analysis, operators need to understand the basics of radiographic interpretation to verify system performance, handle borderline cases, and troubleshoot image quality issues. Level I and Level II NDT certification per ASNT SNT-TC-1A provides a structured training framework.

## When X-Ray Inspection Is Worth the Investment

X-ray inspection is not appropriate for every manufacturing application. It adds cost, complexity, and cycle time. But for products where hidden defects pose safety, reliability, or warranty risks — and where those defects cannot be detected by other means — X-ray inspection provides objective evidence of internal quality that no other non-destructive method can match.

The decision comes down to risk. If a hidden defect in your product could cause a field failure, a safety incident, or a costly recall, the investment in X-ray inspection capability is straightforward to justify.

AMD Machines integrates automated inspection systems — including X-ray and vision-based solutions — into production lines across multiple industries. [Contact us](/contact/) to discuss how automated inspection fits into your quality assurance strategy.
