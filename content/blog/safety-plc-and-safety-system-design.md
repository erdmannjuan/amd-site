---
title: Safety PLC and Safety System Design
description: A practical guide to safety PLC architecture, SIL/PLd ratings, safety
  circuit design, and compliance with ISO 13849 and IEC 62061 for industrial automation.
keywords: safety PLC, safety system design, ISO 13849, IEC 62061, SIL, performance
  level, safety relay, safety controller, machine safety, risk assessment
date: '2025-04-17'
author: AMD Machines Team
category: Guides
read_time: 8
template: blog-post.html
url: /blog/safety-plc-and-safety-system-design/
---

## Why Safety PLCs Exist

Standard PLCs were never designed to fail safely. A conventional programmable logic controller will execute its program reliably under normal conditions, but when a processor faults, memory corrupts, or an I/O module fails, the behavior is unpredictable. In a motion-intensive manufacturing cell, unpredictable means dangerous.

Safety PLCs solve this problem through redundant architecture, self-diagnostics, and deterministic failure modes. When something goes wrong inside a safety PLC, the system forces outputs to a known safe state—typically de-energized—within a guaranteed response time. That fundamental difference between "keep running" and "fail to a safe state" is why safety-rated controllers exist as a distinct product category and why standards like ISO 13849 and IEC 62061 mandate their use in safety-related control functions.

## Understanding the Standards: ISO 13849 and IEC 62061

Two international standards govern safety system design for machinery, and understanding when to apply each one matters.

**ISO 13849** uses Performance Levels (PL a through PL e) to classify safety functions. It applies broadly to all technologies—electrical, hydraulic, pneumatic, and mechanical. Most machine builders in North America default to ISO 13849 because it covers the full range of safety devices they typically integrate. The standard defines five categories (B, 1, 2, 3, 4) that describe the architecture's structural requirements, and the achievable Performance Level depends on the category, diagnostic coverage, and mean time to dangerous failure (MTTFd) of each component.

**IEC 62061** uses Safety Integrity Levels (SIL 1 through SIL 3 for machinery) and applies specifically to electrical, electronic, and programmable electronic systems. It takes a more quantitative approach, requiring probability of dangerous failure per hour (PFHd) calculations. For complex safety PLC architectures, IEC 62061 often provides a more rigorous framework.

In practice, the two standards produce comparable results for most applications. A PL d safety function roughly corresponds to SIL 2, and PL e corresponds to SIL 3. The choice between them often comes down to your end customer's requirements or the regional norms your machine must satisfy.

## Safety System Architecture

A properly designed safety system has three layers: input devices, the safety logic solver, and output devices. Each layer must maintain its safety integrity independently.

### Safety Input Devices

Safety-rated inputs include emergency stop buttons, safety gate switches, light curtains, safety laser scanners, two-hand controls, and enabling devices. These devices are designed with forced-guided contacts, redundant sensing channels, or other mechanisms that make dangerous undetected failures extremely unlikely.

A common mistake is connecting a standard proximity sensor to a safety PLC input and calling it a safety function. The sensor itself must carry a safety rating appropriate to the required Performance Level. The safety chain is only as strong as its weakest component.

### The Safety Logic Solver

Safety PLCs from major manufacturers—Allen-Bradley GuardLogix, Siemens S7 F-series, Pilz PSS, and others—achieve their safety rating through internal redundancy. A typical architecture runs two independent processors executing the same safety program simultaneously. A comparison unit continuously checks that both processors agree on outputs. If they diverge, the system trips to the safe state.

Programming safety PLCs differs from standard PLC programming in several important ways. Safety function blocks are certified and pre-validated—you do not write custom ladder logic for safety-critical voting. Instead, you configure certified function blocks for emergency stop monitoring, guard door monitoring, light curtain muting, and similar functions. The safety program is separate from the standard program and executes on its own dedicated task with a fixed, deterministic cycle time.

For smaller machines or standalone safety functions, safety relay modules from companies like Pilz, SICK, or Banner provide a cost-effective alternative to a full safety PLC. These devices handle single safety functions—one e-stop circuit, one guard door—without requiring a programmable controller. When you need to coordinate multiple safety zones, manage complex muting sequences, or integrate safety data into your [plant-floor controls architecture](/blog/electrical-design-standards-for-automation/), a safety PLC becomes the practical choice.

### Safety Output Devices

On the output side, safety-rated contactors with forced-guided (mirror) contacts are the standard approach for controlling hazardous motion. The forced-guided contact design ensures that if a main contact welds closed, the monitoring contacts physically cannot close, giving the safety PLC a reliable feedback signal that the contactor has failed.

For variable-frequency drives, most modern drives include Safe Torque Off (STO) inputs that accept signals directly from the safety PLC. STO removes the drive's ability to generate torque without cutting main power, which allows faster restart after a safety event compared to removing power at the contactor level. More advanced safety drive functions—Safe Limited Speed (SLS), Safe Speed Monitor (SSM), Safe Direction (SDI)—enable sophisticated collaborative and speed-monitored applications.

## Risk Assessment Drives Everything

Before selecting any safety hardware, you need a risk assessment. ISO 12100 provides the methodology: identify hazards, estimate the risk for each hazard (severity, frequency of exposure, possibility of avoidance), and determine the required risk reduction. The output of the risk assessment tells you what Performance Level or SIL each safety function must achieve.

Skipping the risk assessment—or treating it as paperwork to complete after the machine is built—is the single most common failure mode in safety system design. Without a documented risk assessment, you have no rational basis for your safety architecture decisions, and you cannot demonstrate compliance to an auditor, an insurance inspector, or a plaintiff's attorney.

A proper risk assessment is a living document. When the machine is modified, new tooling is added, or the production process changes, the risk assessment must be revisited. At AMD Machines, we integrate risk assessment into the earliest stages of machine concept development so that [guarding and safety system layouts](/blog/guarding-and-safety-system-design/) are built into the design rather than bolted on at the end.

## Safety Circuit Design Principles

Several design principles separate robust safety circuits from ones that create ongoing headaches on the plant floor.

**Dual-channel architecture** is the foundation of Category 3 and Category 4 circuits. Two independent sensing channels monitor the same safety device, and the safety logic solver compares them. A single-channel fault does not create a dangerous condition because the redundant channel maintains protection. The key requirement is that the two channels are truly independent—separate wiring, separate conduit runs, and ideally separate I/O modules.

**Cross-fault detection** prevents a short circuit between the two channels from defeating the redundancy. Safety PLCs continuously monitor both channels and detect if they become shorted together, either through periodic pulse testing of the input circuits or through monitoring for simultaneous state changes that fall outside the expected timing window.

**Diagnostic coverage** quantifies how much of the dangerous failure rate is detected by automatic diagnostics. Higher diagnostic coverage allows you to achieve higher Performance Levels with the same hardware architecture. Safety PLCs provide inherently high diagnostic coverage through their internal redundancy and self-testing, but the input and output circuits need their own diagnostics—contactor feedback monitoring, light curtain self-test functions, and wiring fault detection all contribute.

**Response time** is the total time from the safety event (a gate opening, a light curtain interrupted) to the hazard reaching a safe state (motion stopped, energy removed). You must calculate this by adding the input device response time, safety PLC scan time, output device response time, and the mechanical stopping time of the machine. This total determines the minimum safety distance—how far the safeguarding device must be placed from the hazard. Getting this calculation wrong means either an unsafe installation or an unnecessarily large safety distance that wastes floor space and slows production.

## Integration With Standard Controls

The interface between the safety system and the standard machine control is a critical design boundary. The safety PLC typically communicates its zone status to the standard PLC over an industrial network—EtherNet/IP CIP Safety, PROFIsafe over PROFINET, or similar safety-rated protocols. The standard PLC uses this information for sequencing and HMI display but never for safety decisions.

A well-designed integration allows operators to see exactly which safety device tripped, which zone is in a safe state, and what conditions must be satisfied before a restart. Poorly designed systems give the operator a single "safety fault" alarm with no diagnostic information, leading to frustration, time-consuming troubleshooting, and the inevitable temptation to bypass. Detailed safety diagnostics on the HMI, drawn from the [safety circuit architecture](/blog/complete-guide-to-industrial-safety-circuits/), dramatically reduce downtime and eliminate the motivation to circumvent safety devices.

## Validation and Verification

After installation, every safety function must be validated—physically tested to confirm it achieves the intended risk reduction. Validation includes functional testing (does the e-stop actually stop the machine?), response time measurement (does it stop fast enough?), and fault injection testing (does the system detect wiring faults, contactor failures, and sensor faults as designed?).

Document everything. The validation report, combined with the risk assessment and the safety system design documentation, forms the technical file required by the Machinery Directive in Europe and expected by OSHA and insurance carriers in North America. This documentation is not optional overhead—it is the evidence that your machine is safe to operate.

## Getting Safety Design Right From the Start

Safety system design is most effective and least expensive when it starts at the concept stage. Retrofitting safety systems onto finished machines costs more, compromises ergonomics, and frequently results in overly conservative solutions that hurt productivity.

At AMD Machines, our engineers design safety systems concurrently with the mechanical, electrical, and controls engineering. The risk assessment informs the machine layout, the guarding strategy drives the mechanical design, and the safety PLC architecture is specified alongside the standard controls. This integrated approach produces machines that are genuinely safe, fully compliant, and efficient to operate. [Contact us](/contact/) to discuss how we approach safety system design for your next automation project.
