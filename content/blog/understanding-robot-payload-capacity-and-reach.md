---
title: Understanding Robot Payload Capacity and Reach
description: 'Learn how robot payload capacity and reach specs actually work, why rated payload isn''t the whole story, and how to size robots correctly for your application.'
keywords: robot payload capacity, robot reach, robot selection, robot specifications, industrial robot sizing, payload vs reach tradeoff, wrist payload, robot moment load
date: '2026-01-16'
author: AMD Machines Team
category: Robotics
read_time: 5
template: blog-post.html
url: /blog/understanding-robot-payload-capacity-and-reach/
---

## Why Payload and Reach Are the First Specs You Check

When you're sizing a robot for a new application, payload capacity and reach are the two numbers everyone looks at first. And for good reason — get either one wrong and you're either buying a robot that can't do the job or spending $30,000 more than you needed to.

But here's the thing: those headline specs on a datasheet don't tell the whole story. A FANUC M-20iD/25 is rated at 25 kg payload with a 1,831 mm reach. But mount a heavy gripper on the wrist, extend the arm fully, and run it at max speed? You won't get anywhere near that 25 kg in practice. Understanding why — and how to properly size a robot — saves time, money, and a lot of headaches during integration.

## Payload Capacity: More Than a Single Number

The rated payload on a spec sheet is the maximum mass the robot can handle at its wrist flange. It includes everything attached to the J6 flange: the end effector, any adaptor plates, cabling, and the workpiece itself.

Here's where it gets tricky. Most robots also spec **moment and inertia loads** at the wrist. These are rotational forces that depend on the center of gravity of whatever you've mounted. A compact 10 kg part centered on the flange puts far less stress on J5 and J6 than a 10 kg part cantilevered 300 mm off-center.

Take a typical [assembly application](/solutions/assembly/). You might have a dual-gripper with pneumatic actuators, sensor cables, and a tool changer plate. That tooling package easily weighs 5-8 kg before you ever pick up a part. If you're handling 4 kg parts, your total wrist load is 9-12 kg — and now that "15 kg rated" robot is running at 60-80% of its capacity.

**Practical rule of thumb:** aim for a robot with a rated payload at least 25-30% higher than your total wrist load (tooling + part). This gives you margin for speed, acceleration, and the occasional heavier variant.

### What Happens When You Exceed Payload

Running a robot over its rated payload doesn't always fail dramatically. What you'll typically see:

- **Path accuracy degrades.** The arm drifts off the programmed path, especially at higher speeds. For [machine vision](/solutions/machine-vision/) applications where placement accuracy matters, this is a killer.
- **Servo alarms increase.** The motors work harder to hold position, triggering overcurrent faults. You'll see intermittent J4, J5, or J6 alarms that are maddening to troubleshoot.
- **Reducer life shortens.** This is the expensive one. Overloading accelerates wear on the harmonic drives and RV reducers in the wrist joints. A reducer replacement on a 6-axis robot can run $8,000-$15,000 in parts and labor.
- **Cycle time suffers.** The controller automatically limits speed and acceleration when it detects loads approaching the limits. Your 12-second cycle becomes 16 seconds and nobody can figure out why.

## Reach: It's Not Just About Distance

Robot reach is typically specified as the maximum distance from the J1 axis (base) to the J6 flange center. But effective working range depends on the specific positions you need to hit.

Every robot has a **work envelope** — the 3D space it can access. And within that envelope, there are dead zones. Most 6-axis robots can't reach directly below themselves. They also have limited access very close to the base (the inner reach radius). A robot with 1,400 mm max reach might have a 400 mm inner radius, meaning it can't access anything within a 400 mm circle around its base.

This matters a lot for [machine tending](/solutions/machine-tending/) cells. You need the robot to reach into a CNC chuck, pick from an infeed conveyor, and place onto an outfeed — all from a single base position. Plot those points in 3D and verify they're all within the reachable envelope, accounting for the approach angles you need.

### Mounting Position Changes Everything

How you mount the robot dramatically affects its usable reach:

- **Floor mount** is the default. Simple, stable, and gives the most natural work envelope.
- **Pedestal mount** raises the robot, extending the effective reach downward and outward. Common in palletizing cells where the robot needs to reach across a pallet and stack high.
- **Inversion (ceiling) mount** opens up floor space and changes the envelope geometry. FANUC, ABB, and KUKA all offer models that support inversion. It's common in [automotive welding cells](/case-studies/automotive-welding-cell/) where floor space is at a premium.
- **Wall/shelf mount** (at an angle) is used less often but works well for certain tending applications where the robot needs to face the machine tool.

A robot mounted on a 500 mm pedestal effectively gains 500 mm of downward reach without needing a larger (more expensive) model.

## The Payload-Reach Tradeoff

Here's something the datasheets don't always make obvious: payload capacity often varies with reach. Many manufacturers publish a **payload-reach curve** showing that the robot can handle its maximum rated payload only within a reduced working radius.

For example, a robot rated at 25 kg might only hit that spec within 1,200 mm of the base. At full extension (1,800 mm), the allowable payload drops to 18-20 kg. The physics are straightforward — a longer moment arm means more torque on the base and shoulder joints.

ABB's IRB 6700 series is a good example. The IRB 6700-200/2.60 handles 200 kg at 2,600 mm reach, but that 200 kg is only at specific arm configurations. At full extension overhead, you're looking at significantly reduced capacity. Always check the actual load diagrams, not just the headline spec.

## How to Size a Robot Correctly

After three decades of building custom automation, here's the process we use:

**1. Define all wrist loads.** Weigh your end effector concept (or estimate it — pneumatic grippers are typically 2-5 kg, servo grippers 4-10 kg, tool changers add 1-3 kg). Add the maximum part weight. Don't forget cables and hoses routed along the arm.

**2. Map every position the robot needs to reach.** Not just the pick and place points — include the approach and retreat vectors. If the robot needs to reach 1,200 mm to the pick point but approaches at a 45° angle, the actual arm extension is different.

**3. Check moment and inertia loads.** Use the manufacturer's load calculation software (FANUC's ROBOGUIDE, ABB's RobotStudio, or KUKA.Sim all include payload verification tools). Input your tooling geometry and CoG location. The software will flag if you're exceeding any joint limits.

**4. Simulate at production speed.** Static payload checks don't account for dynamic forces during acceleration. A part that's fine at 50% speed might overload the wrist at 100%. Run the actual motion profile and verify.

**5. Leave margin.** We typically spec robots to run at no more than 70-80% of rated payload in production. That margin accounts for tooling modifications, product changes, and the inevitable "can we make it go a little faster?" request from production six months after install.

If you're wrestling with robot selection for an upcoming project, [reach out to our engineering team](/contact/). Getting the payload and reach right at the specification stage prevents expensive changes later.
