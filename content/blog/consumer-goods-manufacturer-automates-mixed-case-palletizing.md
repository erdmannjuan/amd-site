---
title: Consumer Goods Manufacturer Automates Mixed-Case Palletizing
description: How a consumer goods manufacturer deployed robotic mixed-case palletizing to handle diverse SKUs, reduce labor costs, and increase throughput across multiple packaging lines.
keywords: mixed-case palletizing, robotic palletizing, consumer goods automation, palletizing robot, SKU variety, warehouse automation, end-of-line automation
date: '2024-12-12'
author: AMD Machines Team
category: Business
read_time: 7
template: blog-post.html
url: /blog/consumer-goods-manufacturer-automates-mixed-case-palletizing/
---

## The Mixed-Case Palletizing Challenge

Consumer goods manufacturers face a problem that has grown steadily worse over the past two decades: SKU proliferation. Retailers demand more variety, smaller lot sizes, and store-ready pallets built from multiple product types. The traditional approach—dedicated palletizing lines for each product family, with manual labor bridging the gaps—breaks down when you're running 200+ active SKUs across a facility that ships mixed-case pallets to dozens of distribution centers.

That was the situation facing a mid-sized consumer goods manufacturer producing household cleaning products. Their end-of-line operations had become the bottleneck. Three manual palletizing stations ran two shifts, staffed by teams of four operators each. Turnover exceeded 40% annually. Repetitive strain injuries were climbing. And the real constraint wasn't labor cost alone—it was the inability to build mixed-case pallets accurately and quickly enough to meet retailer shipping requirements.

The manufacturer needed a system that could handle multiple product sizes and weights within a single palletizing cell, build stable mixed-case pallets according to retailer-specific patterns, and do it at rates that would consolidate three manual stations into a single automated solution.

## Defining the Technical Requirements

Before any equipment was specified, the engineering team spent several weeks documenting the actual operational requirements. This upfront work is where most palletizing projects succeed or fail. The key parameters included:

- **SKU dimensions**: Cases ranged from 8" × 10" × 6" to 24" × 16" × 14", with weights from 5 to 45 pounds
- **Throughput target**: 18 cases per minute sustained, with burst capability to 22
- **Pallet configurations**: 14 distinct retailer-specific pallet patterns, plus a default mixed-case pattern
- **Changeover**: Zero mechanical changeover between SKUs—pattern changes handled entirely in software
- **Layer stability**: Interlayer slip sheets on selected patterns, corner boards on all pallets

The weight range was particularly challenging. A gripper system that handles a 5-pound case of aerosol cans needs a fundamentally different approach than one moving 45-pound cases of liquid detergent bottles. The solution required either a universal gripper or a quick-change system that wouldn't eat into cycle time.

## System Design and Integration

The final system centered on a high-payload [robotic cell](/solutions/robotic-cells/) with a custom end-of-arm tool designed for the full case range. The EOAT used a combination of vacuum zones and mechanical clamping. Vacuum provided primary grip for lighter cases, while pneumatic clamps engaged automatically for heavier products. A pressure sensor array confirmed grip integrity before any lift, preventing drops that would damage product and create line stoppages.

The cell layout addressed material flow from three upstream packaging lines converging into a single palletizing station. An accumulation conveyor system fed cases into a sequencing area where a vision system identified each case by barcode and dimensional profile. The sequencing logic was critical—cases had to arrive at the robot in the correct order to build stable pallet layers without requiring the robot to buffer or resequence product.

The conveyor design incorporated several features specific to mixed-case handling:

- **Singulation section** that separated cases arriving in groups from higher-speed upstream lines
- **Right-angle transfer** for routing cases from three inbound lines to the sequencing conveyor
- **Dynamic accumulation zone** providing approximately 90 seconds of buffer per line, allowing the robot to absorb brief upstream interruptions without stopping packaging operations

Pallet build patterns were stored in the robot controller and selected automatically based on order data pulled from the warehouse management system. When a new pallet order started, the system knew which SKUs would arrive, in what sequence, and which pattern to execute. The operator's role shifted from physical case handling to monitoring the HMI, loading empty pallets, and removing completed ones—though even pallet loading was semi-automated with a pallet dispenser feeding the build station.

## Software and Pattern Management

One of the underappreciated aspects of mixed-case palletizing is the software complexity. Each retailer pattern defines not just where cases go on each layer, but the sequencing rules that determine build order for stability. A heavy case of liquid detergent must go on the bottom layer. Tall, narrow cases need adjacent support. Lighter aerosol cases sit on top.

The system used offline pallet pattern software that allowed the engineering team to design and simulate new patterns without interrupting production. Each pattern was validated against stability criteria—center of gravity, overhang limits, weight distribution per layer—before being released to the production system. When a retailer changed their pallet specifications, the manufacturer could develop, test, and deploy a new pattern within a day rather than reprogramming the robot on the line.

This software-driven approach also enabled something manual palletizing never could: perfect consistency. Every pallet built to a given pattern was identical. No variation between shifts, no degradation during overtime hours, no quality issues caused by operator fatigue. Retailer chargebacks for incorrect pallet builds, which had been running around $15,000 per month, dropped to near zero within the first quarter of operation.

## Results and Operational Impact

The system achieved its throughput target of 18 cases per minute within the first month of production. After optimization of conveyor speeds and robot path planning during the second month, sustained rates reached 20 cases per minute with the ability to burst to 24 for short periods during high-demand SKU runs.

The quantifiable results over the first year of operation:

- **Labor reduction**: From 12 operators across two shifts to 2 monitors per shift, redeployed to upstream packaging roles where manual dexterity was still required
- **Throughput increase**: 35% more cases palletized per shift compared to the three manual stations combined
- **Pallet quality**: Retailer chargebacks for pallet build errors eliminated, saving approximately $180,000 annually
- **Injury reduction**: Zero repetitive strain injuries in end-of-line operations, down from an average of 6 per year
- **Floor space**: Consolidated from three palletizing stations occupying 2,400 square feet to a single cell requiring 1,100 square feet

The ROI calculation was straightforward. The total system cost—including the robot, EOAT, conveyors, vision, controls, safety guarding, installation, and commissioning—came to approximately $850,000. Annual labor savings plus chargeback elimination plus injury cost reduction yielded a payback period under 14 months.

## Lessons Learned

Several insights from this project apply broadly to mixed-case palletizing implementations in [consumer goods packaging](/blog/consumer-goods-packaging-flexibility/) environments:

**Invest in upstream sequencing.** The robot itself is rarely the constraint. Getting cases to the robot in the right order, at the right rate, without gaps or bunching, is where most of the engineering effort belongs. The manufacturer initially underestimated the complexity of merging three packaging lines into one palletizing cell and had to redesign the accumulation conveyor section during commissioning.

**Plan for SKU changes from day one.** Consumer goods manufacturers add and discontinue SKUs constantly. The system's case handling envelope—the range of dimensions and weights the EOAT can grip reliably—should be specified with margin beyond the current product line. This manufacturer designed for cases 20% larger and 15% heavier than anything in their current portfolio, which proved wise when they launched a new product line eight months after installation.

**Don't underestimate pattern management.** Retailers change pallet specifications more often than most manufacturers anticipate. Having offline pattern design capability with simulation-based validation prevented production disruptions that would have eroded the throughput gains.

**Validate with real product, not simulations alone.** Case surface finish, label placement, and seal integrity all affect grip reliability. Several case types that gripped perfectly in testing showed issues in production due to label stock variations from different suppliers. The commissioning period should include runs with product from every active supplier.

## Applying These Principles

Mixed-case palletizing represents one of the higher-complexity applications in end-of-line automation, but the core engineering principles are the same ones that apply to any [palletizing and packaging automation](/blog/packaging-automation-case-erecting-to-palletizing/) project: define the full range of operating conditions, design for the worst case rather than the average, and invest in the material handling upstream of the robot at least as heavily as in the robot itself.

For consumer goods manufacturers dealing with SKU proliferation and labor challenges at end-of-line, robotic mixed-case palletizing has moved from an emerging technology to a proven solution. The key is rigorous upfront engineering to match the system design to the actual—not theoretical—operating requirements of the facility.

AMD Machines has designed and integrated palletizing systems across consumer goods, food and beverage, and pharmaceutical applications. [Contact us](/contact/) to discuss how mixed-case palletizing could address your end-of-line challenges.
