---
title: 'Aerospace Composites Automation: Layup to Inspection'
description: Explore how automated composite manufacturing transforms aerospace production
  from manual layup through curing and final inspection, improving consistency and throughput.
keywords: aerospace composites automation, automated fiber placement, composite layup
  automation, composite inspection, NDT automation, AFP, ATL, aerospace manufacturing
date: '2025-05-21'
author: AMD Machines Team
category: Business
read_time: 8
template: blog-post.html
url: /blog/aerospace-composites-automation-layup-to-inspection/
---

## Why Composites Dominate Aerospace Structures

Carbon fiber reinforced polymers (CFRPs) and other advanced composites now account for more than 50% of structural weight on modern commercial aircraft. The Boeing 787 and Airbus A350 both pushed past that threshold, and military platforms have been composite-heavy for decades. The reasons are straightforward: composites deliver superior strength-to-weight ratios, resist fatigue and corrosion, and allow engineers to tailor material properties by orienting fiber directions to match load paths.

But these performance advantages come with a manufacturing challenge. Unlike stamping a metal part, producing a composite component involves placing hundreds or thousands of individual plies in precise orientations, consolidating them under controlled heat and pressure, then verifying internal quality with non-destructive testing. Manual processes can handle low-volume work, but as production rates climb—and as aerospace OEMs push toward rates of 60+ narrowbody aircraft per month—automation becomes essential at every stage of the process.

## Automated Layup: AFP and ATL Systems

The layup phase is where raw prepreg material gets placed onto a mold or mandrel to build up the part geometry. Two primary automated approaches handle this work.

**Automated Tape Laying (ATL)** uses wide bands of prepreg tape, typically 75mm to 300mm, laid down by a gantry-mounted head. ATL excels on large, gently curved surfaces like wing skins and fuselage barrel sections. The head applies compaction force, heats the material to promote tack, and can lay material at speeds exceeding 50 meters per minute on flat sections. The limitation is geometric—ATL heads struggle with tight radii and complex contours because the wide tape cannot conform to compound curves without wrinkling or bridging.

**Automated Fiber Placement (AFP)** addresses that gap. AFP heads lay down multiple narrow tows, usually 3.2mm or 6.35mm wide, and can independently start, stop, cut, and restart each tow. This gives AFP the ability to handle complex double-curvature geometries while still maintaining reasonable deposition rates. Modern AFP heads running 16 or 32 tows can achieve material deposition rates of 10 to 25 kg per hour, depending on part complexity. For highly contoured structures like engine nacelle components, inlet ducts, and fuselage frames, AFP is typically the only viable automated option.

Both ATL and AFP systems rely on precise path planning software that translates the engineering ply definition into machine tool paths. The software must account for material steering limits, gap and overlap tolerances between adjacent courses, and ramp-up and ramp-down zones at ply boundaries. Getting these parameters right is critical—steering a tow too aggressively causes fiber buckling, while excessive gaps between courses create resin-rich zones that weaken the laminate.

## Kitting, Debulking, and Pre-Cure Processing

Automation extends beyond the layup head itself. Automated kitting systems cut prepreg plies to shape using ultrasonic knives or CNC cutters, label them with ply identification, and sequence them for the layup operation. This eliminates manual nesting errors and ensures every ply is correctly oriented before it reaches the tool.

Between layup sequences, most composite structures require debulk cycles—vacuum consolidation steps that remove trapped air between plies. Automated debulk systems apply vacuum bags, pull vacuum, and monitor pressure decay to verify bag integrity. Some advanced cells integrate robotic bag placement, reducing what was traditionally a labor-intensive interruption to the layup process.

For hot-drape forming operations, automated systems heat flat laminates and form them over contoured mandrels under controlled conditions. Temperature uniformity across the laminate is critical; automated forming cells use infrared heating arrays with closed-loop pyrometer feedback to maintain material within a 5°C tolerance window. This consistency is nearly impossible to achieve with manual heat blanket approaches.

## Autoclave and Out-of-Autoclave Curing

Once layup is complete, the part must be cured. Traditional autoclave processing subjects the part to elevated temperature (typically 180°C for epoxy systems) and pressure (6-7 bar) inside a large pressure vessel. Autoclave cure cycles run 4 to 8 hours depending on the material system and part thickness.

Automation plays a role here in several ways. Automated bagging systems prepare the vacuum bag assembly with consistent placement of breather, release film, and caul plates. Automated cure monitoring systems track dozens of embedded thermocouples and adjust heat-up rates to ensure the laminate reaches cure temperature uniformly—particularly important for thick laminates where exothermic reactions can cause temperature overshoots.

The industry is also moving toward out-of-autoclave (OoA) processes that use vacuum-only curing in standard ovens. OoA prepreg systems have matured significantly, and automated placement of these materials follows the same AFP and ATL approaches. The advantage is eliminating the autoclave bottleneck, which becomes a real constraint at high production rates since autoclave capacity is expensive and the cure cycles are long.

## Non-Destructive Testing and Inspection

After curing, every aerospace composite part must be inspected for internal defects—delaminations, porosity, foreign object debris, and fiber waviness. This is where [machine vision and inspection automation](/solutions/machine-vision/) intersects with composite manufacturing in a critical way.

**Ultrasonic Testing (UT)** is the primary inspection method for aerospace composites. Automated UT systems fall into two categories: through-transmission ultrasonics (TTU), where a transmitter and receiver are on opposite sides of the part, and pulse-echo, where a single transducer sends and receives signals from the same side. Robotic UT systems mount transducers on multi-axis robot arms or gantry systems and scan the part surface while maintaining consistent coupling and standoff distance.

Modern automated UT cells can inspect large structures at scan speeds of 500mm/s or faster, generating C-scan images that map defect locations across the entire part. The inspection data is processed against acceptance criteria defined by the engineering drawing and material specification—typically requiring less than 2% porosity and no delaminations exceeding specified area limits.

**Thermographic inspection** is gaining traction as a complementary technique. Flash thermography uses a brief heat pulse and infrared camera to detect near-surface defects. Robotic thermography cells can inspect large areas quickly and are particularly useful for detecting impact damage and bondline defects in bonded assemblies.

**Laser surface profilometry** verifies the outer mold line (OML) geometry of the cured part against the CAD model. Automated laser scanners mounted on robots or coordinate measuring machines can capture millions of surface points and compare them to tolerances, flagging areas where the part surface deviates from nominal.

## Integrated Manufacturing Cells and Data Continuity

The real gains in aerospace composites automation come from connecting these individual process steps into an integrated manufacturing flow. An automated cell that handles layup, cure preparation, and inspection with [custom automation solutions](/solutions/custom-automation/) can maintain data continuity from raw material receipt through final part acceptance.

This means the AFP system records exactly where every tow was placed—its position, compaction force, heater temperature, and any tow faults. The cure system records the full temperature-pressure-vacuum profile. The UT system records the inspection data with traceability back to the specific part serial number and ply stack. When an engineer needs to disposition a finding on a delivered part years later, the complete manufacturing record is available.

This level of traceability is not optional in aerospace. AS9100 quality management requirements and OEM-specific specifications demand it. Automation makes it achievable without burying operators in paperwork.

## Process Control Challenges Specific to Composites

Composites automation is not simply a matter of buying an AFP machine and pressing start. Several factors make this domain technically demanding.

**Material variability** is a constant challenge. Prepreg tack changes with ambient temperature and humidity, material age, and storage conditions. An AFP head that runs perfectly in a climate-controlled facility may struggle with material that spent too long at room temperature. Automated systems need sensors that detect tack loss and adjust heater settings or alert operators.

**Tool surface condition** directly affects part quality. Mold release buildup, surface scratches, and thermal distortion of tooling all show up in the finished part. Automated tool inspection and cleaning between production runs helps maintain consistency.

**Ply compaction** must be verified during layup, not just after cure. Automated in-process inspection using laser profilometry or vision systems can detect wrinkles, bridging, and foreign objects before they get buried under subsequent plies—when rework is still feasible.

## Where the Industry Is Heading

Production rate increases are pushing the aerospace composites industry toward higher levels of automation. Several trends are clear. Dry fiber placement with subsequent resin infusion is gaining ground for large structures, and automated dry fiber AFP heads are now commercially available. In-situ consolidation using thermoplastic composites—where the material is fully consolidated by the AFP head without a separate cure step—promises to eliminate autoclaves entirely for certain applications.

Robotic [test and inspection systems](/solutions/test-systems/) are becoming faster and more capable, with phased-array ultrasonics enabling higher scan speeds and better defect characterization than conventional UT. Machine learning algorithms are being applied to inspection data to improve defect detection rates and reduce the burden on human inspectors reviewing thousands of C-scan images.

## Partner With AMD Machines

AMD Machines brings over 30 years of experience designing and building custom automation systems for demanding manufacturing environments. Our engineering team understands the precision, traceability, and process control requirements that aerospace composites demand. Whether you need robotic inspection cells, automated assembly systems, or integrated manufacturing solutions, we design equipment that performs in production—not just in the lab. [Contact us](/contact/) to discuss your aerospace composites automation requirements.
