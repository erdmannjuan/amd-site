---
title: Digital Twins & Simulation | Virtual Commissioning
description: "Digital twin and virtual commissioning services using FANUC Roboguide, ABB RobotStudio, and Siemens Tecnomatix. Cut commissioning time 40-60% and eliminate costly rework."
keywords: digital twin manufacturing, virtual commissioning, robot simulation, offline robot programming, FANUC Roboguide, ABB RobotStudio, process simulation
template: page.html
hero_title: Digital Twins & Simulation
hero_subtitle: Optimize your automation before building it with virtual commissioning and digital twin technology
label: Digital Twins
url: /services/digital-twins/
---

I'll be honest with you — there was a time when I thought digital twins were just a buzzword. A fancy sales pitch wrapped around software that didn't deliver. Then we ran a virtual commissioning project for a Tier 1 automotive supplier's brake caliper assembly line, and the simulation caught a robot reach issue that would've cost us three weeks of on-site rework and roughly $180,000 in expedited tooling modifications. That was the moment everything changed for our team.

After 30+ years of building [custom automation systems](/solutions/custom-automation/), we've seen the industry shift dramatically. Digital twin technology isn't optional anymore — it's the difference between projects that launch on time and projects that bleed money during commissioning. At AMD Machines, we've integrated virtual commissioning into every major project, and the results speak for themselves: 40-60% reduction in on-site commissioning time, near-zero rework on robot programs, and clients who actually sleep at night during system integration.

## What a Digital Twin Actually Is (And What It Isn't)

Let's cut through the marketing fog. A digital twin isn't just a 3D model that looks nice in a PowerPoint presentation. A real digital twin is a functionally accurate virtual replica of your physical automation system — one that runs the same PLC code, executes the same robot programs, and responds to the same I/O signals as the machine sitting on your production floor.

Here's what that means in practice:

- **Kinematically accurate robot models** running actual TP programs (not approximations) in FANUC Roboguide or ABB RobotStudio
- **PLC logic executing in real-time** via Siemens PLCSIM Advanced or Rockwell Automation's Studio 5000 Logix Emulate — the same ladder logic and function blocks that'll run on the physical controller
- **Sensor and I/O simulation** that mirrors every photoelectric, proximity sensor, encoder, and safety device in the real system
- **Accurate cycle time predictions** within 3-5% of actual production performance
- **Physics-based collision detection** that catches interference issues no CAD review can find

What it isn't: a static 3D rendering, a flowchart with estimated times, or a video animation. If you can't download the robot program from the simulation directly to the physical controller, it's not a digital twin — it's a cartoon.

## Why Virtual Commissioning Changes Everything

### The Real Cost of "We'll Figure It Out On-Site"

I've been on enough factory floors at 2 AM to know exactly what happens when teams skip simulation. A robot path that looked fine in CAD clips a fixture corner by 12mm. A PLC sequence that seemed logical has a race condition nobody caught. An operator panel layout that made sense on paper is impossible to use with gloves on.

Every one of these problems is cheap to fix in simulation and brutally expensive to fix during physical commissioning. Here's what the numbers actually look like across our project history:

| Issue Type | Cost to Fix in Simulation | Cost to Fix On-Site |
|---|---|---|
| Robot reach/interference | $500 - $2,000 (program change) | $15,000 - $80,000 (tooling redesign) |
| PLC logic error | $200 - $1,000 (code revision) | $5,000 - $25,000 (downtime + debug) |
| Cycle time miss | $1,000 - $5,000 (path optimization) | $50,000+ (mechanical redesign) |
| Safety system gap | $500 - $3,000 (sensor relocation) | $10,000 - $40,000 (retrofit) |

On a typical [robotic cell](/solutions/robotic-cells/) project valued at $400K-$800K, virtual commissioning adds 5-8% to the engineering budget but eliminates 15-25% of what you'd otherwise spend on on-site troubleshooting. The ROI isn't close — it's typically 3:1 to 5:1.

### Commissioning Time Reduction

Here's a real comparison from two similar [welding](/solutions/welding/) cells we built — one with full virtual commissioning, one without (the client declined simulation to save budget):

**Without virtual commissioning:** 14 days on-site, 47 engineering change orders, 3 tooling modifications, production launch delayed 3 weeks.

**With virtual commissioning:** 6 days on-site, 8 engineering change orders (minor adjustments only), zero tooling changes, launched on schedule.

The client who skipped simulation "saved" $35,000 in engineering fees and spent an additional $210,000 in delayed production, overtime labor, and expedited parts. They've never skipped simulation since.

## Our Simulation Software Stack

We don't lock ourselves into one vendor's ecosystem. Your project gets the right tools, period. Here's what we work with daily:

### Robot Simulation & Offline Programming

- **FANUC Roboguide** — Our most-used platform. Full virtual teach pendant, accurate FANUC motion planning, HandlingPRO and WeldPRO process packages. We run every FANUC robot program through Roboguide before it touches a physical controller.
- **ABB RobotStudio** — Built on ABB's actual VirtualController technology, so the simulation runs identical motion code to the real IRC5/OmniCore controller. Outstanding for [assembly](/solutions/assembly/) and material handling applications.
- **KUKA.Sim** — Essential for KUKA projects, particularly in automotive body-in-white and heavy-payload applications. Excellent collision detection and cycle time analysis.
- **Yaskawa MotoSim EG-VRC** — Full Motoman robot simulation with virtual programming pendant. We use this extensively for arc welding and [palletizing](/solutions/palletizing/) applications.

### Process & Factory Simulation

- **Siemens Tecnomatix Process Simulate** — The gold standard for complex multi-robot cell simulation. We use this for lines with 4+ robots where coordination and interference zones get complicated.
- **Visual Components** — Outstanding for full-line simulation and layout optimization. We use it to validate [material handling](/solutions/material-handling/) systems, conveyor layouts, and buffer sizing.
- **RoboDK** — Versatile cross-platform simulation that supports 500+ robot models from every major manufacturer. Great for offline programming when the project spans multiple robot brands.
- **Delmia (Dassault Systemes)** — Primarily for aerospace and defense clients who already work in the CATIA/3DEXPERIENCE ecosystem.

### PLC & Controls Simulation

- **Rockwell Studio 5000 Logix Emulate** — Virtual Allen-Bradley ControlLogix/CompactLogix controller. We validate every rung of ladder logic before it sees a real PLC.
- **Siemens PLCSIM Advanced** — S7-1500 virtual controller with full TIA Portal integration. Supports hardware-in-the-loop testing with real HMI panels.
- **Mitsubishi GX Simulator** — For projects using Mitsubishi MELSEC platforms, primarily in [electronics](/industries/electronics/) and semiconductor applications.

## Real-World Application Examples

### Automotive: 6-Station Brake Assembly Line

A Tier 1 automotive supplier needed a complete brake caliper [assembly line](/solutions/assembly/) with 6 FANUC robots, 4 servo press stations, and automated leak testing. We built the full digital twin in Tecnomatix Process Simulate connected to FANUC Roboguide for each robot.

The simulation revealed that Station 3's robot would collide with the overhead gantry during a part flip sequence — something invisible in 2D layout reviews. We redesigned the robot mounting position in simulation, revalidated cycle times (still hit the 42-second target), and avoided what would have been a $65,000 structural modification on-site. Total virtual commissioning time: 3 weeks. On-site commissioning: 8 days. The line hit rate target within 48 hours of power-on.

### Medical Device: Catheter Assembly Cell

A [medical device](/industries/medical/) manufacturer needed a Class 8 cleanroom-compatible assembly cell for catheter sub-assemblies. FDA 21 CFR Part 11 compliance meant every robot program change required documentation and validation — making on-site trial-and-error programming essentially impossible from a regulatory standpoint.

We developed the entire cell in ABB RobotStudio with validated OmniCore controller simulation. Every program was version-controlled, tested against acceptance criteria in simulation, and documented with automated cycle reports before download. The physical commissioning took 4 days — about 70% less than comparable projects we'd done before virtual commissioning became standard practice. The client passed their FDA process validation on the first attempt.

### Consumer Goods: High-Speed Packaging Line

A major consumer products company needed a [packaging](/solutions/packaging/) line running at 120 units per minute with 4 FANUC delta robots doing pick-and-place from a vision-guided conveyor. The challenge: coordinating 4 robots sharing overlapping work zones without collisions while maintaining rate.

We used Roboguide with iRPickTool simulation to model the complete line, including vision system response times, conveyor tracking delays, and robot-to-robot interference zones. The simulation let us optimize the zone allocation algorithm and predict actual throughput at 126 UPM — 5% above target. When we powered on the physical system, it ran at 122 UPM on day one and hit 127 UPM after minor tuning. Without simulation, robot zone coordination alone would have taken 2+ weeks of on-site programming.

## Our Virtual Commissioning Process

### Phase 1: Model Development (Week 1-2)

We import your mechanical CAD (SolidWorks, CATIA, NX — we work with all major formats), build kinematic models of every moving component, and define all I/O points. This isn't just dropping STEP files into a viewer. We model gripper actuation, conveyor motion profiles, servo press force curves, and sensor detection zones. Every component behaves like its physical counterpart.

### Phase 2: Program Development (Week 2-4)

This is where the real value happens. We write production-ready robot programs, PLC code, and HMI interfaces in the simulated environment. Robot paths are optimized for cycle time. PLC logic is tested against every operating mode — automatic, manual, maintenance, fault recovery. HMI screens are reviewed for operator usability.

### Phase 3: Integration Testing (Week 3-5)

We connect everything together: robot simulation talks to virtual PLC, virtual PLC drives the simulated I/O, and the complete system runs full production cycles. We test normal operation, product changeovers, fault conditions, emergency stops, and recovery sequences. We break things on purpose — because it's better to find the failure modes in simulation than on your production floor.

### Phase 4: Validation & Handoff

We generate cycle time reports, document all programs with revision history, create operator training materials from simulation recordings, and package everything for physical commissioning. Your team gets the simulation models too — they're yours to use for future product changes, [training](/services/training/), and [process optimization](/services/process-optimization/).

## Common Challenges (And How We Handle Them)

**"Our CAD data is a mess."** We deal with this constantly. Incomplete assemblies, mismatched coordinate systems, missing components. We've developed internal workflows to clean up and prepare CAD data for simulation efficiently. It adds a day or two to Phase 1 but doesn't derail the project.

**"The simulation won't match reality perfectly."** You're right — it won't. Physics simulation has limits, and real-world variation exists. But our digital twins predict cycle times within 3-5% and catch 90%+ of integration issues before physical commissioning. Perfect is the enemy of extremely useful.

**"We've never done virtual commissioning before."** Most of our clients hadn't before their first project with us. We handle the simulation work; your team participates in design reviews and validation. By the end of the project, your engineers understand the value and typically request simulation on every subsequent project.

## The Business Case: ROI You Can Defend

For a typical $500K automation project, here's what virtual commissioning delivers:

- **Simulation investment:** $25,000 - $40,000 (5-8% of project value)
- **On-site commissioning reduction:** 40-60% fewer days (save $30,000 - $75,000 in labor and travel)
- **Rework elimination:** 80-90% fewer on-site modifications (save $20,000 - $100,000)
- **Faster production ramp:** 2-4 weeks earlier to full rate (value depends on your margins, but it's often the biggest number)
- **Typical net ROI:** 3:1 to 5:1 within the first project

For [automotive](/industries/automotive/) programs with hard SOP dates and late-launch penalties, the risk mitigation alone justifies the investment. For [medical](/industries/medical/) and [pharmaceutical](/industries/pharmaceutical/) projects with validation requirements, simulation documentation directly supports regulatory submissions.

## Frequently Asked Questions

### How accurate are digital twin cycle time predictions?

For robot-dominant cells, we consistently achieve 3-5% accuracy compared to physical production. The main variables are real-world settling times, sensor response delays, and part variation — things we account for with conservative allowances in simulation. We've never missed a cycle time target on a project that included full virtual commissioning.

### Can we use the digital twin after the system is installed?

Absolutely, and you should. We deliver simulation models in formats your team can use for offline robot programming, operator [training](/services/training/), and future product changeovers. Some clients connect their digital twins to live production data via OPC-UA for real-time monitoring and predictive maintenance — that's the full Industry 4.0 digital twin vision.

### What if we only have FANUC robots — do we still need Tecnomatix?

Not necessarily. For single-robot cells or simple multi-robot setups, FANUC Roboguide handles everything you need. We recommend Tecnomatix or Visual Components when you have 4+ robots, complex material flow, or need to simulate non-robot equipment (conveyors, indexers, servo systems) with high fidelity.

### How does virtual commissioning work with safety system validation?

We simulate safety PLCs (Rockwell GuardLogix, Siemens F-CPU) alongside standard controls. Safety zone monitoring, light curtain response, e-stop circuits, and safety-rated monitored stop functions are all validated in simulation. This doesn't replace physical safety validation — you still need to verify hard-wired safety circuits and do final risk assessment on the physical system — but it eliminates the logic-level safety bugs that commonly delay commissioning.

### What file formats do you need from our engineering team?

We work with STEP, IGES, Parasolid, SolidWorks native (.sldasm/.sldprt), CATIA V5, NX, and Creo formats. We prefer native CAD files when possible because they preserve feature trees and assembly constraints. If your CAD is parametric, we can even simulate design changes (fixture adjustments, gripper jaw swaps) directly in the digital twin.

### Do you support hardware-in-the-loop (HIL) testing?

Yes. For critical projects, we connect real PLC hardware and HMI panels to the simulated plant model. The physical controller runs actual production code while the digital twin simulates the mechanical system. This is the highest-fidelity validation method available and is particularly valuable for [aerospace](/industries/aerospace/) and defense programs with strict verification requirements.

### How do digital twins support continuous improvement after launch?

Once your system is running, the digital twin becomes a sandbox for testing improvements without risking production. Want to try a new robot path to save 2 seconds per cycle? Test it in simulation first. Considering a product design change that affects fixturing? Validate the impact virtually. Planning a line rebalance? Simulate the new layout before moving a single piece of equipment. Our [process optimization](/services/process-optimization/) services leverage digital twins as a core tool for ongoing improvement.

---

**Ready to see what virtual commissioning can do for your next project?** We'll build a proof-of-concept digital twin for one of your existing cells or an upcoming project — no obligation, just a demonstration of what the technology delivers. [Contact our simulation engineering team](/contact/) to get started.
