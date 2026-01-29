---
title: Humanoid Robots Progress Toward Factory Deployment
description: "Humanoid robots from Figure, Tesla, Agility, and others are entering factory pilots. An engineer's honest look at where they work, where they don't, and what it means for automation."
keywords: humanoid robots manufacturing, Figure 02, Tesla Optimus, Agility Digit, factory robots, humanoid factory deployment, industrial humanoid robots
date: '2025-02-28'
author: AMD Machines News Desk
category: News
read_time: 5
template: blog-post.html
url: /blog/humanoid-robots-progress-toward-factory-deployment/
---

Every few months, a new video drops showing a humanoid robot doing something impressive in a factory setting — picking parts, loading machines, walking between workstations. Figure, Tesla, Agility Robotics, Apptronik, and a half-dozen other companies are racing to put bipedal (or near-bipedal) robots on production floors. The question that keeps coming up from manufacturers is simple: should I care about this yet?

The honest answer, from an automation engineering perspective: it depends on your timeline. If you're planning projects for 2025-2026, humanoid robots aren't a factor. If you're thinking about 2028 and beyond, they're worth watching closely.

## Where Humanoid Robots Are Actually Being Tested

Let's separate the demo videos from reality. As of early 2025, here's where humanoid robots are actually running in factory environments (not labs, not controlled demos):

**Figure's Figure 02** is operating at a BMW manufacturing facility in Spartanburg, South Carolina. The robots are performing material handling tasks — moving parts bins between staging areas and assembly stations. It's a constrained use case: known environment, repetitive paths, lightweight payloads. But it's real production, not a proof of concept.

**Agility Robotics' Digit** has been deployed at Amazon fulfillment centers for tote handling. Digit picks up and moves plastic totes within a structured warehouse environment. Amazon has ordered a significant number of units, though exact deployment numbers aren't public.

**Tesla's Optimus** is being used internally at Tesla's Fremont factory for simple logistics tasks. Tesla has been characteristically bold with their claims, but the actual deployed applications are basic material transport within the facility.

**Apptronik's Apollo** is in pilot programs with Mercedes-Benz, handling ergonomically challenging material placement tasks on assembly lines.

Notice a pattern? Every real deployment is material handling. Nobody is running a humanoid robot on an [assembly](/solutions/assembly/) operation, welding cell, or machine tending station. That tells you something important about where the technology actually is.

## Why Material Handling First

There's a good engineering reason why every humanoid deployment starts with material handling: it's the most forgiving application.

In material handling, cycle time tolerances are loose (seconds, not milliseconds). Part precision requirements are low — you're moving a bin from point A to point B, not inserting a connector at ±0.05mm. The consequences of failure are minimal — a dropped tote delays a task by a few seconds. And the environments can be structured to accommodate the robot's limitations.

Compare that to a task like [machine tending](/solutions/machine-tending/), where the robot needs to open a CNC door, reach into a chuck, handle a hot part with precise orientation, and place it in a fixture — all within a 45-second cycle time. The dexterity, precision, and reliability requirements are orders of magnitude higher. Current humanoid robots can't touch that.

Or consider assembly operations. A typical [robotic cell](/solutions/robotic-cells/) for automotive assembly involves torque-controlled fastening at specific angles, force-sensitive snap-fit insertions, and vision-guided part alignment at sub-millimeter accuracy. A FANUC or ABB 6-axis arm does this reliably for 80,000+ hours between failures. Humanoid robots aren't anywhere close to that reliability.

## The Real Advantages of Humanoid Form Factor

So why bother with humanoid robots at all? Why not just deploy more traditional industrial robots and AMRs?

The pitch — and it's a legitimate one — is flexibility. A humanoid robot can theoretically navigate environments designed for humans. It can walk up stairs, reach into shelving designed for human workers, and use tools and fixtures built for human hands. It doesn't need custom end effectors for every task. It doesn't need floor-mounted rails or ceiling gantries.

For a manufacturer running a high-mix, low-volume operation with frequent changeovers, the idea of a general-purpose robot that adapts to different tasks without hardware changes is compelling. Instead of engineering a custom cell for each product, you'd program a humanoid to perform the new task sequence.

The AI component is what makes this plausible. These robots are using large neural networks for perception and task planning — similar architectures to what's driving advances in [machine vision](/solutions/machine-vision/) but applied to whole-body coordination. The robot doesn't follow rigid programmed paths. It perceives its environment and plans movements dynamically.

## What's Still Missing

Let's be direct about the gaps:

**Payload capacity.** Most humanoid robots max out at 10-15kg per arm. That's fine for tote handling but eliminates the majority of industrial material handling tasks. A single automotive door panel weighs 15-20kg. A transmission case is 30kg+. Until payload capabilities improve substantially, humanoids are limited to light-duty work.

**Cycle time consistency.** Traditional industrial robots hit their programmed cycle times to within milliseconds, run after run. Humanoid robots using AI-based motion planning have significantly more variability. When your takt time is 60 seconds and you can't afford a 2-second deviation, that variability is a dealbreaker.

**Uptime and reliability.** A FANUC robot runs 99.95% uptime over a 10-year lifespan with standard maintenance. Humanoid robots are still in the "fails every few hours" stage of maturity. Walking mechanisms, in particular, add complexity that traditional fixed-base robots simply don't have. Every additional joint is another potential failure point.

**Cost.** Figure hasn't published pricing for the Figure 02. Tesla has made aspirational claims about Optimus costing under $20,000, but current-generation units almost certainly cost well north of $100,000. At that price point, a traditional 6-axis robot with a custom end effector and structured cell is a better investment for any defined task.

**Safety certification.** There's no established safety standard for humanoid robots operating alongside human workers. ISO 10218 and ISO/TS 15066 were written for fixed-base and collaborative robots. A 170-pound bipedal robot walking through a factory raises safety questions that existing frameworks don't address. Expect regulatory work to lag behind the technology by several years.

## What Manufacturers Should Actually Do

Don't wait for humanoid robots to solve your automation challenges. The technology is 3-5 years away from meaningful production deployment for anything beyond basic material handling.

Instead, focus on the automation technologies that deliver ROI today: proven 6-axis robots, cobots, SCARA robots, AMRs, and structured vision systems. These are mature, reliable, and can be deployed in months rather than years.

But keep an eye on the space. If your facility has tasks that are genuinely difficult to automate with traditional approaches — unstructured environments, frequent layout changes, tasks that require human-like dexterity — humanoid robots may eventually be the answer. The progress over the past 18 months has been faster than most of us in the automation industry expected.

The manufacturers who'll benefit most from humanoid robots are the ones who've already automated the easy stuff. They've deployed traditional robots everywhere it makes sense, and they're left with the awkward, unstructured tasks that don't fit neatly into a conventional cell. That's where humanoids will eventually find their niche — not replacing traditional automation, but filling the gaps it can't reach.
