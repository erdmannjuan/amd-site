---
title: 'Robot Safety Standards: ISO 10218 and TS 15066 Explained'
description: A practical engineering guide to ISO 10218-1, ISO 10218-2, and ISO/TS 15066 robot safety standards covering risk assessment, safeguarding, collaborative operations, and compliance for industrial automation.
keywords: robot safety standards, ISO 10218, ISO TS 15066, collaborative robot safety, cobot safety, risk assessment robotics, robot safeguarding, industrial robot compliance, PFL force limits, safety-rated monitored stop
date: '2026-01-10'
author: AMD Machines Team
category: Robotics
read_time: 10
template: blog-post.html
url: /blog/robot-safety-standards-iso-10218-and-ts-15066-explained/
---

## Why Robot Safety Standards Exist — and Why Engineers Need to Know Them

Every industrial robot on a factory floor is a machine capable of serious harm. A standard 6-axis articulated robot generates hundreds of newtons of force, moves at speeds exceeding two meters per second, and weighs anywhere from 30 to over 2,000 kilograms depending on the payload class. The kinetic energy involved in a collision between a robot and a human body is not theoretical — it is a well-documented cause of workplace fatalities and severe injuries going back decades.

Safety standards for robotics are not suggestions. They are codified engineering requirements that define how robots must be designed, how workcells must be integrated, and how collaborative applications must be validated before a single production cycle runs. For system integrators and manufacturers, compliance with these standards is both a legal obligation and a professional responsibility.

The three foundational documents governing industrial robot safety are **ISO 10218-1**, **ISO 10218-2**, and **ISO/TS 15066**. They form a layered framework: Part 1 addresses the robot itself, Part 2 addresses the integrated system, and TS 15066 provides specific guidance for collaborative applications where humans and robots share workspace. Understanding all three is essential for anyone designing, specifying, or operating robotic equipment.

## ISO 10218-1: Safety Requirements for the Robot

**ISO 10218-1:2011** defines the safety requirements that robot manufacturers must meet in the design and construction of the robot hardware and controller. This standard applies to companies like FANUC, Yaskawa, ABB, KUKA, and Universal Robots — the OEMs that build the machines system integrators select for their projects.

### Safety-Rated Control Functions

The heart of ISO 10218-1 is its requirements for safety-rated control functions built into the robot controller. These include:

- **Safety-rated monitored stop**: The robot holds position with active monitoring. If the robot drifts beyond a defined tolerance, a protective stop triggers. This function is fundamental to collaborative applications.
- **Safety-rated soft axis and space limiting**: The controller enforces boundaries on individual joint positions and Cartesian workspace regions. When the robot reaches a configured limit, the safety system intervenes before the mechanical hard stop.
- **Safety-rated speed monitoring**: The controller continuously monitors TCP (tool center point) speed against a configured threshold. If speed exceeds the limit, the safety system triggers a stop. Performance levels must meet a minimum of PLd per ISO 13849-1 or SIL2 per IEC 62061.
- **Safe torque off and safe stop functions**: Category 0 stops (immediate power removal) and Category 1 stops (controlled deceleration followed by power removal) per IEC 60204-1 must be available and properly implemented.

### What This Means for Integrators

As a system integrator, you do not design the robot's internal safety architecture — the OEM handles that. But you are responsible for understanding what safety functions the robot provides, at what performance level, and how to properly interface with them. Every robot ships with a safety manual that documents these details. Reading it thoroughly before starting the safety circuit design is not optional — it is the first step in any compliant integration.

The robot's safety functions form the foundation of the complete system safety architecture. If you do not understand their capabilities and limitations, you cannot design an adequate safeguarding system around them.

## ISO 10218-2: Safety Requirements for System Integration

**ISO 10218-2:2011** is the standard most directly relevant to system integrators and end users. It covers the safety requirements for the complete robotic system — the robot, end effector, workpiece handling, fixturing, conveyors, operator interfaces, and all associated safeguarding.

### Risk Assessment: The Core Requirement

The central obligation under ISO 10218-2 is performing and documenting a comprehensive risk assessment for the entire robotic workcell. This is not a checkbox exercise. A proper risk assessment requires engineering judgment applied systematically across every phase of the system's lifecycle.

The process follows ISO 12100 (Safety of Machinery — General Principles for Design):

1. **Define the limits of the machine**: Identify the intended use, foreseeable misuse, space limits, and time limits (lifecycle phases including installation, commissioning, production, maintenance, cleaning, and decommissioning).
2. **Identify all hazards**: Walk through every operational mode and lifecycle phase. Consider mechanical hazards (crushing, shearing, entanglement, impact, ejection), electrical hazards, thermal hazards, noise, vibration, radiation, and hazards from materials being processed.
3. **Estimate the risk**: For each identified hazard, evaluate severity of potential harm, frequency of exposure, probability of the hazardous event occurring, and possibility of avoidance.
4. **Evaluate the risk**: Determine whether each estimated risk is acceptable or requires reduction.
5. **Reduce unacceptable risks**: Apply the hierarchy of protective measures — inherently safe design first, then safeguarding and complementary protective measures, then information for use (warnings, training, PPE).

The risk assessment is a living document. Any modification to the system — a tool change, a new part program, a layout adjustment, relocation to a different facility — requires a review and potential update of the risk assessment.

### Safeguarding Strategies

ISO 10218-2 describes several safeguarding methods that integrators select based on the risk assessment:

**Perimeter guarding** remains the most common approach for high-speed, high-payload applications. Physical barriers — typically welded steel tube frames with polycarbonate or wire mesh panels — enclose the robot's maximum operating envelope. Access points use interlocked gates with safety-rated switches (tongue, RFID-coded, or trapped-key types per ISO 14119). When a gate opens, the safety system triggers a Category 1 stop.

**Presence-sensing devices** provide safeguarding without physical barriers. Type 4 light curtains (PLe-rated) detect intrusion through a vertical plane of infrared beams and are commonly used at part load/unload stations. Type 3 safety laser scanners monitor 2D floor areas and support multiple configurable zones — useful for implementing speed and separation monitoring in [robotic integration projects](/solutions/robot-integration/).

**Safety-rated speed control** allows personnel to operate near the robot at reduced speed during setup, programming, and maintenance. The operator holds a three-position enabling device (deadman switch) that permits motion only when held in the center position. Releasing or squeezing through the switch triggers an immediate stop.

### Verification and Validation

Before a system enters production, ISO 10218-2 requires verification that every safety function operates correctly. This includes measuring actual stopping distances and comparing them to the calculated distances used in safeguard positioning, verifying sensor coverage matches the design intent, testing every interlock and E-stop circuit, and confirming that safety PLCs execute the correct logic under all conditions. These measurements and test results must be documented and retained.

## ISO/TS 15066: The Collaborative Robot Standard

**ISO/TS 15066:2016** is a technical specification — not a full standard — that provides detailed guidance for collaborative robot applications. It supplements ISO 10218-1 and ISO 10218-2 and does not replace them. Every collaborative installation still requires full compliance with both parts of ISO 10218.

TS 15066 addresses the specific challenge of applications where humans and robots intentionally occupy the same workspace during normal production operations. It defines four collaborative operation modes, and a given application may use one or more of them.

### Safety-Rated Monitored Stop

The robot stops and holds position before a human enters the collaborative workspace. No robot motion occurs while the person is present. This is the simplest collaborative mode and is essentially a traditional safeguarded cell with faster restart — the robot does not need to re-home after every operator interaction.

**Typical application**: An operator loads parts into a fixture while the robot waits. After the operator steps clear, a restart signal (button press, area scanner clear signal) allows the robot to resume at production speed.

### Hand Guiding

The operator physically moves the robot by applying force to a device mounted on the end effector. The robot defaults to a safety-rated monitored stop and only moves in response to direct human input through the guiding device. This mode requires the hand-guiding device to include an enabling switch and emergency stop.

**Typical application**: Lead-through programming, where an operator teaches waypoints by physically moving the robot arm. Also used for assisted handling of heavy parts where the robot provides lift support while the operator controls position.

### Speed and Separation Monitoring (SSM)

This mode dynamically adjusts robot speed based on the measured distance between the human and the robot. When the operator is far away, the robot runs at or near production speed. As the operator approaches, the robot decelerates. If the separation distance drops below the minimum protective separation distance, the robot stops.

The minimum protective separation distance calculation from ISO/TS 15066 accounts for human movement speed, robot stopping distance, sensor response time, and position uncertainty of both the human and the robot. Implementing SSM correctly requires safety-rated sensing (typically laser area scanners) and a controller capable of real-time speed adjustment based on sensor input.

**Typical application**: Adjacent workstations on an [assembly line](/solutions/automated-assembly-systems/) where a human and robot perform different tasks in close proximity. The robot operates at full speed during normal production but decelerates or stops when the operator reaches into the shared zone.

### Power and Force Limiting (PFL)

PFL is the mode most commonly associated with collaborative robots — the cobots from Universal Robots, FANUC CRX, Yaskawa HC series, and others. The robot is designed so that any contact between the robot and a human body does not exceed biomechanical injury thresholds.

ISO/TS 15066 Annex A provides a table of maximum permissible force and pressure values by body region, based on pain onset research. For example:

| Body Region | Max Transient Force (N) | Max Transient Pressure (N/cm²) |
|---|---|---|
| Skull / Forehead | 130 | 110 |
| Face | 65 | 110 |
| Chest | 140 | 110 |
| Upper arm / Elbow | 150 | 130 |
| Hand / Fingers | 140 | 200 |
| Thigh / Knee | 220 | 160 |

Quasi-static (clamping) thresholds are significantly lower — typically 40-65% of the transient values — because sustained compression causes tissue damage at lower forces.

For PFL applications, the maximum allowable robot TCP speed depends on the effective mass at the point of contact (robot mass + payload + end effector), the contact geometry, and the applicable force limit. Practically, most PFL cobots operate between 250 mm/s and 1,000 mm/s. Higher payloads mean lower permissible speeds. Every PFL application requires contact force measurement during validation — you cannot rely on manufacturer default settings alone.

### A Critical Point About PFL

PFL does not make the end effector safe. A cobot carrying a sharp tool, a hot welding tip, or an unguarded grinder can cause injury regardless of force limiting. The risk assessment must evaluate the complete system including the tool, the workpiece, and the process. PFL addresses blunt-impact and crushing hazards only.

## Practical Risk Assessment Process

Whether you are building a fully guarded workcell or a collaborative application, the risk assessment follows the same structure. Here is how we approach it at AMD Machines on every [robotic integration project](/solutions/robot-integration/):

1. **Define the application completely** — Robot model, payload, end effector, workpiece, cycle time, production rate, all operational modes (automatic, manual, maintenance, cleaning), and personnel who will interact with the system.
2. **Identify every hazard** — Walk through each mode of operation. Consider what happens during normal production, during part changeover, during a jam or fault recovery, during maintenance, and during foreseeable misuse.
3. **Estimate and evaluate risk** — Use a structured risk scoring method. We use a risk graph per ISO 12100 Annex A that considers severity, exposure frequency, and avoidance probability.
4. **Select and implement protective measures** — Follow the hierarchy strictly. Redesign to eliminate the hazard first. If that is not feasible, add safeguarding. Only rely on training and PPE as a last resort.
5. **Verify and validate** — Measure stopping distances, test sensor coverage, measure contact forces for PFL applications, verify safety circuit logic, and test every interlock and E-stop.
6. **Document everything** — The completed risk assessment, safety system design drawings, verification test records, and residual risk documentation form the safety file for the system.

## Common Mistakes in Robot Safety

From decades of robot integration experience, we see these recurring errors:

- **Skipping the risk assessment update after modifications** — Adding a new part program or changing an end effector changes the risk profile. The risk assessment must be reviewed.
- **Incorrect safeguard positioning** — Light curtains and scanners positioned too close to the hazard zone allow the robot to reach the operator before it stops. Minimum distance calculations per ISO 13855 must account for approach speed, device response time, and robot stopping time.
- **Assuming cobots do not need safeguarding** — A cobot does not automatically create a safe application. The end effector, workpiece, process, and environment all contribute to the risk. PFL alone may not be sufficient.
- **Inadequate stopping distance verification** — Calculated stopping distances must be validated by actual measurement. Brake wear, mechanical compliance, and payload variations can increase actual stopping distances beyond calculated values.

## How AMD Machines Ensures Compliance

Safety engineering is integrated into every phase of our project execution. We perform preliminary risk assessments during concept design, refine them through detailed engineering, and validate them during build and commissioning. Our controls engineers design safety circuits using safety-rated PLCs with validated function blocks, and every system undergoes full safety validation — including stopping distance measurement and force measurement for collaborative applications — before shipment.

We deliver complete safety documentation packages with every system: risk assessments, safety circuit drawings, verification test records, and operator training materials. This documentation is not an afterthought — it is a project deliverable with the same level of engineering rigor as the mechanical and controls design.

If you are planning a robotic automation project and need guidance on safety standards compliance, [contact our engineering team](/contact/) to discuss your application.
