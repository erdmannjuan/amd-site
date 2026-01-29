---
title: Conveyor Drive Selection and Sizing
description: How to calculate motor, gearbox, and drive requirements for industrial
  conveyor systems including torque calculations, speed ratios, and service factors.
keywords: conveyor drive sizing, conveyor motor selection, gearbox sizing, conveyor
  torque calculation, belt conveyor drive, material handling automation
date: '2024-11-02'
author: AMD Machines Team
category: Guides
read_time: 7
template: blog-post.html
url: /blog/conveyor-drive-selection-and-sizing/
---

## Why Drive Selection Matters

An undersized conveyor drive stalls under load. An oversized one wastes capital and energy while adding unnecessary weight to the structure. Getting drive selection right means the conveyor runs reliably at the required throughput without paying for capacity you will never use.

Drive selection involves matching a motor, gearbox, and drive controller to the mechanical demands of the conveyor. The process is straightforward if you work through it methodically, but shortcuts here lead to nuisance trips, premature wear, and expensive redesigns after installation.

## Understanding the Load

Every drive sizing exercise starts with the load. For a conveyor, the total load breaks down into several components:

**Product load** is the weight of material on the conveyor at any given time. For a belt conveyor running at 30 feet per minute carrying 50-pound assemblies spaced 3 feet apart, you might have 10 parts on a 30-foot conveyor at once — 500 pounds of product load.

**Belt or chain weight** is the dead load of the conveying medium itself. A modular plastic belt might weigh 3 to 5 pounds per linear foot. Over a 30-foot conveyor, that adds 90 to 150 pounds that the drive must move continuously.

**Friction losses** come from bearings, slider beds, return-side sag, and any guides or rails the belt contacts. Friction coefficients vary: roller-supported belts might see coefficients around 0.03, while slider-bed conveyors with UHMW wear strips run closer to 0.15 to 0.25 depending on loading and temperature.

**Incline or decline forces** add a gravity component. A 10-degree incline on a conveyor carrying 500 pounds of product adds roughly 87 pounds of force that the drive must overcome (500 × sin 10°). Decline conveyors can actually drive the motor, creating a regenerative condition the drive must handle.

**Acceleration forces** matter during startup or speed changes. A conveyor that must accelerate a full load from zero to running speed in 2 seconds requires significantly more torque than steady-state operation. This is where many engineers undersize — they calculate steady-state torque and forget the startup transient.

## Torque Calculation

Once you know the total force required at the drive pulley or sprocket, converting to torque is straightforward:

Torque (lb-in) = Force (lb) × Drive radius (in)

For a belt conveyor with a 6-inch diameter drive pulley, the radius is 3 inches. If the total belt pull is 200 pounds at steady state, the required torque at the drive shaft is 600 lb-in.

But you are not done. Apply a service factor — typically 1.5 for normal duty, 2.0 for heavy or shock-loaded applications. That 600 lb-in becomes 900 lb-in with a 1.5 service factor. This accounts for load variations, friction changes as components wear, and the reality that calculated values never perfectly match field conditions.

## Motor Selection

With the required torque and speed known, you can select a motor. The key specifications are:

**Speed** — Conveyor speeds in manufacturing typically range from 10 to 120 feet per minute. The motor speed (usually 1750 RPM for a standard 4-pole AC motor) must be reduced through the gearbox to achieve the target conveyor speed.

**Horsepower** — Calculate from torque and speed: HP = (Torque × RPM) / 63,025. A drive shaft running at 50 RPM with 900 lb-in of torque requires about 0.71 HP. You would select a 1 HP motor as the next standard size.

**Motor type** matters for the application. Three-phase AC induction motors with variable frequency drives (VFDs) are the standard choice for most manufacturing conveyors. They provide adjustable speed, soft start capability, and regenerative braking on declines. For precise positioning — indexing conveyors, for example — servo motors offer the control resolution needed to hit repeatable stop positions within thousandths of an inch. Our [servo motor sizing guide](/blog/servo-motor-sizing-and-selection-guide/) covers that selection process in detail.

**Duty cycle** affects motor thermal capacity. A conveyor running continuously at full load is a different thermal problem than one that indexes on and off every 30 seconds. Intermittent duty can allow a smaller motor frame if the thermal cycling stays within the motor's insulation class rating.

## Gearbox Selection

The gearbox bridges the gap between motor speed and conveyor speed. Key considerations include:

**Gear ratio** — A 1750 RPM motor driving a conveyor at 50 RPM at the drive shaft requires a 35:1 ratio. Standard worm, helical, or planetary gearboxes are available in discrete ratios, so you select the closest available ratio and adjust the VFD frequency to fine-tune the output speed.

**Gearbox type** affects efficiency and cost. Helical gearboxes run 95-98% efficient per stage and handle high torques well. Worm gearboxes are compact and self-locking (useful for incline conveyors that must not back-drive) but drop to 50-90% efficiency depending on the ratio. Planetary gearboxes offer high torque density in a compact package and are common in servo-driven applications.

**Mounting configuration** — Right-angle, inline, and shaft-mounted options each suit different layouts. Shaft-mounted gearboxes eliminate the coupling and base plate, reducing alignment issues and installation time. This is a common choice for belt conveyors where the gearbox mounts directly on the drive shaft.

**Output torque rating** must exceed your calculated requirement including service factor. Check both the continuous torque rating and the momentary or peak torque rating. Startup loads and jam conditions can momentarily demand 2 to 3 times the steady-state torque.

## Drive Controller Considerations

The VFD or servo drive completes the system. Beyond basic speed control, consider:

**Acceleration and deceleration ramps** protect the mechanical system and the product. A conveyor carrying glass bottles needs gentle ramps to prevent tipping. A conveyor feeding a robotic cell might need rapid acceleration to minimize index time. Typical ramp times range from 0.5 to 5 seconds depending on the application.

**Braking** — Dynamic braking (dissipating energy through a resistor) or regenerative braking (feeding energy back to the bus) handles deceleration and holding loads on inclines. Mechanical brakes provide a fail-safe hold when power is removed, which is essential on any inclined conveyor carrying product.

**Communication protocols** — The drive must integrate with the line's control system. Most modern VFDs support EtherNet/IP, PROFINET, or EtherCAT. Match the protocol to your PLC platform to simplify commissioning and diagnostics. Our overview of [industrial ethernet protocols](/blog/understanding-industrial-ethernet-protocols/) covers the tradeoffs between these options.

**Overload protection** — Configure the drive's overcurrent trip point to protect the motor and mechanical components. Set it high enough to handle normal startup transients but low enough to prevent damage from a jam condition.

## Common Sizing Mistakes

Having commissioned hundreds of conveyor systems, we see the same mistakes repeatedly:

**Ignoring startup torque.** Steady-state calculations look fine on paper, but the conveyor trips on overcurrent every time it starts with a full load. Always calculate the torque required to accelerate the full mass from rest.

**Using the wrong friction coefficient.** A clean, new slider bed has a lower friction coefficient than one with six months of dust, adhesive residue, or product debris on it. Use field-realistic values, not laboratory numbers.

**Forgetting the return side.** On long conveyors, the weight and friction of the return-side belt is not trivial. A 100-foot belt conveyor with a heavy-duty modular belt can have 300+ pounds of belt on the return side contributing to the total drive load.

**Oversizing as insurance.** A motor that is dramatically oversized costs more upfront, draws more reactive power, and requires a larger drive. It also produces more torque during a jam, potentially damaging the conveyor structure or product. Size correctly and use the service factor — that is what it is for.

**Neglecting thermal conditions.** A VFD in a 120°F enclosure next to a welding cell derate significantly. Motor cooling is reduced at low speeds when the fan is turning slowly. If the conveyor spends most of its time at 20% speed, consider a motor with forced cooling or select the next frame size up.

## Integration With the Overall System

A conveyor does not operate in isolation. It feeds workstations, buffers product between processes, and synchronizes with upstream and downstream equipment. The drive selection must account for these interactions.

For accumulation conveyors that must stop and start zones independently, each zone needs its own drive sized for the zone's load — not the entire conveyor's load. Our article on [buffer and accumulation conveyor design](/blog/buffer-and-accumulation-conveyor-design/) discusses zone control strategies in detail.

For conveyors that must synchronize with robotic pick stations or automated assembly equipment, the drive's speed accuracy and response time become critical. A standard VFD holds speed within about 1% of setpoint. Closed-loop vector drives with encoder feedback hold within 0.01%. Servo drives provide the tightest control for applications requiring precise positioning or electronic gearing.

## A Practical Approach

When we size conveyor drives for clients, we follow a consistent process:

1. Define the conveyor layout, length, width, incline, and speed requirement
2. Calculate all load components — product, belt, friction, gravity, acceleration
3. Sum forces and convert to torque at the drive shaft
4. Apply the appropriate service factor
5. Select a motor, gearbox, and drive that meet the torque and speed requirements
6. Verify thermal, duty cycle, and environmental suitability
7. Confirm integration requirements with the control system

This process prevents the guesswork and rule-of-thumb sizing that leads to problems during commissioning. Conveyors are deceptively simple — the mechanical concept is straightforward, but the details of drive selection determine whether the system runs reliably for years or becomes a chronic maintenance headache.

## Partner With AMD Machines

AMD Machines designs and builds conveyor systems as part of complete [material handling solutions](/solutions/material-handling/) for manufacturing. Our engineers size every drive from first principles, validated against decades of field data from over 2,500 machines delivered. [Contact us](/contact/) to discuss your conveyor requirements.
