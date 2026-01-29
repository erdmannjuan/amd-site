---
title: Robot Maintenance Best Practices for Maximum Uptime
description: 'Practical robot maintenance strategies covering daily checks, PM schedules, grease management, and spare parts planning to maximize uptime above 95%.'
keywords: robot maintenance, preventive maintenance, robot uptime, robot grease, PM schedule, robot calibration, predictive maintenance, spare parts inventory
date: '2026-01-04'
author: AMD Machines Team
category: Robotics
read_time: 5
template: blog-post.html
url: /blog/robot-maintenance-best-practices-for-maximum-uptime/
---

## Why Robot Maintenance Gets Ignored (Until It's Too Late)

Here's a pattern we've seen dozens of times: a manufacturer installs a shiny new FANUC or ABB robot, runs it flat out for 18 months, and then wonders why it's suddenly throwing fault codes at 2 AM on a Tuesday. The truth is, industrial robots are remarkably reliable machines — but they're not magic. Skip the maintenance, and you'll pay for it in unplanned downtime, scrap parts, and emergency service calls that cost 3-5x what a scheduled visit would.

The good news? A solid preventive maintenance program isn't complicated. It just requires discipline. Most facilities that follow the practices below sustain 95%+ uptime on their robotic cells. Those that don't? They're typically hovering around 80-85%, which translates to hundreds of lost production hours per year.

## Daily and Weekly Checks That Actually Matter

Not all maintenance tasks are equal. Some daily checks take five minutes and catch problems before they become catastrophes. Here's what your operators should be doing at the start of every shift:

**Daily (5 minutes):**
- Visual inspection of cables and dress packs for wear, especially at J3 and J6 where flex is greatest
- Listen for unusual sounds during warmup — grinding or clicking at a joint usually means bearing wear
- Check teach pendant for error logs or warnings that cleared overnight
- Verify air pressure on pneumatic end effectors (should be within ±0.5 bar of setpoint)

**Weekly (30 minutes):**
- Inspect all cable connectors for looseness — vibration works them free over time
- Clean vision system lenses and light sources (a dirty lens is the #1 cause of false rejects in [machine vision](/solutions/machine-vision/) applications)
- Check coolant levels on any spindle-equipped tools
- Verify backup battery voltage on the controller (below 3.2V means replace immediately — lose this battery and you lose all position data)

That backup battery point is worth emphasizing. On older FANUC controllers, the battery keeps the encoder positions stored when the robot is powered off. If it dies, you'll need to re-master every axis. That's a 2-4 hour job with a technician, and if it happens mid-production, you're looking at significant lost output.

## Building a PM Schedule That Works

Every robot manufacturer publishes recommended maintenance intervals. Follow them. But also understand that your environment matters more than the manual assumes. A robot in a clean electronics assembly room needs less frequent attention than one running in a foundry with metal dust and heat.

Here's a practical PM framework based on operating hours:

**Every 3,850 hours (~6 months at two shifts):**
- Grease all axes per manufacturer specs (more on this below)
- Inspect all reducers for play — use a dial indicator at the tool flange
- Check and replace air filters on the controller cabinet
- Tighten all mounting bolts to spec
- Run a full mastering check and recalibrate if drift exceeds ±0.1mm

**Every 7,700 hours (~12 months at two shifts):**
- Replace dress pack cables if wear is visible or impedance testing shows degradation
- Full electrical inspection of the controller — capacitors, fans, contactors
- Replace the teach pendant membrane if buttons feel mushy
- Battery replacement (don't wait for the warning)
- Run a cycle time audit against baseline — slowdown often indicates mechanical wear

**Every 15,000+ hours:**
- Reducer replacement on high-load axes (J1, J2, J3)
- Full cable harness replacement inside the arm
- Consider [maintenance support contracts](/services/maintenance-support/) for these major overhauls

## Grease Management: The Single Biggest Maintenance Mistake

If there's one thing that separates well-maintained robots from beaten-up ones, it's grease management. And most facilities get it wrong in one of two ways: they either skip greasing entirely or they over-grease.

Over-greasing is surprisingly common and almost as damaging as under-greasing. Excess grease builds hydraulic pressure inside the gearbox, blows past seals, and ends up dripping onto parts or contaminating your workspace. On a KUKA KR series, we've seen over-greased J4 reducers push grease out through the seal and directly onto product below — a contamination nightmare in [medical device assembly](/case-studies/medical-device-assembly/).

The right approach:
- **Use the exact grease specified** by the manufacturer. FANUC robots typically require Moly White RE00 or equivalent. Mixing grease types causes chemical breakdown.
- **Pump slowly.** You're replacing old grease, not pressurizing a hydraulic system. One pump every 5 seconds.
- **Always open the purge port** on the opposite side before pumping. This lets old grease exit instead of building pressure.
- **Track grease volumes.** Know exactly how many pumps each axis needs (it's in the manual) and don't exceed it.
- **Watch what comes out.** Healthy grease comes out the same color it went in. Black or metallic-flecked grease means internal wear — schedule an inspection.

## Spare Parts: What to Stock and What to Skip

Keeping the right spare parts on hand is the difference between a 30-minute repair and a week of downtime waiting for overseas shipping. But you don't need to stock everything — just the parts that fail most often and have the longest lead times.

**Always keep on-site:**
- Backup batteries (2 per robot minimum)
- Teach pendant cable (these get snagged and damaged constantly)
- Fuses for the controller power supply
- Spare I/O cards (one of each type installed)
- Dress pack cable sets for your most critical cells
- Pneumatic fittings, solenoid valves, and cylinders for end effectors
- Common sensors: proximity switches, photoelectric sensors

**Order when needed (keep vendor relationships warm):**
- Servo motors (lead time: 2-6 weeks depending on model)
- Reducers/gearboxes (lead time: 4-12 weeks — this is the scary one)
- Controller boards (lead time varies wildly; keep one for older models going out of support)

For critical production cells, consider stocking a spare servo motor for the most-loaded axis. A J2 motor on a palletizing robot takes the most abuse, and having one on the shelf can save a week of downtime. That $3,000-$5,000 motor pays for itself the first time you need it.

## When to Move Beyond Preventive to Predictive

Traditional PM is time-based: change the grease every 3,850 hours whether it needs it or not. Predictive maintenance flips that model by monitoring actual condition data — vibration signatures, motor current draw, temperature trends — and alerting you before failure happens.

Modern robot controllers from FANUC (ZDT), ABB (ABB Ability), and KUKA (KUKA Connect) all offer built-in condition monitoring. These systems track servo torque and vibration patterns over time and flag deviations that indicate developing problems. It's not a replacement for hands-on PM, but it catches things human inspection misses — like a reducer that's slowly degrading inside a sealed housing.

The ROI case is straightforward. If you're running 10+ robots across multiple cells, predictive monitoring typically pays back within 12 months by preventing even one or two unplanned failures per year. For smaller operations, sticking with disciplined preventive maintenance and good operator awareness is usually sufficient.

Bottom line: robots are tough machines, but they need care. Build the habits, track the hours, and don't skip the grease. Need help setting up a maintenance program or troubleshooting recurring issues? [Reach out to our team](/contact/) — we've kept thousands of robots running over three decades.
