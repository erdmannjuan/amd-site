---
title: Servo Motor Sizing and Selection Guide
description: A practical engineering guide to sizing and selecting servo motors for industrial
  automation, covering torque calculations, inertia matching, duty cycles, and common mistakes.
keywords: servo motor sizing, servo selection guide, torque calculation, inertia ratio,
  servo drive selection, motion control, servo motor for automation, RMS torque
date: '2024-11-22'
author: AMD Machines Team
category: Guides
read_time: 8
template: blog-post.html
url: /blog/servo-motor-sizing-and-selection-guide/
---

## Why Proper Servo Sizing Matters

An undersized servo motor stalls under load, faults out during acceleration, and shuts down your production line. An oversized servo motor wastes capital, takes up unnecessary panel space, draws more power than needed, and can actually make motion control harder because the inertia mismatch between a large motor and a small load degrades tuning performance.

Getting servo sizing right is not optional — it is foundational to every axis of motion in an automated system. Whether you are designing a rotary indexing table, a linear press station, a pick-and-place mechanism, or a [robotic welding positioner](/solutions/robotic-welding/), the servo motor and drive must be matched to the mechanical load with enough margin for real-world conditions but not so much margin that you are paying for capacity you will never use.

This guide walks through the engineering fundamentals we apply on every motion axis we design.

## Step 1: Define the Motion Profile

Before you open a motor catalog, you need to define exactly what the axis must do. The motion profile specifies position, velocity, and acceleration as functions of time. A typical point-to-point move has three phases:

- **Acceleration** — ramp from zero to target speed
- **Constant velocity** — cruise at target speed (may be zero duration for short moves)
- **Deceleration** — ramp from target speed to zero

For each move, you need to know:

- **Travel distance** — how far the load moves (degrees of rotation or millimeters of linear travel)
- **Move time** — the total time allowed for the move
- **Dwell time** — any pause between moves
- **Cycle time** — the total repeating period

From these parameters, you can calculate peak velocity and peak acceleration. A trapezoidal motion profile with equal accel and decel times is the most common starting point. An S-curve profile reduces mechanical shock but requires slightly higher peak acceleration for the same move time.

For example, a rotary indexer that must rotate 90 degrees in 0.5 seconds with a 0.3-second dwell has a cycle time of 0.8 seconds. Using a trapezoidal profile with 30% of the move time allocated to acceleration and 30% to deceleration, you can calculate the peak angular velocity and acceleration directly.

## Step 2: Calculate Load Inertia

Inertia is the rotational equivalent of mass. It determines how much torque is needed to accelerate and decelerate the load. Every component in the mechanical drivetrain contributes inertia — the load itself, the coupling, the gearbox, the belt and pulley, the ballscrew, and the motor rotor.

For common mechanical elements:

- **Solid cylinder rotating about its axis**: J = ½ m r²
- **Hollow cylinder**: J = ½ m (r_outer² + r_inner²)
- **Point mass at radius r**: J = m r²
- **Linear mass on a ballscrew**: J_reflected = m × (lead / 2π)²

The critical concept is reflected inertia. A 50 kg linear load on a ballscrew with a 10 mm lead reflects very little inertia back to the motor. The same 50 kg load on a 50 mm lead ballscrew reflects 25 times more inertia. Gear ratios also transform inertia by the square of the ratio — a 10:1 gearbox reduces reflected load inertia by a factor of 100.

Add up all the reflected inertia components at the motor shaft. This total load inertia is what the motor must accelerate and decelerate on every cycle.

## Step 3: Calculate Required Torque

There are three torque components to account for:

**Acceleration torque** — the torque required to accelerate the total inertia (motor rotor plus reflected load) at the required angular acceleration:

T_accel = J_total × α

Where J_total is the sum of motor inertia and load inertia, and α is angular acceleration in rad/s².

**Friction torque** — the continuous torque needed to overcome mechanical friction in bearings, seals, guides, and the drivetrain. This is often estimated as a percentage of the gravitational load or measured from the existing machine.

**Gravity torque** — for vertical or inclined axes, the torque required to hold or move the load against gravity. This is a constant load component that does not depend on acceleration.

The total required torque at any point in the motion profile is the sum of these three components. During acceleration, all three are additive. During constant velocity, only friction and gravity torques apply. During deceleration, acceleration torque acts in the opposite direction, partially offsetting friction and gravity.

## Step 4: Calculate RMS Torque

The peak torque during acceleration tells you what the motor must be capable of delivering instantaneously, but it does not tell you whether the motor can sustain that duty cycle thermally. That is where RMS (root mean square) torque comes in.

RMS torque accounts for the heating effect of the entire motion cycle:

T_rms = √[(T₁² × t₁ + T₂² × t₂ + T₃² × t₃ + ...) / t_cycle]

Where T₁, T₂, T₃ are the torque values during each phase of the cycle and t₁, t₂, t₃ are the corresponding durations.

The selected motor's continuous (rated) torque must exceed the calculated RMS torque. The motor's peak torque must exceed the maximum instantaneous torque during the cycle. Most servo motors can deliver 2 to 3 times their continuous torque for short durations, but check the manufacturer's torque-speed curve for the specific operating point.

## Step 5: Check the Inertia Ratio

The inertia ratio — reflected load inertia divided by motor rotor inertia — is one of the most important and most frequently overlooked parameters in servo sizing. A high inertia ratio means the load dominates the system dynamics, making the servo loop harder to tune and more sensitive to disturbances.

General guidelines:

- **1:1 to 3:1** — Ideal range for high-performance applications requiring fast settling and tight position accuracy
- **3:1 to 10:1** — Acceptable for many industrial applications with moderate dynamic requirements
- **Above 10:1** — Requires careful tuning, lower servo bandwidth, and may produce unacceptable settling behavior

If the inertia ratio is too high, you have several options: add a gearbox to reduce reflected inertia, select a motor with higher rotor inertia, or redesign the mechanical drivetrain to reduce load inertia. A planetary gearbox with a 5:1 ratio reduces reflected inertia by 25:1, which can transform a marginal axis into a well-behaved one.

## Step 6: Select the Motor and Drive

With the required continuous torque, peak torque, speed, and inertia ratio defined, you can select from the manufacturer's catalog. Key specifications to compare:

- **Continuous stall torque** (must exceed RMS torque)
- **Peak torque** (must exceed maximum instantaneous torque)
- **Rated speed** (must exceed maximum required speed)
- **Rotor inertia** (determines inertia ratio)
- **Motor frame size** (must fit the mechanical design)
- **Feedback type** (incremental encoder, absolute encoder, resolver)
- **Brake option** (required for vertical axes or safety holding)

The servo drive must match the motor and provide sufficient current for the required torque at the required speed. Verify that the drive's continuous and peak current ratings exceed the motor's requirements. Also confirm the drive's bus voltage is compatible with your facility's power supply and that the [control architecture](/solutions/controls-engineering/) supports your communication protocol — EtherCAT, PROFINET, EtherNet/IP, or others.

## Common Sizing Mistakes

**Ignoring friction and gravity.** Sizing based only on acceleration torque produces an undersized motor that faults under continuous operation. Always account for real-world friction, especially on linear axes with wipers and seals.

**Using peak torque as continuous torque.** A motor rated for 10 Nm continuous and 30 Nm peak cannot run at 25 Nm continuously, even though it is below the peak spec. The motor will overheat and fault.

**Neglecting cable losses.** Long cable runs between the drive and motor introduce resistance that reduces available torque at the motor. For cable lengths over 20 meters, verify the voltage drop and consider upsizing the cable or the drive.

**Forgetting about the duty cycle.** A machine that runs 10 moves per minute during testing but 60 moves per minute in production has a completely different thermal profile. Always size for the actual production duty cycle.

**Oversizing by too much.** A motor that is 3 to 4 times larger than needed creates a poor inertia ratio (the motor rotor inertia may dominate the load), increases cost, and takes up space in the [machine design](/solutions/automated-assembly/) that could be used for other components.

## Practical Recommendations

Start with the mechanical design. The motor selection should follow from the load requirements, not the other way around. Define your motion profile, calculate your loads, and let the numbers drive the motor selection.

Use manufacturer sizing tools. Every major servo manufacturer — Allen-Bradley, Siemens, Bosch Rexroth, Mitsubishi, Yaskawa — provides sizing software that automates the calculations and recommends motor-drive combinations. These tools are accurate and save time, but you should understand the underlying calculations well enough to verify the results.

Build in margin, but not too much. A 20% to 30% torque margin above the calculated RMS torque covers manufacturing tolerances, friction changes over time, and minor load variations. More than that usually means you are oversizing.

Prototype and validate. Run the actual motion profile on the physical machine and measure motor current, temperature rise, and settling behavior. The real world always has surprises — a coupling that is stiffer than modeled, a bearing preload that adds friction, a cable run that was longer than planned. Validating on the machine confirms your calculations and catches errors before production ramp-up.

## How AMD Machines Approaches Servo Sizing

Every [custom automation system](/solutions/automated-assembly/) we build includes detailed servo sizing calculations for every motion axis. Our mechanical and controls engineers work together from the concept phase to match motor, gearbox, and drivetrain components to the actual production requirements. We validate sizing with simulation tools during design and confirm performance during commissioning with measured torque and speed data.

If you are planning a new automated system or upgrading motion axes on existing equipment, [contact our engineering team](/contact/) to discuss your application requirements.
