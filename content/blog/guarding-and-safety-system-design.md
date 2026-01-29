---
title: Guarding and Safety System Design
description: A practical guide to designing machine guarding and safety systems for automated
  manufacturing cells, covering risk assessment, safety device selection, and integration best practices.
keywords: machine guarding, safety system design, risk assessment, safety PLCs, light
  curtains, safety interlocks, automated cell safety, ANSI RIA, OSHA compliance
date: '2025-02-16'
author: AMD Machines Team
category: Guides
read_time: 8
template: blog-post.html
url: /blog/guarding-and-safety-system-design/
---

## Why Guarding and Safety System Design Deserves Serious Engineering Attention

Walk into any manufacturing facility that runs automated equipment, and the first thing you should notice is the guarding. Not because it is flashy or impressive—but because when it is done right, it blends into the cell so naturally that operators barely think about it. That seamless integration is the result of deliberate engineering, not afterthought.

Too many projects treat safety as a bolt-on, something handled after the mechanical and electrical design is locked down. That approach leads to awkward guard placements that slow changeovers, nuisance trips that erode operator trust, and worst of all, workarounds that defeat the purpose entirely. If the guarding frustrates people enough, someone will zip-tie a light curtain bypass, and now you have a liability wrapped in a false sense of security.

The better path is to design guarding and safety systems in parallel with the rest of the cell from the very beginning. This guide covers the practical engineering decisions that go into getting it right.

## Start With a Risk Assessment—Every Time

Before selecting a single guard panel or safety relay, you need a formal risk assessment. The relevant standards—ANSI/RIA 15.06 for robotic cells and ANSI B11.0 for general machine safety—lay out a structured process, but the core idea is straightforward: identify every hazard, evaluate the severity and likelihood of harm, and determine what risk reduction measures are required.

A proper risk assessment covers:

- **Hazard identification** – Pinch points, crush zones, flying debris, electrical exposure, thermal hazards, chemical splash, and anything else that could injure someone during normal operation, maintenance, or fault conditions.
- **Severity rating** – What is the worst credible injury? A bruise is different from an amputation, and the required protection level scales accordingly.
- **Exposure frequency** – How often does someone need to enter the hazard zone? A cell that runs untended for eight hours has a fundamentally different risk profile than one where an operator loads parts every 30 seconds.
- **Avoidance probability** – Can a person realistically see the hazard coming and get out of the way? A slow hydraulic press is very different from a robot arm moving at full speed.

Document everything. The risk assessment is not just a design input—it is a legal record that demonstrates due diligence. If OSHA shows up after an incident, the first thing they will ask for is your risk assessment documentation.

## Choosing the Right Guarding Strategy

Once you understand the hazards, you can match guarding methods to the specific risks. There is no one-size-fits-all answer, and most cells use a combination of approaches.

### Hard Guarding

Physical barriers—steel panels, polycarbonate shields, fencing—remain the most reliable form of protection. They do not need power, they do not have software bugs, and they do not degrade over time the way electronic devices can. For areas where operators never need access during normal production, hard guarding is the default choice.

Key design considerations for hard guards:

- **Opening size vs. reach distance** – ANSI/RIA 15.06 provides tables specifying the maximum opening size allowed at various distances from the hazard. A guard with finger-sized openings two inches from a pinch point is not acceptable.
- **Structural integrity** – Guards must withstand foreseeable impacts. If a part could eject from a fixture, the guard needs to stop it without deforming into the operator's space.
- **Visibility** – Operators need to see the process. Polycarbonate panels or mesh guards with appropriate opening sizes let operators monitor the cell without compromising protection.
- **Maintenance access** – Every guard panel that needs to be removed for maintenance should be secured with captive fasteners or interlocked doors, not loose bolts that get lost and never reinstalled.

### Safety-Rated Devices

Where operators need regular access—load/unload stations, inspection points, maintenance zones—you need active safety devices tied to the cell's safety circuit.

**Light curtains** are the workhorse for operator access points. They provide presence-sensing across an opening without physical barriers, which is invaluable for manual load stations where operators reach in and out hundreds of times per shift. Specify the right resolution for the hazard: 14mm finger detection for close-proximity hazards, 30mm hand detection for most load/unload applications, and body detection (greater than 40mm) for area access.

**Safety interlock switches** go on every access door and gate. Tongue-style interlocks are standard for hinged doors, while coded magnetic switches work well for sliding panels. For doors that guard against high-inertia hazards—think large presses or high-speed spindles—you need guard locking interlocks that keep the door physically locked until the hazard has stopped completely.

**Area scanners** and **safety mats** are useful for zones where fixed guarding and light curtains are not practical, such as open-sided cells or collaborative workstations. Laser scanners can define multiple zones with different responses—slow the robot when someone enters the warning zone, stop it completely when they enter the danger zone.

**Two-hand controls** force the operator to keep both hands on buttons during the hazardous portion of the cycle, ensuring their hands are out of the danger zone. These are common on press applications and [assembly systems](/solutions/assembly-systems/) where an operator initiates a clamp or press stroke.

## Safety System Architecture

The safety devices are only as good as the logic and wiring that connect them. This is where safety-rated PLCs and relays come in.

### Safety PLCs vs. Safety Relays

For simple cells with a few safety devices, hardwired safety relays work fine. They are straightforward to design, easy to troubleshoot, and do not require specialized programming. But once you get past three or four safety inputs with conditional logic—different zones, multiple operating modes, muting sequences—a safety PLC pays for itself in reduced wiring complexity and diagnostic capability.

Modern safety PLCs from Allen-Bradley (GuardLogix), Siemens (F-series), and others integrate directly with the standard PLC, giving you safety-rated I/O on the same network as your process control. This simplifies architecture and provides rich diagnostic data: instead of "safety fault—cell stopped," you get "light curtain 3 on load station 2 is blocked" displayed on the HMI.

### Wiring and Circuit Design

Safety circuits must follow established architectural principles:

- **Dual-channel wiring** – Every critical safety device gets two independent channels. If one wire breaks or shorts, the other channel catches it and the system goes to a safe state.
- **Cross-fault detection** – The safety controller monitors both channels and flags a fault if they disagree. This catches wiring errors and device failures before they create a dangerous condition.
- **Pulse testing** – Safety outputs periodically test contactors by cycling them briefly to confirm they have not welded shut. A stuck contactor is a silent failure that defeats the entire safety chain.
- **Category and Performance Level** – Based on your risk assessment, you determine the required Performance Level (PLr) per ISO 13849 or Safety Integrity Level (SIL) per IEC 62061. This dictates the architecture, component ratings, and diagnostic coverage of your safety circuit.

## Integrating Safety Into the Cell Design Workflow

Safety system design should not live in a silo. It intersects with mechanical layout, electrical design, controls programming, and operator workflow. Here is how it fits into a typical [system integration](/services/system-integration/) project:

1. **Conceptual design** – Identify hazard zones and operator interaction points. Establish preliminary guarding strategy. This happens alongside the initial cell layout.
2. **Detailed risk assessment** – Formalize the hazard analysis once the mechanical design is far enough along to identify specific hazards, reach distances, and access requirements.
3. **Safety circuit design** – Specify devices, define the safety architecture, and design the wiring. This runs in parallel with the general electrical design.
4. **Programming and validation** – Configure the safety PLC, test every safety function, and verify that stopping times and distances meet the requirements established in the risk assessment.
5. **Final validation and documentation** – Perform a complete system validation, including stopping time measurements, guard distance verification, and functional testing of every safety device. Document everything for the end user's safety file.

## Common Mistakes to Avoid

After integrating hundreds of automated cells across industries from [automotive](/industries/automotive/) to medical devices, we have seen the same safety design mistakes come up repeatedly:

- **Inadequate stopping distance calculations** – A light curtain placed too close to the hazard does not help if the robot cannot stop before the operator's hand reaches the danger zone. Always calculate and verify stopping distances.
- **Ignoring maintenance access** – If technicians need to enter the cell for routine maintenance and the only option is removing bolted guard panels, those panels will eventually stay off. Design proper interlocked access doors.
- **Muting sequence errors** – Muting lets parts pass through a light curtain without stopping the cell, but poorly designed muting logic can create windows where a person could enter undetected. Muting sensors must be positioned and sequenced correctly.
- **Overlooking fault recovery** – What happens after a safety stop? If the recovery procedure is unclear or cumbersome, operators will find shortcuts. Design intuitive reset procedures with clear HMI guidance.
- **Treating safety as someone else's problem** – The mechanical engineer assumes controls will handle it. Controls assumes the integrator will sort it out. The integrator assumes the end user will add guarding later. Assign clear responsibility from day one.

## The Payoff of Getting It Right

Well-designed guarding does more than prevent injuries. It protects production uptime by eliminating nuisance trips and unnecessary stops. It reduces liability exposure. It passes OSHA inspections without drama. And it builds operator confidence—when people trust the safety systems, they work more efficiently and with less stress.

The investment in proper safety engineering is small relative to total project cost, but the consequences of getting it wrong—in human terms and in financial terms—are enormous.

## Work With Engineers Who Understand Safety Integration

At AMD Machines, safety system design is embedded in our engineering process from the first concept sketch through final validation. With over 30 years of building custom automated systems, we understand how to design guarding that protects operators without compromising cycle time or accessibility. [Contact us](/contact/) to discuss your next project.
