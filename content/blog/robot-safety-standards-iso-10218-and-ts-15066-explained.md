---
title: 'Robot Safety Standards: ISO 10218 and TS 15066 Explained'
description: Navigate industrial robot safety standards to ensure compliant and safe
  automation implementations. In today's competitive manufacturing environment,.
keywords: industrial automation, manufacturing automation, AMD Machines, industrial
  robots, robotic automation, robot integration, robot, safety, standards
date: '2026-01-10'
author: AMD Machines Team
category: Robotics
read_time: 8
template: blog-post.html
url: /blog/robot-safety-standards-iso-10218-and-ts-15066-explained/
---

## Why Robot Safety Standards Matter

Industrial robots are powerful machines. A typical 6-axis robot can exert hundreds of newtons of force and move at speeds exceeding 2 meters per second. Without proper safeguarding, a collision between a robot and a human can cause serious injury or death.

Safety standards exist to define the minimum requirements that robot manufacturers, system integrators, and end users must follow to protect workers. The three foundational standards for industrial robot safety are **ISO 10218-1**, **ISO 10218-2**, and **ISO/TS 15066**. Together, they cover everything from the robot itself to the complete workcell to collaborative applications where humans and robots share workspace.

Understanding these standards is not optional — it is a legal and ethical requirement for anyone designing, integrating, or operating robotic systems.

## ISO 10218-1: Requirements for Robot Manufacturers

**ISO 10218-1:2011** specifies safety requirements for the design and construction of the industrial robot itself. This standard applies to robot manufacturers like FANUC, Yaskawa, ABB, and KUKA.

### What It Covers

- **Protective stop functions**: The robot must have safety-rated stop functions (Category 0 and Category 1 per IEC 60204-1) that bring the robot to a controlled stop when triggered
- **Speed and force limiting**: The robot controller must support configurable speed limits that can be enforced by the safety system
- **Axis limiting**: Hardware and software limits that restrict robot motion to defined zones
- **Singular point protection**: Prevention of unpredictable motion near kinematic singularities
- **Emergency stop**: Compliant E-stop circuits that meet IEC 60204-1 requirements
- **Safety-rated control functions**: Functions like safe speed monitoring, safe standstill monitoring, and safe axis range limiting that are implemented at the required performance level (PLd per ISO 13849-1 or SIL2 per IEC 62061)

### Verification and Validation

ISO 10218-1 requires robot manufacturers to verify that all safety functions perform as specified through testing, analysis, and documentation. The robot must be delivered with a comprehensive safety manual that details all safety-rated functions, their performance levels, and integration requirements.

As a system integrator, you rely on the robot manufacturer's compliance with ISO 10218-1 as the foundation of your safety system. Always verify that your robot's safety manual documents the specific performance levels of each safety function.

## ISO 10218-2: Requirements for Integrators and Users

**ISO 10218-2:2011** covers the safety requirements for industrial robot system integration and installation. This is the standard most relevant to system integrators like AMD Machines and to end users operating robotic workcells.

### Risk Assessment

The core requirement of ISO 10218-2 is a **documented risk assessment** for the complete robotic system. This risk assessment must:

1. **Identify hazards** — Evaluate all hazards present in the robotic workcell, including mechanical, electrical, thermal, noise, radiation, and material hazards
2. **Estimate risk** — Determine the severity of potential harm and the probability of occurrence for each hazard
3. **Evaluate risk** — Compare estimated risk against acceptable risk levels
4. **Reduce risk** — Apply protective measures following the hierarchy: elimination by design, safeguarding, and administrative controls (in that order)

The risk assessment is a living document — it must be updated whenever the system is modified, reprogrammed, or relocated.

### Safeguarding Methods

ISO 10218-2 defines several safeguarding approaches:

- **Perimeter guarding**: Physical barriers (fencing, panels) that prevent access to the robot's operating space. Access points use interlocked gates that trigger a safety stop when opened.
- **Presence-sensing devices**: Light curtains, area scanners, and safety mats that detect when a person enters a defined zone and trigger protective stops.
- **Safety-rated speed control**: Reducing robot speed when safeguarding is partially bypassed (e.g., during setup or maintenance with a reduced-speed enable switch).
- **Safety-rated monitored stop**: Holding the robot in a safe position while a person is in the collaborative workspace.

### Installation and Commissioning

Before a robotic system enters production, ISO 10218-2 requires:

- Verification that all safety functions operate correctly
- Validation of stopping distances and times
- Measurement of maximum robot speed and force in safeguarded modes
- Documentation of all safety settings and configurations
- Operator training on safe operation, emergency procedures, and hazard awareness

## ISO/TS 15066: Collaborative Robot Safety

**ISO/TS 15066:2016** is a technical specification that provides detailed guidance for collaborative robot applications — systems where humans and robots intentionally share workspace during production operations. It supplements ISO 10218-1 and ISO 10218-2 and does not replace them.

### Four Collaborative Operation Modes

ISO/TS 15066 defines four modes of collaborative operation. A system may use one or more of these modes:

### 1. Safety-Rated Monitored Stop

The robot stops and holds position before a human enters the collaborative workspace. The robot does not move while the person is present. Motion resumes only after the person leaves and a restart signal is given.

**Use case**: A worker loads or unloads parts into a robot fixture while the robot is stationary.

### 2. Hand Guiding

A human physically guides the robot by applying force to an end-effector-mounted device. The robot has a safety-rated monitored stop active by default and only moves in response to direct human input.

**Use case**: An operator guides the robot through a path for programming, or moves the robot to assist with a heavy-part handling task.

### 3. Speed and Separation Monitoring (SSM)

The robot operates at full speed when the human is far away and slows down or stops as the human approaches. The system uses sensors (typically laser area scanners) to continuously monitor the separation distance and adjusts robot speed to maintain a safe protective separation distance.

The minimum protective separation distance is calculated using:

**S = Sh + Sr + Ss + C + Zd + Zr**

Where:
- **Sh** = contribution from human speed
- **Sr** = contribution from robot stopping distance
- **Ss** = contribution from robot speed changes during stopping
- **C** = intrusion distance from the sensing system
- **Zd** = position uncertainty of the human
- **Zr** = position uncertainty of the robot

**Use case**: A robot and operator work at adjacent stations on an assembly line. The robot runs at production speed when the operator is at their station but slows or stops if they reach into the robot's area.

### 4. Power and Force Limiting (PFL)

The robot is designed so that contact between the robot and a human does not cause injury. This is achieved by limiting the robot's speed, force, pressure, and momentum to values below injury thresholds.

This is the mode most commonly associated with collaborative robots (cobots) like Universal Robots, FANUC CRX, and Yaskawa HC series.

### PFL Force and Pressure Thresholds

ISO/TS 15066 Table A.2 provides maximum permissible force and pressure values for transient (impact) contact by body region:

| Body Region | Max Transient Force (N) | Max Transient Pressure (N/cm²) |
|---|---|---|
| Skull / Forehead | 130 | 110 |
| Face | 65 | 110 |
| Neck | 150 | 50 |
| Back / Shoulders | 210 | 140 |
| Chest | 140 | 110 |
| Abdomen | 110 | 110 |
| Upper arm / Elbow | 150 | 130 |
| Forearm / Wrist | 160 | 180 |
| Hand / Fingers | 140 | 200 |
| Thigh / Knee | 220 | 160 |
| Lower leg | 130 | 130 |

**Quasi-static (clamping) contact** thresholds are significantly lower — typically 40-65% of the transient values — because sustained compression causes injury at lower forces.

These values are biomechanical limits based on pain onset thresholds. Staying below them does not guarantee zero risk; it means the risk of injury is acceptably low.

### Calculating Safe Speeds

For PFL applications, the maximum allowable robot speed depends on the robot's effective mass at the point of contact and the applicable force limit. The relationship is:

**F = m × v / Δt**

Where F is the force limit, m is the effective mass (robot + payload + end effector), v is the velocity, and Δt is the contact duration (typically 0.5 seconds for transient contact). Robot manufacturers provide tools to calculate maximum safe speeds for specific configurations.

As a rule of thumb, most PFL cobots operate at speeds between 250 mm/s and 1,000 mm/s depending on payload and expected contact area. Higher payload means lower maximum safe speed.

## Risk Assessment Process: Step by Step

Whether you are building a fully guarded workcell or a collaborative application, the risk assessment process follows the same structure:

1. **Define the application** — Document the robot model, payload, end effector, workpiece, cycle, and operating modes (automatic, manual, maintenance)
2. **Identify the hazards** — Walk through every phase of operation and identify what could cause harm: crushing, impact, shearing, entanglement, ejection of parts, electrical, thermal
3. **Estimate the risk for each hazard** — Use a risk scoring method (e.g., ISO 12100 Annex A) considering severity, exposure frequency, and avoidance probability
4. **Apply protective measures** — For each unacceptable risk, select and implement safeguards following the hierarchy: design changes first, then guards and safety devices, then information and training
5. **Verify effectiveness** — Test that each protective measure works as intended. Measure stopping distances, verify sensor coverage, validate safety circuit performance
6. **Document everything** — The risk assessment, safety system design, verification results, and residual risks must all be documented and maintained

## Common Safety Components

A compliant robotic safety system typically includes some combination of:

- **Safety PLC or safety controller** — Processes safety inputs and controls safety outputs at the required performance level (PLd/PLe or SIL2/SIL3)
- **Light curtains** — Type 4 (PLe) devices that detect intrusion through a plane of infrared beams. Used for perimeter access protection.
- **Laser area scanners** — Type 3 (PLd) devices that monitor a 2D area on the floor. Used for zone-based speed and separation monitoring.
- **Safety-rated interlock switches** — Monitor guard door positions. Tongue-style or RFID-coded switches prevent bypassing.
- **Emergency stop buttons** — Category 0 or Category 1 stops accessible from all operator positions.
- **Enabling devices** — Three-position switches held by personnel during setup and manual operations.
- **Safety mats** — Pressure-sensitive mats that detect standing or walking in a defined area.

## Compliance Checklist for Manufacturers

Use this checklist when planning or auditing a robotic installation:

- [ ] Risk assessment completed and documented per ISO 10218-2
- [ ] Robot safety manual reviewed and safety function performance levels verified
- [ ] Safeguarding method selected based on risk assessment
- [ ] Safety circuit design meets required performance level (minimum PLd / SIL2)
- [ ] Emergency stop circuits functional and accessible from all operator positions
- [ ] Guard interlocks installed and tested (Category coded per ISO 14119)
- [ ] Stopping distance and time measured and documented
- [ ] Safety-rated speed monitoring configured and verified
- [ ] Axis limits configured to restrict motion to the required workspace
- [ ] Presence-sensing devices positioned per manufacturer specifications (height, angle, range)
- [ ] Collaborative applications validated against ISO/TS 15066 force and pressure limits
- [ ] Operator training completed and documented
- [ ] Safety system documentation package assembled and stored

## How AMD Machines Ensures Compliance

At AMD Machines, safety is engineered into every robotic system from the concept stage. Our process includes:

- **Risk assessment during design** — We perform a preliminary risk assessment before the first CAD model is created, then refine it throughout the project
- **Safety circuit design by qualified engineers** — Our controls engineers design safety systems using safety-rated PLCs and validated safety components
- **Full validation before shipment** — Every system undergoes safety validation including stopping distance measurement, sensor coverage verification, and force measurement for collaborative applications
- **Documentation packages** — We deliver complete risk assessments, safety system drawings, safety function verification records, and operator training materials with every system

## Partner With AMD Machines

AMD Machines brings decades of experience to every project. Our engineers understand the challenges manufacturers face and deliver solutions that work in the real world. [Contact us](/contact/) to discuss your automation needs.
