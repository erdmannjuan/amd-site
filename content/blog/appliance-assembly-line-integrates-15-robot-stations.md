---
title: Appliance Assembly Line Integrates 15 Robot Stations
description: How a 15-station robotic assembly line transformed dishwasher production with mixed-model flexibility, zero changeover time, and 99.5% first-pass yield.
keywords: appliance assembly line, robotic assembly stations, dishwasher automation, mixed-model assembly, flexible manufacturing, assembly line robots, FANUC robots, appliance manufacturing automation
date: '2024-12-08'
author: AMD Machines Team
category: Business
read_time: 7
template: blog-post.html
url: /blog/appliance-assembly-line-integrates-15-robot-stations/
---

## From Two Variants to Eight: Why This Assembly Line Needed a Complete Overhaul

Appliance manufacturing has changed dramatically over the past decade. Consumers expect more options — different finishes, rack configurations, control panels, and feature sets — and retailers demand the ability to order exactly what sells in their market. For a major appliance manufacturer producing dishwashers in Ohio, this shift exposed the limits of their legacy assembly line.

The original line was designed to build two dishwasher variants. By the time the team started planning a replacement, the product portfolio had grown to eight distinct models. Every variant changeover required 45-plus minutes of manual fixture adjustments, and quality data showed that error rates spiked during the first 20 units after each changeover as operators reacquainted themselves with the different assembly sequences.

Add chronic labor shortages to the picture — the plant was regularly running short-staffed on second shift — and the case for a fully automated, flexible assembly line became impossible to ignore.

## Designing a 15-Station Robotic Assembly Line

The project called for a 180-foot assembly line capable of producing 800 dishwashers per day at a 60-second takt time, with zero changeover time between any of the eight product variants. That last requirement was the hardest. Traditional automation solves the changeover problem by dedicating equipment to each variant, but with eight models that approach gets prohibitively expensive and eats floor space.

Instead, the engineering team designed every station around the principle of universal flexibility. Each of the 15 robot stations — equipped with FANUC M-20 and LR Mate robots — can handle all eight variants without any physical tooling changes. Here is how the stations break down across the assembly process:

**Stations 1 through 3** handle tub loading and component insertion. Robots pick tubs from incoming conveyors, orient them in servo-driven fixtures, and insert internal components like insulation panels, sound-dampening pads, and wiring harnesses. The fixtures use servo-actuated locators that automatically reposition for the incoming variant dimensions.

**Stations 4 through 6** perform door assembly and hinge installation. Door panels vary significantly across the eight models — different sizes, different finishes, different handle mounting points. Cognex 3D-A5000 vision systems guide robots to pick the correct door components from mixed bins, eliminating the need for variant-specific part presentation.

**Stations 7 through 9** install spray arms and dish racks. These components differ in geometry across variants, so vision-guided picking is critical here as well. The robots verify correct part selection before installation, catching mix-ups before they become defects.

**Stations 10 through 12** handle pump and motor installation. This is precision work — motor mounts must align within tight tolerances to avoid vibration issues during the dishwasher's wash cycle. Force-torque sensors on the robot end-effectors confirm proper seating of every component.

**Station 13** manages electrical connections and wiring. Different variants have different control boards, sensor packages, and wiring harnesses. The recipe management system ensures the correct wiring sequence is followed for each model.

**Station 14** performs 100-percent leak testing of every assembled tub. Test parameters automatically adjust based on the specific model, with different pressure thresholds and hold times for different tub geometries. Failed units are automatically diverted with full data logging for root-cause analysis.

**Station 15** runs final inspection and unloads finished units. A combination of vision inspection and electrical function testing verifies that every dishwasher meets specifications before it leaves the line.

Each station is designed for a 55-second cycle time, providing a five-second buffer against the 60-second line takt. That buffer is critical for maintaining throughput when occasional process variations add a few seconds to a cycle.

## The Recipe Management System That Makes It Work

The mechanical flexibility of servo-driven fixtures and vision-guided robots would be useless without a control architecture that coordinates everything. The recipe management system is the backbone of this line's mixed-model capability.

When a dishwasher tub enters the line, a barcode scan identifies its variant. The MES (Manufacturing Execution System) then pushes the correct recipe to every downstream station — robot programs, fixture positions, vision parameters, test thresholds, and torque specifications. Each station stores programs for all eight variants locally, so the download happens in milliseconds rather than seconds.

This approach means the line can run true mixed-model production. A premium stainless model can follow an entry-level white model, which can follow a mid-range black stainless model, all without any pause or changeover. Production scheduling becomes dramatically simpler because there is no penalty for variant sequencing.

For manufacturers exploring similar approaches, understanding [recipe management for batch production](/blog/recipe-management-for-batch-production/) provides useful background on how recipe-driven control systems work across different automation contexts.

## Vision Systems: Seeing What Needs to Be Built

The Cognex 3D-A5000 vision systems on this line do more than guide robot picks. They serve as the primary quality gate at multiple stations. At each vision-guided station, the system confirms three things before the robot executes: correct part identity, correct part orientation, and correct placement position.

Mixed-bin picking is one of the more challenging vision applications in assembly automation. Components for multiple variants sit together in the same bins, and the vision system must reliably distinguish between parts that may differ by only a few millimeters. The 3D capability is essential here — 2D vision alone cannot reliably differentiate parts with similar profiles but different heights or depths.

The vision data also feeds back into the quality system. Every pick, placement, and inspection result is logged with the unit's serial number, creating a complete build record that can be retrieved if a warranty claim surfaces months or years later.

## Results: What Changed After Go-Live

The numbers tell a clear story. Changeover time dropped from 45-plus minutes to zero. First-pass yield improved from 96 percent to 99.5 percent, directly attributable to the elimination of human assembly errors. The line runs with 10 operators instead of the previous 15, a 35-percent labor reduction that addressed the plant's staffing challenges.

Daily output holds steady at 800 units regardless of the variant mix, whereas the legacy line's effective output dropped significantly on days with multiple changeovers. The ROI payback period on the $8.5 million investment came in at 24 months, driven primarily by labor savings and quality improvements.

Perhaps the most significant result is operational. The plant manager no longer has to optimize production schedules around changeover costs. Orders can enter production in whatever sequence makes sense for customer delivery dates, not equipment constraints.

## Lessons for Your Assembly Automation Project

Several engineering decisions on this project are worth highlighting for anyone planning a multi-variant [assembly system](/solutions/assembly/):

**Design for your maximum variant count, plus margin.** This line was designed for eight variants, but the fixture travel ranges and vision system flexibility can accommodate additional models without hardware changes. The manufacturer has already introduced a ninth variant using only software updates.

**Invest in cycle time buffer.** The five-second buffer between station cycle time (55 seconds) and line takt (60 seconds) prevents individual station variations from starving downstream stations. Without that buffer, a line this long would see frequent micro-stoppages.

**Integrate testing into the line, not after it.** The leak test and final inspection stations are integral to the assembly line rather than separate offline operations. This catches defects before additional value is added and provides immediate feedback to upstream stations. For more on this approach, see our discussion on [end-of-line testing strategies for quality assurance](/blog/end-of-line-testing-strategies-for-quality-assurance/).

**Plan for data from day one.** Every station logs process data tied to individual unit serial numbers. This traceability was not in the original scope but was added during detailed engineering. It has already paid for itself by enabling rapid root-cause analysis when quality excursions occur.

## Partner With AMD Machines

AMD Machines has designed and built automated assembly lines for appliance, automotive, medical device, and consumer products manufacturers for over 30 years. Our engineers understand the challenges of mixed-model production and build systems that deliver flexibility without sacrificing throughput or quality. [Contact us](/contact/) to discuss your assembly automation project.
