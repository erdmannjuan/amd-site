---
title: Dimensional Inspection with CMMs and Vision
description: Quality assurance through automated testing and inspection has become
  essential for manufacturers facing demanding specifications and cost pressures..
keywords: industrial automation, manufacturing automation, AMD Machines, automated
  testing, quality inspection, test systems, dimensional, inspection, vision
date: '2025-10-16'
author: AMD Machines Team
category: Vision & QC
read_time: 8
template: blog-post.html
url: /blog/dimensional-inspection-with-cmms-and-vision/
---

## Why Dimensional Inspection Matters

Every manufactured part has dimensions that must fall within specified tolerances for the product to function correctly. A bore that is 0.05 mm too small will not accept its mating shaft. A gasket groove that is 0.1 mm too shallow will leak. A bracket mounting hole that is 0.5 mm out of position will not align with its fastener.

Dimensional inspection verifies that parts meet their geometric specifications. The two dominant technologies for automated dimensional inspection are **coordinate measuring machines (CMMs)** and **machine vision systems**. Each has distinct strengths, limitations, and ideal applications. Choosing the right technology — or the right combination — is critical to building an effective quality system.

## Coordinate Measuring Machines (CMMs)

A CMM measures the physical geometry of a part by moving a probe across its surface and recording 3D coordinates at each contact point. These coordinates are then compared against the nominal CAD model to determine dimensional accuracy.

### Types of CMMs

- **Bridge CMM**: The most common type. A horizontal bridge moves along the Y-axis while the probe moves along X and Z. Typical accuracy: ±1.5 to ±3.0 µm. Best for medium-sized parts in a climate-controlled lab.
- **Gantry CMM**: A large-scale version of the bridge design for measuring large parts like automotive body panels, aircraft components, or castings. Working volumes up to 5m × 10m × 3m.
- **Horizontal arm CMM**: The probe is mounted on a horizontal arm that extends from a vertical column. Used for large, heavy parts like engine blocks or transmission housings. Slightly lower accuracy than bridge types.
- **Portable arm CMM**: A manually operated articulating arm with 6 or 7 axes of freedom. Taken to the part rather than the part to the machine. Accuracy: ±25 to ±75 µm. Used for on-machine verification and large fabricated structures.

### How They Work

**Touch-trigger probing**: The probe contacts the surface at discrete points. Each touch records a single XYZ coordinate. Measurements are built from collections of points — three points define a plane, four points define a circle, and so on. Slower but reliable and well-understood.

**Continuous scanning**: The probe maintains constant contact and continuously streams coordinate data as it sweeps across the surface. Captures thousands of points per second. Provides much more complete surface data, which is essential for form measurements like roundness and cylindricity.

### GD&T Measurements

CMMs excel at measuring geometric dimensioning and tolerancing (GD&T) characteristics:

- **Flatness**: How close a surface is to a perfect plane
- **Perpendicularity**: How close a surface or axis is to 90° relative to a datum
- **Position**: Location of a feature (hole, slot, boss) relative to datums
- **Runout**: How much a surface deviates from a perfect axis of rotation
- **Concentricity**: How well two cylindrical features share a common axis
- **Profile of a surface**: How closely a complex surface matches its nominal shape

### Pros and Cons

**Strengths**:
- Accuracy: ±1-3 µm for lab-grade bridge CMMs
- Can measure complex 3D geometry including internal features (bores, channels)
- Full GD&T capability
- Well-established measurement uncertainty methods (ISO 10360)
- Accepted as reference measurement by most industries

**Limitations**:
- Slow: A typical first-article inspection can take 30-60 minutes per part
- Requires climate-controlled environment (20°C ±1°C) for highest accuracy
- Contact measurement can mark soft surfaces
- Expensive: $100K-$500K+ for lab-grade systems
- Requires skilled programmers and operators

**Best for**: First article inspection, complex parts with tight tolerances, GD&T compliance, supplier qualification, root cause analysis of dimensional issues.

## Machine Vision Systems

Machine vision uses cameras, lenses, lighting, and software to capture and analyze images of parts. Vision systems measure by extracting dimensional information from images rather than physical contact.

### Components

- **Cameras**: Area scan (capture full frame) or line scan (capture one row at a time as the part moves past). Resolution ranges from VGA (640×480) to 25+ megapixels.
- **Lenses**: Telecentric lenses eliminate perspective distortion and are preferred for precision measurement. Standard lenses are used when perspective error is acceptable.
- **Lighting**: The most critical and underestimated component. Backlighting for edge measurement, ring lights for surface inspection, structured light for 3D measurement. Lighting design makes or breaks a vision application.
- **Software**: Pattern matching, edge detection, blob analysis, OCR, and dimensional measurement algorithms. Modern systems include deep learning for defect classification.

### 2D Vision Measurement

2D vision works with a single camera looking at the part from one direction. It excels at:

- **Edge detection**: Measuring lengths, widths, diameters, and positions of features visible in the camera's field of view
- **Pattern matching**: Locating parts and features regardless of position or orientation
- **Presence/absence verification**: Confirming that components, labels, fasteners, or seals are present
- **OCR and barcode reading**: Reading date codes, serial numbers, and barcodes for traceability

**Accuracy**: Depends on field of view and camera resolution. A typical high-resolution setup achieves ±0.01 to ±0.05 mm.

### 3D Vision Measurement

3D vision captures height information in addition to XY position:

- **Structured light**: Projects a pattern (stripes, dots, or grids) onto the part surface. The distortion of the pattern reveals the surface shape. Accuracy: ±0.01 to ±0.1 mm depending on field of view.
- **Stereo vision**: Two cameras view the part from different angles. Triangulation calculates depth for each point. Used for bin picking and coarse dimensional verification.
- **Laser triangulation**: A laser line projected onto the surface is viewed by a camera at an angle. The displacement of the line reveals the surface profile. Excellent for inline measurement of height, step, gap, and flush.

### Pros and Cons

**Strengths**:
- Fast: Captures and analyzes an image in milliseconds. Enables 100% inline inspection at production speed.
- Non-contact: No risk of marking or damaging parts
- Flexible: A single camera system can measure multiple features simultaneously
- Generates images that can be archived for traceability and root cause analysis
- Cost-effective at high volumes: $10K-$100K per station

**Limitations**:
- Accuracy limited by field of view — larger FOV means lower accuracy
- Sensitive to lighting conditions, surface reflectivity, and contamination
- Limited 3D capability compared to CMMs
- Cannot measure internal features (bores, channels) without line-of-sight
- Setup and validation require vision engineering expertise

**Best for**: High-volume production, 100% inline inspection, presence/absence verification, position and orientation measurement, surface defect detection.

## CMM vs Vision: Decision Guide

| Factor | CMM | Vision |
|---|---|---|
| **Accuracy** | ±1-3 µm (lab), ±5-10 µm (shop floor) | ±10-100 µm typical |
| **Speed** | 30-60 min per part (first article) | Milliseconds per inspection |
| **Throughput** | Sample inspection only | 100% inline capable |
| **3D capability** | Full 3D including internal features | Surface only (without special fixturing) |
| **GD&T** | Full GD&T compliance | Limited (2D features, basic 3D) |
| **Environment** | Climate-controlled lab preferred | Shop floor compatible |
| **Contact** | Contact (may mark surfaces) | Non-contact |
| **Part size** | mm to meters (depends on CMM type) | Limited by camera FOV |
| **Operator skill** | High (programming, operation) | Low (after setup) |
| **Cost per measurement** | High (labor-intensive) | Low (automated) |
| **Investment** | $100K-$500K+ | $10K-$100K per station |

### When to Use a CMM

- First article inspection and supplier qualification
- Complex GD&T measurements (true position, profile, runout)
- Tight tolerances below ±0.01 mm
- Low-volume or job-shop production
- Root cause dimensional analysis

### When to Use Vision

- High-volume production requiring 100% inspection
- Go/no-go dimensional checks at production speed
- Presence/absence verification
- Surface defect detection
- Part identification and traceability (OCR, barcodes)

### When to Use Both

Many manufacturers use both technologies in a complementary strategy: CMMs for first article inspection, process setup, and periodic audits; vision systems for 100% inline inspection during production. The CMM validates the process, and the vision system monitors it.

## Integrating Inspection Into Automated Production

When inspection is part of an automated assembly or machining line, consider:

- **Inspection station placement**: Position inspection after critical operations so defects are caught before additional value is added
- **Part handling**: Use robots, conveyors, or indexing systems to present parts to the inspection system in a repeatable orientation
- **Reject handling**: Design automated reject mechanisms (diverters, reject bins) to remove non-conforming parts without stopping the line
- **Data integration**: Connect inspection results to your MES or quality database for SPC, traceability, and trend analysis
- **Calibration and maintenance**: Schedule regular calibration cycles. Vision systems need periodic lighting and lens cleaning. CMMs need annual calibration per ISO 10360.

## How AMD Machines Builds Inspection Systems

AMD Machines integrates both CMM and vision technologies into automated production systems. Our capabilities include:

- **Inline vision inspection stations** with 2D and 3D measurement for high-volume production
- **Automated CMM loading** with robotic part handling for unattended measurement
- **Multi-camera inspection cells** that measure multiple features simultaneously
- **Vision-guided robotics** that combine measurement with robotic handling for adaptive assembly
- **Complete data integration** connecting inspection results to plant quality systems

We help our customers determine the right inspection technology for their application, design the system, and validate measurement capability before production begins.

## Partner With AMD Machines

AMD Machines brings decades of experience to every project. Our engineers understand the challenges manufacturers face and deliver solutions that work in the real world. [Contact us](/contact/) to discuss your automation needs.
