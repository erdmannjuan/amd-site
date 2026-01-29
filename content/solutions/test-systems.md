---
title: Leak Detection & Test Systems | Industrial Automation Integrator
description: "Custom leak detection and end-of-line test systems with <1 PPM escape rates. Helium, pressure decay, mass flow, and functional test solutions for automotive, medical, and industrial manufacturers."
keywords: leak detection systems, end-of-line test systems, pressure decay testing, helium leak testing, automated functional testing, industrial test equipment, EOL test automation
template: solution.html
short_title: Test Systems
hero_title: Leak Detection & Test Systems
hero_subtitle: Custom-engineered test solutions delivering zero-defect quality for Tier 1 manufacturers
url: /solutions/test-systems/
features:
  - Pressure decay and mass flow leak testing
  - Helium and forming gas tracer detection
  - Functional and performance testing stations
  - Electrical testing (hipot, continuity, resistance)
  - Dimensional gauging and GD&T verification
  - Data collection with full serialized traceability
  - Automated pass/fail sorting and reject isolation
  - Real-time SPC with control chart alarming
applications:
  - name: Leak Detection
    description: Pressure decay, mass flow, and tracer gas methods detecting leaks down to 1×10⁻⁵ scc/s on sealed housings, manifolds, and fluid components.
  - name: Vision Inspection
    description: Automated optical inspection for surface defects, label verification, and dimensional checks integrated with Cognex and Keyence platforms.
  - name: Functional Testing
    description: Custom test sequences that actuate, measure, and validate product operation under real-world load, temperature, and cycle conditions.
  - name: Electrical Testing
    description: Continuity, insulation resistance, and high-potential testing to IEC and UL standards for electrical and electronic assemblies.
  - name: Dimensional Measurement
    description: Automated gauging for critical GD&T features using contact probes, LVDT sensors, and laser measurement with ±0.002 mm repeatability.
  - name: Assembly Verification
    description: In-process and end-of-line confirmation that all components are present, correctly oriented, and properly secured.
benefits:
  - title: Zero Defect Shipping
    description: Comprehensive end-of-line testing catches every defect before it leaves your dock—achieving <1 PPM customer escape rates across automotive and medical programs.
  - title: Full Traceability
    description: Every test result is serialized, timestamped, and archived with part identification for complete quality documentation and regulatory compliance.
  - title: Reduced Warranty Costs
    description: Effective testing prevents field failures—our customers typically see 60–80% reductions in warranty claims within the first year of deployment.
  - title: Process Feedback
    description: Real-time SPC data reveals trends by shift, station, and material lot, enabling proactive corrections before scrap accumulates.
---

I've spent the better part of two decades commissioning end-of-line test systems, and here's the uncomfortable truth most equipment suppliers won't tell you: test equipment is only as good as the engineering behind the test strategy. I've walked into plants where they spent $200,000 on a leak test station and couldn't hold a stable baseline because nobody accounted for the thermal expansion of the test part during the production shift. I've seen functional test systems that passed every part in the morning and rejected 8% by afternoon—not because the parts changed, but because ambient temperature drifted 6°C and nobody compensated the measurement thresholds.

At AMD Machines, we don't just build test hardware. We engineer complete test strategies—starting with your failure modes, your tolerance stack-ups, your customer's quality requirements, and your production environment. Then we design hardware that delivers reliable, repeatable test results at production speed, every shift, every day. We've built test systems for [automotive](/industries/automotive/) Tier 1 suppliers, [medical device](/industries/medical/) manufacturers, [electronics](/industries/electronics/) assemblers, and [heavy equipment](/industries/heavy-equipment/) OEMs, and the common thread is always the same: the test needs to be right, and the data needs to be bulletproof.

## How Leak Detection Actually Works

Leak detection sounds simple—pressurize the part, see if the pressure drops—but the physics behind accurate leak testing will humble you fast. Every method has strengths, limitations, and failure modes that you need to understand before committing to a technology.

### Pressure Decay Testing

This is the workhorse of industrial leak detection, and it's where most programs start. You seal the part, pressurize it to a target (typically 0.5–10 bar depending on the application), stabilize the air temperature, and measure the pressure change over a defined test time. A pressure drop exceeding the reject threshold means the part leaks.

We build our pressure decay stations around instruments from **Cincinnati Test Systems (CTS)**, **ATEQ**, and **InterTech** — the three names that dominate industrial leak testing for good reason. A well-designed pressure decay test can reliably detect leaks down to approximately 0.1 scc/s (standard cubic centimeters per second). That's sufficient for most automotive fluid housings, HVAC components, and consumer product enclosures.

Here's what trips up most test system builders: the **stabilization phase**. When you pressurize a part, adiabatic heating raises the air temperature inside the cavity. That temperature then decays back toward ambient, and the pressure drops even if there's zero leak. If your stabilization time is too short, you'll see a false pressure decay that masks or mimics real leaks. We typically calculate the required stabilization time based on cavity volume, test pressure, and material thermal conductivity, then validate it empirically during runoff. On aluminum castings with 200 cc cavities at 3 bar, stabilization times of 8–15 seconds are common. On thick-walled plastic housings, it can be 20–30 seconds.

We also account for **compliance effects**—the elastic deformation of the test part and seal tooling under pressure. A flexible plastic housing might expand 0.5 cc under test pressure, and that volume change looks exactly like a leak when the part relaxes. Our fixturing designs minimize compliance through rigid nesting and controlled clamping forces.

### Mass Flow Testing

Mass flow testing measures the actual volumetric flow of air escaping from the part, rather than inferring it from pressure change. A **Druck** or **CTS Sentinel** mass flow sensor sits between the pressure source and the part, directly measuring the flow rate at steady state. This eliminates the stabilization and compliance issues that plague pressure decay—the measurement is taken at equilibrium.

Mass flow testing detects leaks down to approximately 0.01 scc/s and is our preferred method for parts with large internal volumes (>500 cc) or flexible walls where pressure decay is unreliable. It's widely used in automotive intake manifolds, transmission cases, and battery enclosures.

The tradeoff is cost and test time. Mass flow instruments are more expensive than pressure decay units, and achieving a stable flow reading can take 15–30 seconds on large volumes. But for applications where pressure decay can't deliver the sensitivity or repeatability you need, mass flow is the right answer.

### Helium Tracer Gas Testing

When you need to detect extremely small leaks—down to 1×10⁻⁵ scc/s or below—you've entered tracer gas territory. Helium is the gold standard because it's inert, non-toxic, has small molecular size (second only to hydrogen), and is detectable with mass spectrometer leak detectors at astonishingly low concentrations.

We integrate helium leak testing using two primary methods:

- **Vacuum chamber (outside-in):** The part is filled with helium and placed inside a vacuum chamber. Any helium that escapes through a leak is drawn to the spectrometer. This method achieves the highest sensitivity (1×10⁻⁹ scc/s on some configurations) and is the standard for refrigerant circuits, fuel rails, and medical device packaging.
- **Sniffer probe (inside-out):** A helium-filled part is probed externally with a sniffer wand or automated probe head that detects helium at the suspected leak location. Less sensitive than vacuum testing but simpler to implement—and it identifies *where* the leak is, not just *that* it exists.

We build helium test systems using detectors from **Inficon**, **Pfeiffer Vacuum**, and **Agilent**. For high-volume automotive applications, we've designed rotary-index helium test stations that cycle a part through charge, stabilize, test, and evacuate positions—achieving 12-second overall cycle times with helium recovery systems that reclaim over 95% of the gas.

One hard-won lesson: helium is sneaky. It permeates through elastomeric seals, O-rings, and even some plastics over time. If your helium test chamber sees a background creep above 1×10⁻⁷ scc/s, you'll lose test sensitivity. We design our chambers with metal seals where possible and implement automatic background compensation algorithms that maintain detection sensitivity throughout the production shift.

### Forming Gas Testing

For applications where helium is too expensive or impractical—large parts, high-volume packaging, or field testing—we use forming gas (typically 5% hydrogen / 95% nitrogen). Hydrogen sensors from **Sensistor (INFICON)** detect escaping hydrogen at sensitivities approaching 1×10⁻⁶ scc/s. It's less sensitive than helium mass spec but far cheaper per test, and the gas is non-flammable at 5% concentration.

## Functional and Performance Testing

Not every test is about leaks. Many of our systems verify that the assembled product actually *works* the way it's supposed to. This is where test engineering gets genuinely creative, because every product has different performance parameters.

### Electromechanical Actuation Testing

We build test stations that actuate valves, switches, latches, motors, and solenoids through their operating range while measuring force, displacement, current draw, and response time. A servo-driven actuator from **Festo** or **SMC** applies controlled inputs while high-speed DAQ from **National Instruments** captures the output waveforms.

For example, on an automotive HVAC blend door actuator, our test station measures: motor stall current (spec: 1.2–1.8 A), no-load speed (spec: 45–55 RPM), full-stroke travel time (spec: 2.8–3.4 seconds), output torque at three positions, and end-stop detection. The entire test runs in 8 seconds, and each of those measurements is compared against high/low limits programmed from the customer's engineering spec.

### Electrical Testing

For electrical and electronic assemblies, we integrate:

- **Continuity testing** — Verify every circuit path end-to-end with milliohm-level resolution. We use 4-wire Kelvin measurement to eliminate contact resistance errors on low-resistance circuits.
- **Insulation resistance (IR)** — Apply 500 V DC between isolated circuits and measure leakage current. Minimum 100 MΩ is typical for industrial assemblies.
- **High-potential (hipot) testing** — Apply 1,000–5,000 V AC or DC to verify dielectric withstand per UL, IEC, and customer specifications. Safety interlocking is critical—our hipot stations include dual-channel voltage monitoring and hardwired safety circuits that prevent operator exposure.
- **In-circuit and functional board testing** — Bed-of-nails fixtures contact test points on PCBAs for component verification, parametric measurement, and boundary scan testing.

We work with test instruments from **Keysight**, **Chroma**, and **Associated Research** depending on the testing standards your product requires.

## Data, Traceability, and SPC

Every AMD test system outputs serialized test data—period. I can't tell you how many times I've seen test systems running in production with nothing but a green/red stack light and a clipboard. That's not testing; that's guessing.

Our standard test data architecture includes:

- **Part identification** — Barcode scan, RFID read, or serial number entry before every test. No scan, no test. The system locks out if identification fails.
- **Timestamped results** — Every measurement value, pass/fail status, and test condition recorded with millisecond timestamps.
- **Statistical process control** — Real-time X-bar and R charts, Cpk calculations, and trend alarms displayed on the HMI. If a measurement parameter starts drifting toward the control limit—even while still passing—the system alerts the operator and quality team before a single reject is produced.
- **Database integration** — Results pushed to SQL Server, Oracle, or cloud databases via OPC UA, MQTT, or direct SQL writes. We integrate with MES platforms from **Plex**, **AVEVA (Wonderware)**, and **Rockwell FactoryTalk** for real-time production visibility.
- **Regulatory compliance** — For [medical device](/industries/medical/) customers, we design data systems compliant with FDA 21 CFR Part 11, including electronic signatures, audit trails, and controlled access. For [automotive](/industries/automotive/) programs, we support IATF 16949 traceability and AIAG SPC requirements.

## Real-World Application Examples

### Automotive Transmission Valve Body — Helium Leak Testing

A Tier 1 powertrain supplier needed to test aluminum transmission valve bodies for internal cross-port leaks between hydraulic circuits. Pressure decay testing couldn't achieve the required sensitivity of 5×10⁻⁴ scc/s because the large internal volume (380 cc) and thin aluminum walls created excessive compliance and thermal noise.

We designed a 4-station rotary index helium test system using an **Inficon UL3000** mass spectrometer. Station 1 loads and seals the part into a vacuum bell. Station 2 charges the internal circuits with helium at 6 bar. Station 3 evacuates the bell and measures helium leakage across each circuit boundary individually using sequential valve isolation. Station 4 evacuates residual helium and unloads.

**Results:** Cycle time of 14 seconds per part (meeting the 15-second takt requirement). Leak sensitivity of 1×10⁻⁵ scc/s—ten times better than required. Helium recovery rate of 96%, keeping gas costs under $0.08 per test. Customer PPM related to cross-port leaks dropped from 23 PPM to zero over 18 months.

### Medical Device Packaging — Whole-Package Integrity Testing

A medical device manufacturer needed to verify hermetic seal integrity on sterile barrier packaging for implantable devices. The packages used Tyvek lids heat-sealed to PETG trays, and the customer's specification required detection of seal defects down to 250-micron channel leaks per ASTM F2095.

We built a vacuum decay test station using a **CTS Sentinel C28** instrument with custom-machined aluminum test chambers that match the exact package geometry. The test draws the chamber to -500 mbar and monitors the vacuum decay rate over a 30-second test period. Non-destructive, non-invasive, and 100% testable—every package is verified before it enters the sterile warehouse.

**Results:** 100% seal verification at 4 packages per minute per lane (dual-lane system). Detection reliability validated per ASTM F2095 with 95% confidence on 250-micron defects. Replaced manual dye penetration testing that was destructive (sampling only) and took 24 hours for results. The customer passed their next FDA audit with the test data as supporting evidence for process validation.

### Electronics Power Supply — End-of-Line Functional Test

A contract manufacturer needed a comprehensive end-of-line test for a 48V DC power supply used in industrial controls. The test had to verify 14 electrical parameters, perform hipot testing at 3,000 V AC, measure efficiency under load, and verify thermal shutdown at the over-temperature threshold—all within a 22-second cycle time.

We designed a test station with a custom bed-of-nails fixture for board contact, a **Chroma 63600** programmable electronic load for efficiency testing, a **Chroma 19032** hipot tester for dielectric withstand, and a **Keysight 34970A** data acquisition unit for temperature monitoring. The test sequence is fully automated: the operator loads the board, scans the serial barcode, closes the fixture, and presses start. The PLC sequences through all 14 tests, applies hipot, ramps to full load, and verifies thermal protection—all in 20.5 seconds.

**Results:** Full parametric test in under 22 seconds (meeting line takt). Defect detection rate improved from 94% (previous spot-check approach) to 99.8%. Hipot testing eliminated two field failures per month that had been causing warranty returns. Annual warranty savings: $185,000.

## The ROI of Automated Test Systems

Here's how to think about the business case for automated testing:

**Prevented customer escapes** — A single quality escape at an automotive OEM can cost $50,000–$500,000 between containment sorting, line shutdowns, and chargebacks. In medical devices, a single recalled lot can cost millions. One prevented escape often pays for the test system.

**Reduced scrap and rework** — Real-time SPC data catches process drift before it produces scrap. Our customers typically see 30–50% scrap reductions within 6 months of deploying SPC-enabled test systems, because they're fixing problems at the source instead of sorting at the end.

**Eliminated manual inspection labor** — A fully automated test station running 3 shifts replaces 3–4 inspectors at $50,000–$65,000 fully burdened each. That's $150,000–$260,000 per year in direct labor savings.

**Faster production throughput** — Automated test systems operate at fixed cycle times without the variability of manual testing. We've seen lines increase effective throughput by 15–25% simply by removing the manual test bottleneck.

For a typical single-station automated test system, we see project costs of $75,000–$250,000 depending on complexity, with payback periods of **4–10 months** on high-volume lines.

## Common Challenges and How We Solve Them

**"Our leak test results aren't repeatable shift to shift."** This is almost always a thermal issue. Parts coming off a machining center or wash station are warmer than ambient, and their cavity volume changes as they cool during the shift. We install part temperature measurement (IR pyrometer) and compensate the reject threshold dynamically based on part temperature. Repeatability improves dramatically.

**"We can't achieve the cycle time with adequate test sensitivity."** There's a fundamental tradeoff between test time and sensitivity in pressure-based leak testing. We overcome it by selecting the right technology—mass flow for large volumes, helium for extreme sensitivity—and by optimizing the test sequence to overlap stabilization and measurement phases where possible.

**"Our functional test is too complex to automate."** We haven't found one yet that we couldn't automate. We break complex test sequences into discrete, repeatable steps and use servo actuators, programmable power supplies, and high-speed DAQ to replicate what a test technician does manually—but faster and more consistently. If a human can test it, we can automate it.

**"We need to test multiple variants on the same station."** Recipe-based test systems store parameters, fixture configurations, and pass/fail limits for each part number. A barcode scan automatically loads the correct recipe with zero changeover time. We've built stations that handle 50+ part variants on a single platform.

**"We need data integration with our MES/ERP system."** Every system we build includes standard database connectivity. We output structured test data via OPC UA, SQL, or MQTT and have integrated with Plex, SAP, Oracle, and custom MES platforms. We also build real-time dashboards accessible from any browser on your network.

## Frequently Asked Questions

### What leak rate can you detect with pressure decay vs. helium testing?

Pressure decay reliably detects leaks down to approximately 0.1 scc/s, depending on part volume, test pressure, and environmental conditions. Mass flow extends that to about 0.01 scc/s. Helium vacuum testing pushes sensitivity to 1×10⁻⁵ scc/s or below—roughly 10,000 times more sensitive than basic pressure decay. We recommend the least expensive method that meets your specification with margin.

### How do you determine the right reject threshold for a leak test?

We start with your functional leak rate requirement—the leak rate that would cause a product failure in the field. Then we add a safety margin (typically 3–5x) and validate the reject threshold against known-good and known-bad parts during the test development phase. We use Gauge R&R studies to confirm the test system's measurement capability relative to the reject threshold, targeting a Gauge R&R under 10%.

### Can you test parts at elevated temperature or pressure?

Yes. We build test systems that operate at temperatures from -40°C to +150°C using thermal chambers, heated fixtures, or cryogenic cooling. Pressure ranges extend from vacuum to 100+ bar depending on the application. High-pressure and high-temperature testing requires specialized safety engineering—burst containment, pressure relief, and SIL-rated safety circuits—which we design into every system.

### What cycle time can you achieve for leak testing?

Cycle times range from 5 seconds for simple pressure decay tests on small parts to 60+ seconds for high-sensitivity helium tests on large volumes. For our [assembly line](/solutions/assembly/) integrations, we design the test station cycle time to match the line takt. If the test inherently takes longer than takt, we use multiple parallel test stations feeding a common conveyor to maintain throughput.

### How do you handle false rejects and false passes?

False rejects waste production capacity; false passes ship defective products. We attack both through rigorous test development: environmental compensation (temperature, barometric pressure), adequate stabilization times, proper seal design, and statistical validation against known reference parts. Our target is always less than 0.5% false reject rate with zero false passes on defects exceeding the reject threshold.

### Do your test systems comply with automotive and medical quality standards?

Absolutely. For automotive programs, we design to IATF 16949 requirements including Measurement System Analysis (MSA), full traceability, and AIAG SPC charting. For [medical devices](/industries/medical/), we provide IQ/OQ/PQ validation documentation, 21 CFR Part 11-compliant data systems, and risk analysis per ISO 14971. We also support [process optimization](/services/process-optimization/) through the test data our systems generate.

### Can test systems be added to our existing production line?

Yes. We regularly retrofit test stations into existing lines—integrating with your current conveyor, [robotic cells](/solutions/robotic-cells/), or [material handling](/solutions/material-handling/) systems. We evaluate your line layout, available floor space, and cycle time requirements, then design the test station for minimal disruption during installation. Many retrofit projects are installed and validated during a planned shutdown weekend.
