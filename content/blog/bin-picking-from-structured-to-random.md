---
title: 'Bin Picking: From Structured to Random'
description: This topic represents an important consideration for manufacturers seeking
  to improve their operations through automation. Understanding the fundamentals.
keywords: industrial automation, manufacturing automation, AMD Machines, material
  handling automation, conveyor systems, palletizing, picking, structured, random
date: '2025-07-16'
author: AMD Machines Team
category: Assembly
read_time: 7
template: blog-post.html
url: /blog/bin-picking-from-structured-to-random/
---

## The Spectrum of Bin Picking Complexity

Bin picking is one of those automation challenges that sounds straightforward until you actually try to implement it. A robot reaches into a container, grabs a part, and places it somewhere useful. Simple enough in concept. In practice, the difficulty spans an enormous range — from trivially easy structured picks to genuinely hard random bin picking that has only become reliable in the last few years.

Understanding where your application falls on this spectrum is the single most important decision you will make when designing a [bin picking system](/solutions/bin-picking/). Get it wrong and you either overspend on technology you do not need or underspend and end up with a system that jams, drops parts, or never hits rate.

## Structured Bin Picking: The Starting Point

Structured bin picking means parts arrive in a known orientation inside an organized container. Think trays with individual cavities, dunnage with formed pockets, or magazines that present one part at a time. The robot knows exactly where each part is before it moves because the container geometry constrains the part location.

This is the simplest form of automated picking and it has been done successfully for decades. A basic 6-axis robot with a fixed gripper and no vision system at all can handle structured picks. You teach the robot the coordinates of each pocket in the tray, add a tray counter, and cycle. Pick rates are fast because there is zero processing time — the robot simply executes its taught path.

The tradeoff is upstream labor. Someone has to load parts into those structured containers in the first place. If you are receiving parts from a supplier in organized dunnage, you get structured picking essentially for free. If your upstream process dumps parts into a bulk container and you are adding a manual re-racking step just to enable robot picking, you have not eliminated labor — you have moved it.

Structured picking makes sense when the upstream process naturally produces organized parts, when cycle time requirements are extremely tight, or when the parts themselves are too challenging for vision-based approaches due to surface finish or geometry.

## Semi-Structured Picking: The Practical Middle Ground

Semi-structured picking covers the large territory between perfectly organized trays and complete chaos. Parts might be loosely arranged in a single layer but with some variation in position and orientation. They might be stacked two or three deep with some overlap. They might be in a container with dividers that constrain lateral movement but allow rotational variation.

This is where [machine vision](/solutions/machine-vision/) enters the picture. A 2D camera mounted above the bin can locate parts that vary in X, Y, and rotation within a plane. For single-layer applications with good contrast between parts and background, a standard 2D vision system with pattern matching works reliably and runs fast — often under 200 milliseconds per acquisition.

The key advantage of semi-structured picking is that it relaxes the upstream packaging requirements without requiring the full complexity of 3D random bin picking. If your supplier can toss parts into a flat tray instead of carefully loading individual pockets, you save significant handling time while keeping the vision and robot programming relatively straightforward.

Many manufacturers find that semi-structured picking handles 70 to 80 percent of their applications. The parts that seem like they need random bin picking can often be presented in a semi-structured way with minor changes to how they are loaded or conveyed. Before investing in a full 3D random picking system, it is worth asking whether a simple mechanical pre-orientation step — a vibratory feeder, a step feeder, or even a slight modification to the shipping container — can convert a random problem into a semi-structured one.

## Random Bin Picking: The Full Challenge

True random bin picking means parts are jumbled in a container in arbitrary positions and orientations, potentially interlocked, stacked at various angles, and partially occluded by neighboring parts. This is what most people picture when they hear "bin picking," and it is genuinely difficult.

The technology required for reliable random bin picking has three main components: 3D sensing, intelligent path planning, and adaptive gripping.

### 3D Vision Systems

Random bin picking demands 3D point cloud data, not just 2D images. The dominant sensor technologies include structured light projection, laser triangulation, and time-of-flight cameras. Each has tradeoffs in speed, accuracy, and robustness to ambient light.

Structured light systems project a known pattern onto the scene and calculate depth from the pattern distortion. They deliver high accuracy and dense point clouds but can struggle with shiny or transparent parts and are sensitive to ambient infrared. Laser triangulation scans a line across the scene and builds the 3D model progressively — accurate and robust but slower for large fields of view. Time-of-flight cameras measure the round-trip time of emitted light pulses and return depth data for every pixel simultaneously, making them fast but typically lower resolution.

The choice of sensor depends on part size, surface characteristics, required accuracy, and cycle time. For automotive stampings with matte finishes in well-lit factory environments, structured light works well. For small polished machined components, you may need to apply surface treatments or use a different sensing modality altogether.

### Path Planning and Collision Avoidance

Knowing where a part is located in 3D space is only half the problem. The robot still needs to reach into a bin full of parts, grasp the target piece, and extract it without colliding with neighboring parts or the bin walls. This requires real-time path planning with collision avoidance — the robot must plan a unique extraction path for every single pick.

Modern bin picking software generates these paths automatically using the 3D scene model combined with the known geometry of the gripper, robot, and bin. The software identifies which parts are accessible (typically those on top of the pile), selects the best candidate based on grasp quality and reachability, plans the approach and retreat paths, and verifies the plan is collision-free before executing.

When a planned path is not collision-free, the software either selects a different target part or attempts an alternative grasp orientation. Cycle time increases when parts are tightly packed or interlocked because the system may need to evaluate several candidates before finding a viable pick.

### Gripper Design

The gripper is often the limiting factor in random bin picking. A well-chosen gripper can make a difficult application straightforward, while a poorly matched gripper can make an easy application fail.

Magnetic grippers work well for ferrous parts with flat surfaces — they tolerate variation in part orientation and can pick through gaps between stacked parts. Vacuum grippers need a reasonably flat surface to seal against, which limits their effectiveness on complex geometries but makes them excellent for sheet-like parts. Mechanical fingers offer the most flexibility but require more complex control and can struggle to access parts deep in a bin.

Many successful random bin picking cells use hybrid grippers that combine two or more technologies. A common combination is a magnetic gripper for the primary pick with a mechanical finger assist for separating interlocked parts.

## Practical Considerations for Implementation

### Cycle Time Reality

Structured picking runs at 6 to 10 seconds per pick routinely. Semi-structured picking with 2D vision adds perhaps 1 to 2 seconds for image acquisition and processing, landing at 8 to 12 seconds. Random bin picking with 3D sensing, path planning, and potential re-picks typically runs 12 to 20 seconds per cycle, with occasional outliers when parts are heavily interlocked.

If your takt time requires picks faster than 12 seconds, random bin picking may not be the right answer without running multiple [robotic cells](/solutions/robotic-cells/) in parallel or implementing upstream changes to reduce the randomness.

### Part Geometry Matters

Not all parts are equally suited to random bin picking. The ideal candidate is a rigid part with distinct geometric features for vision recognition, surfaces suitable for gripping, and a shape that does not tangle or interlock with neighboring parts. Springs, wire forms, flexible tubes, and thin flat stampings that stack and nest tightly are all challenging because they interlock in ways that resist single-part extraction.

### Bin Design

The bin itself significantly affects picking success. Deep bins create reachability problems — the robot may not be able to access parts at the bottom without a long, narrow gripper that limits payload. Wide shallow bins maximize accessibility but take up more floor space. Bins with sloped walls help parts settle toward the center where they are easiest to reach.

### The Last Part Problem

Every random bin picking system struggles with the last few parts in a bin. As the bin empties, remaining parts spread out and settle into corners and edges where the robot has limited reach and the vision system has poor viewing angles. Common solutions include tilting the bin as it empties, using a secondary mechanism to consolidate remaining parts toward the center, or simply accepting that the last 5 to 10 percent of parts require manual intervention and designing the cell accordingly.

## Choosing the Right Approach

The decision between structured, semi-structured, and random bin picking is ultimately an economic one. Calculate the total cost of each approach — including not just the automation equipment but also the upstream packaging, floor space, maintenance, and any remaining manual labor — and compare it against the throughput and quality requirements.

Start simple. If a structured approach works for your application, use it. If you need vision, start with 2D semi-structured picking and only move to full 3D random picking when the application genuinely demands it. The most reliable automation system is always the simplest one that meets the requirements.

## Partner With AMD Machines

AMD Machines has designed and built bin picking systems across the full complexity spectrum, from simple structured pick-and-place cells to advanced 3D random bin picking installations. Our engineers evaluate your parts, volumes, and upstream processes to recommend the right level of technology for your application — not the most impressive, but the most effective. [Contact us](/contact/) to discuss your bin picking requirements.
