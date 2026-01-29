---
title: Robotic Bin Picking Systems | AI Vision Integration | Industrial Automation
description: AI-powered robotic bin picking systems with 3D vision achieving 99%+ pick rates. Custom FANUC & ABB integration for automotive, medical, and heavy equipment manufacturers.
keywords: robotic bin picking, 3D vision bin picking, AI vision integration, random bin picking automation, structured bin picking, bin picking ROI, industrial bin picking systems
template: solution.html
hero_title: Robotic Bin Picking
hero_subtitle: AI-powered 3D vision systems delivering measurable labor reduction for Tier 1 manufacturers
short_title: Bin Picking
url: /solutions/bin-picking/
features:
  - 3D vision for random part location
  - AI-powered grasp planning
  - Multi-part type handling
  - Collision-free path planning
  - High-speed picking cycles
  - Deep bin reaching capability
  - Automatic gripper changeover
  - Integration with conveyors and feeders
applications:
  - name: Machine Tending
    description: Pick castings, forgings, or machined parts from bulk containers for CNC loading with sub-5-second cycle times and 99%+ pick reliability.
  - name: Assembly Feeding
    description: Feed randomly oriented components to assembly stations without manual sorting, eliminating bowl feeder limitations for complex geometries.
  - name: Packaging
    description: Pick products from bulk bins for case packing or palletizing operations, handling mixed SKUs and variable orientations.
  - name: Kitting
    description: Select multiple part types from bins to build kits for assembly, reducing manual labor and eliminating picking errors.
  - name: Depalletizing
    description: Unload randomly stacked parts from pallets or gaylords for downstream processing, handling layer-to-layer variation automatically.
benefits:
  - title: Eliminate Manual Sorting
    description: Remove tedious hand-sorting that causes repetitive strain injuries and high turnover—our systems handle parts that bowl feeders can't orient.
  - title: 24/7 Operation
    description: Continuous picking at consistent cycle times without fatigue, breaks, or shift changes—typically 50-70% labor cost reduction per station.
  - title: Flexible Handling
    description: Handle multiple part types, sizes, and orientations without mechanical retooling using AI-driven grasp planning and quick-change grippers.
  - title: Improved Ergonomics
    description: Remove repetitive reaching into deep bins and lifting heavy parts—addressing the #1 cause of lost-time injuries on sorting lines.
---

I'll be honest with you: five years ago, I would've told most manufacturers to hold off on bin picking. The technology was expensive, the pick rates were inconsistent, and you'd spend more time babysitting the vision system than you saved in labor. That's changed completely. The combination of faster 3D sensors, better AI algorithms, and more capable robot controllers has turned bin picking from a science project into a production-proven solution that pays for itself in under two years.

At AMD Machines, we've deployed bin picking systems across [automotive](/industries/automotive/), [medical](/industries/medical/), [heavy equipment](/industries/heavy-equipment/), and [general manufacturing](/industries/general-manufacturing/) environments. We've learned what works, what doesn't, and—more importantly—what questions you need to answer before you commit to a bin picking project.

## How Modern Bin Picking Actually Works

The concept sounds simple: a robot looks into a bin, figures out where the parts are, picks one up, and places it somewhere useful. In practice, there are four distinct technology layers that have to work together flawlessly, hundreds of times per hour, in a factory environment with dust, vibration, and varying ambient light.

### 3D Vision Acquisition

Everything starts with the sensor. The system needs to build a 3D model of what's inside the bin—a point cloud that captures the shape, position, and orientation of every visible part. There are three main sensor technologies we integrate, and choosing the right one matters more than most people realize.

**Structured light sensors** project a known pattern onto the bin contents and use stereo cameras to reconstruct the 3D surface. We've had excellent results with Photoneo PhoXi 3D scanners and Zivid Two cameras. Structured light gives you dense, accurate point clouds (±0.1 mm accuracy is typical) and works well on shiny or dark parts that trip up other sensor types. The downside is scan time—typically 300–800 ms per acquisition—which limits cycle time on high-speed applications.

**Time-of-flight (ToF) sensors** measure the round-trip time of emitted light to calculate depth. These are faster (under 100 ms) but less accurate. We use them primarily for large-part applications where ±1 mm accuracy is sufficient, such as [heavy equipment](/industries/heavy-equipment/) castings or stamped brackets.

**Active stereo sensors** combine structured light with stereo vision algorithms. Keyence's 3D vision systems and some configurations of Cognex 3D-A5000 series sensors fall into this category. They offer a good balance of speed and accuracy for medium-sized parts.

The sensor mounting position matters too. For bins under 600 mm deep, we mount the sensor on a fixed overhead bracket. For deeper bins—gaylords and large totes—we mount the sensor on the robot's wrist or on a separate linear axis so it can scan from multiple angles and resolve occlusions at the bottom of the bin.

### AI-Powered Part Segmentation and Grasp Planning

Raw point cloud data is useless without intelligence. This is where the software earns its keep.

Modern bin picking software—we work extensively with Photoneo Bin Picking Studio, FANUC 3D Vision iRVision, ABB PickMaster Twin, and Mech-Mind Mech-Vision—performs several critical functions in sequence:

1. **Part segmentation**: The AI identifies individual parts within the cluttered point cloud, separating overlapping and touching objects. CAD-based matching compares the scan against a known 3D model of the target part. CAD-free AI models use deep learning trained on synthetic data to segment parts without a predefined model.

2. **Pose estimation**: For each identified part, the system calculates its exact position and orientation in 6 degrees of freedom (X, Y, Z, Rx, Ry, Rz). Accuracy here directly determines pick success—you need better than ±1 mm and ±1° for most applications.

3. **Grasp planning**: The software evaluates which part is most accessible and calculates the optimal approach vector for the gripper. It considers part geometry, gripper configuration, neighboring parts, and bin walls. Good grasp planners score multiple candidates and pick the highest-probability option.

4. **Collision checking**: Before the robot moves, the software simulates the entire pick trajectory—approach, grasp, extraction, and retreat—checking for collisions against the bin walls, other parts, and surrounding equipment. This step prevents crashes that would shut down the cell and damage tooling.

### Robot Execution

We integrate bin picking with FANUC, ABB, Yaskawa, and KUKA robots depending on the application. The robot selection depends on payload, reach, speed, and the customer's facility standard.

For parts under 5 kg—which covers most bin picking applications—we favor the FANUC CRX-10iA/L or M-10iD/12 and the ABB IRB 1200-7/0.7. These robots offer the speed, repeatability (±0.02 mm), and reach needed for standard bin picking from totes and gaylords.

For heavier parts—castings, forgings, machined housings up to 35 kg—we step up to the FANUC M-20iD/25 or ABB IRB 4600-40/2.55. We've picked 28 kg cast iron housings from gaylords at a [heavy equipment](/industries/heavy-equipment/) manufacturer with 8-second cycle times and zero drops over 2 million picks.

### Gripper Design: Where Projects Succeed or Fail

I can't stress this enough: the gripper makes or breaks a bin picking project. You can have the best vision system and the fastest robot on the market, and if your gripper can't reliably acquire the part in the available orientations, you're dead in the water.

We design custom grippers for every bin picking application, but they generally fall into three categories:

- **Vacuum grippers** with Schmalz or Piab cups for parts with at least one flat or gently curved surface. These are fast, gentle, and forgiving of minor pose errors. We use multi-zone vacuum with independent sensing so the system knows immediately if a cup didn't seal.

- **Mechanical grippers** from Schunk (PGN-plus series) or ZIMMER for parts that need a positive mechanical hold—round shafts, tubes, and parts without vacuum-friendly surfaces. We often combine parallel and angular jaw configurations.

- **Magnetic grippers** for ferrous parts—especially effective for oily or dirty castings where vacuum cups slip. We use Schunk EMH or custom electromagnet arrays with controlled release to prevent part sticking during placement.

Many of our systems use Schunk SWS quick-change couplers so the robot can automatically swap between gripper types for multi-part applications.

## Real-World Application Examples

### Automotive Transmission Housing Deburring Feed

A Tier 1 transmission supplier was hand-sorting aluminum die-cast housings from gaylords to feed their [deburring cells](/solutions/deburring/). Each gaylord held approximately 120 housings weighing 3.2 kg each, nested randomly in three layers with cardboard dividers. Three operators per shift did nothing but reach into gaylords, orient housings, and load them onto conveyors. Turnover in that role was 40% annually—it's hot, repetitive work.

We installed a FANUC M-20iD/25 with a Photoneo PhoXi XL 3D scanner mounted on a linear vertical axis. The scanner descends as the bin level drops, maintaining optimal scan distance throughout the entire gaylord. A custom vacuum gripper with four independently sensed Schmalz bellows cups handles the housing geometry.

**Results:** 7.2-second average cycle time (peak demand was 8 seconds), 99.4% first-attempt pick rate, 99.97% overall pick rate including retries. Eliminated all three sorting operators per shift. Full payback in 14 months on a two-shift operation. The system has processed over 1.8 million parts in its first two years with zero lost-time safety incidents—compared to six recordable injuries per year on the manual operation.

### Medical Component Feeding for Assembly

A medical device manufacturer needed to feed small stainless steel components (12 mm diameter, 8 mm tall, 4.5 grams) from bulk totes into a precision [assembly system](/solutions/assembly/). The parts had a complex geometry that defeated every bowl feeder configuration they tried—the asymmetric features caused bridging and jamming at feed rates above 15 parts per minute.

We deployed an ABB IRB 1200-5/0.9 with a Zivid Two M70 camera and a Schunk EGP 25 electric gripper. The small field of view of the M70 gave us the resolution needed to distinguish orientation features on these tiny parts. The robot picks from a shallow presentation tray that's periodically refilled from the bulk tote via a simple belt conveyor.

**Results:** 22 parts per minute sustained feed rate (47% faster than the best bowl feeder attempt), zero jams in over 8 months of production, and the system handles three part variants with a single recipe change—no mechanical changeover required. The vision system also performs an incoming inspection on every part, rejecting out-of-spec components before they reach the assembly stations.

### Heavy Equipment Forging Sorting

A forging operation for [heavy equipment](/industries/heavy-equipment/) components needed to sort five different forging variants from a shared cooling conveyor into part-specific bins for downstream machining. Operators were misidentifying parts approximately 0.3% of the time—a small percentage that translated to significant downstream scrap when the wrong forging was loaded into a CNC machine.

We built a FANUC M-710iC/50 cell with a Photoneo MotionCam-3D for high-speed scanning of moving parts on the conveyor. The AI classification system identifies each forging variant by shape—no barcodes or markings needed on the hot, scaled parts. A custom magnetic gripper handles the 12–18 kg forgings.

**Results:** Zero misidentifications in over 500,000 sorted parts, 4.5-second average cycle time per part, and the system generates part-count data that feeds directly into the production scheduling system via OPC UA.

## Common Challenges and How We Solve Them

**"Our parts are shiny/dark/oily."** Surface finish is the single biggest variable in 3D vision performance. We prototype every application with your actual production parts—not samples that have been cleaned and degreased. For highly reflective parts like polished stainless steel or chrome-plated components, structured light sensors with HDR mode (like the Zivid Two) handle specular reflections that blind standard sensors. For oily parts straight from machining, we've had good results with Photoneo sensors that use blue LED structured light to cut through oil film.

**"We need faster cycle times."** Standard bin picking runs 6–10 seconds per pick. If you need faster, there are strategies: overlapping the scan with robot motion (scan while placing the previous part), using faster sensors, pre-computing grasp plans for multiple parts per scan, or running two robots from a single vision system alternating picks. We've achieved 3.8-second sustained cycles on a dual-robot automotive application.

**"Parts get tangled in the bin."** Tangling is a real problem with springs, clips, wire forms, and stamped brackets with hooks or tabs. Solutions include: pre-singulation (a vibrating platform that separates tangled clusters before the main pick), specialized gripper designs that can extract tangled pairs and separate them at a secondary station, or redesigning the bin dividers to reduce tangling. Sometimes the honest answer is that certain part geometries aren't suited for random bin picking, and a structured de-nesting approach works better.

**"What happens when the bin is almost empty?"** The last 5–10% of parts in a bin are the hardest to pick—they're flat on the bottom, potentially wedged into corners, and the sensor has trouble seeing them with the bin walls creating shadows. We handle this with multi-angle scanning (wrist-mounted or movable sensors), bin tilt mechanisms that consolidate remaining parts, and smart bin-change logic that swaps to a new bin when pick times exceed a threshold.

**"We need to pick from multiple bin types."** No problem. We calibrate the system for each bin geometry—standard totes, gaylords, wire baskets, and custom containers. The operator selects the bin type at the HMI, or the system auto-detects based on the first scan.

## The ROI of Bin Picking

Let's build a realistic business case. Here are the numbers we see most often across our installed base:

**Labor savings**: A typical manual sorting station requires one operator per shift at a fully burdened cost of $55,000–$65,000/year. On a two-shift operation, that's $110,000–$130,000/year per station. Many applications require 2–3 operators (multiple bin positions or heavy parts requiring team lifts), pushing annual labor costs to $220,000–$390,000.

**Ergonomic and safety savings**: Manual bin sorting generates recordable injuries—typically 2–4 per year per station for heavy parts. Between direct medical costs, workers' comp premiums, and lost productivity, each recordable incident costs $30,000–$50,000. Eliminating these injuries saves $60,000–$200,000/year and removes a major HR headache.

**Quality improvements**: Automated bin picking with integrated vision inspection catches defects that manual sorting misses. Our customers typically see a 0.1–0.5% reduction in downstream scrap from better incoming part screening, which translates to $20,000–$100,000/year depending on part value and volume.

**Throughput consistency**: Manual sorting rates degrade through the shift—operators slow down, take breaks, and vary in speed. Automated systems maintain consistent cycle times 24/7, which smooths downstream operations and reduces buffer inventory requirements.

For a typical bin picking system costing $180,000–$350,000 (robot, vision, gripper, integration, and controls), we see full payback in **10–20 months** on a two-shift operation. Simpler applications with standard totes and lighter parts come in at the lower end; complex gaylord applications with custom grippers and heavy parts are at the higher end.

## Frequently Asked Questions

### What pick rate should I expect from a bin picking system?

On well-designed applications with appropriate sensors and grippers, we consistently achieve 99%+ first-attempt pick rates and 99.9%+ overall pick rates including retries. The key variables are part geometry, surface finish, and how the parts nest in the bin. During our feasibility study, we test with your actual production parts and report measured pick rates before you commit to the project.

### What's the minimum part size for bin picking?

With current sensor technology, reliable bin picking works well for parts roughly 10 mm and larger in their smallest dimension. Below that, you're generally better served by a flex feeder with 2D vision—like an Asyril Asycube paired with a Cognex In-Sight camera—which is what we use for small components in our [assembly systems](/solutions/assembly/). The crossover point depends on part geometry and required throughput.

### Can bin picking work with mixed parts in the same bin?

Yes—multi-part bin picking is a proven capability with modern AI vision software. The system identifies each part type, selects the appropriate grasp strategy, and routes it to the correct downstream location. We've deployed systems that handle up to eight different part numbers from a single bin. The main constraint is gripper design: you either need a universal gripper that handles all variants or an automatic tool changer.

### How does bin picking compare to bowl feeders and flex feeders?

Bowl feeders are still the best solution for high-speed feeding of simple, symmetrical parts (40+ parts/minute). Flex feeders excel at complex parts in the 15–30 parts/minute range with easy changeover. Bin picking fills the gap that neither can address: large parts, heavy parts, parts that tangle, and parts that arrive in bulk containers rather than controlled trays. Many of our systems combine bin picking for bulk-to-singulated presentation with downstream [machine vision](/solutions/machine-vision/) for fine orientation.

### What maintenance does a bin picking system require?

Maintenance is minimal. The robot follows standard FANUC/ABB/Yaskawa maintenance schedules (grease changes at 3-year or hour-based intervals). The 3D sensor requires periodic cleaning of the lens window—weekly in dusty environments, monthly in clean ones. Gripper wear parts (vacuum cups, jaw inserts) are consumables we stock for fast replacement. Software updates are deployed remotely. Most customers report less than 2% downtime attributable to the bin picking system itself.

### Do you provide a feasibility study before committing to a full system?

Always. We start every bin picking project with a paid feasibility study where we test your actual production parts in our lab. We measure pick rates, cycle times, and identify potential failure modes using the specific sensor and gripper configuration we're recommending. You get a detailed report with video evidence before making a purchase decision. This approach eliminates the biggest risk in bin picking projects—discovering that the application doesn't work after the system is built. Learn more about our engineering approach through our [consulting services](/services/consulting/).

### What if my parts or volumes change in the future?

Bin picking systems are inherently more flexible than hard-tooled feeding solutions. Adding a new part variant typically requires a new CAD model upload and gripper validation—not a mechanical redesign. If your volumes increase, we can upgrade the robot to a faster model, add a second picking station, or optimize the vision processing to reduce cycle time. We design every system with a [controls architecture](/solutions/robotic-cells/) that supports future expansion.
