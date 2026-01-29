---
title: Commissioning and Startup Best Practices
description: Proven commissioning and startup procedures for industrial automation systems,
  covering FAT, SAT, I/O verification, safety validation, and production ramp-up strategies.
keywords: automation commissioning, equipment startup, factory acceptance testing, site
  acceptance testing, I/O checkout, safety validation, production ramp-up, OEE verification
date: '2025-03-12'
author: AMD Machines Team
category: Business
read_time: 7
template: blog-post.html
url: /blog/commissioning-and-startup-best-practices/
---

## Why Commissioning Matters More Than Most Teams Realize

Commissioning is the phase where an automation project either delivers on its promises or falls short. You can have the best mechanical design, the cleanest electrical panel, and the most elegant PLC code—but if commissioning is rushed or poorly structured, the system will struggle to hit rate, quality targets will slip, and your maintenance team will inherit problems that should have been caught before handoff.

After delivering over 2,500 custom automation systems, we have seen the same patterns repeat. The projects that go smoothly during startup share common traits: structured procedures, clear acceptance criteria, and enough time budgeted for the unexpected. The ones that struggle almost always skipped steps during commissioning to save a week on the schedule.

## Factory Acceptance Testing (FAT)

The commissioning process should begin at the integrator's facility, not on your plant floor. A thorough factory acceptance test catches issues when they are cheapest and easiest to fix—before the equipment ships.

A solid FAT should cover:

- **Mechanical verification.** Check stroke lengths, clearances, fixture alignments, and tooling interfaces. Run actuators through their full range and verify they do not bind or interfere with adjacent components.
- **Electrical verification.** Confirm wire labels match drawings, verify terminal torques, and check cable routing for proper separation between power and signal conductors. Walk down every [safety circuit](/blog/safety-plc-and-safety-system-design/) to verify correct operation of e-stops, light curtains, and interlocked guards.
- **Software walkthrough.** Step through every operating mode—automatic, manual, maintenance, fault recovery. Trigger each fault condition and verify the HMI displays the correct message with actionable guidance for the operator.
- **Cycle time verification.** Run continuous automatic cycles and measure actual cycle time against the specification. If the system cannot hit rate at the integrator's facility with ideal conditions, it will not hit rate on your floor.

Document everything. A FAT checklist is not bureaucracy—it is your insurance policy against shipping problems to your plant.

## Site Preparation and Installation

While the equipment is being built, your facility needs to be ready to receive it. This parallel work stream is frequently underestimated.

Key site preparation items include:

- **Utilities.** Confirm electrical service matches panel requirements (voltage, phase, amperage). Verify compressed air capacity and pressure at the point of use, not just at the compressor. Check coolant supply if the process requires it.
- **Floor conditions.** Level the installation area and verify the floor can support static and dynamic loads. For precision assembly systems, floor vibration can directly affect process capability.
- **Rigging plan.** Know the equipment dimensions, weight, and center of gravity before delivery day. Identify door clearances, ceiling heights, and crane capacity. Many systems arrive in sections that must be reassembled on site—plan the sequence.
- **Network infrastructure.** If the system connects to an [MES or data historian](/blog/manufacturing-execution-systems-mes-fundamentals/), have network drops and IP addresses assigned before the equipment arrives.

## I/O Checkout and Point-to-Point Verification

Once the equipment is installed and powered up, the first commissioning step is a methodical I/O checkout. Every input and output on the PLC should be verified against the electrical drawings.

For inputs, physically actuate each sensor and confirm the correct bit toggles in the PLC. For outputs, force each output individually and confirm the correct device energizes. This tedious process catches miswired connections, failed devices, and drawing errors before they cause confusion during higher-level debugging.

Pay special attention to analog signals. Verify that 4-20mA signals read correctly at zero, mid-range, and full scale. A pressure transducer that reads 3.8 mA at zero will cause control problems that are difficult to diagnose later if the calibration is not verified upfront.

## Safety System Validation

Safety validation is not optional, and it is not something to rush through on a Friday afternoon. Every safety function must be tested and documented per the system's risk assessment.

This includes:

- **E-stop circuits.** Press every e-stop button individually and verify the system reaches a safe state. Verify that reset requires deliberate action and the system does not auto-restart.
- **Guard interlocks.** Open every guarded door and verify motion stops. Confirm that the system cannot be restarted with the door open.
- **Light curtains and area scanners.** Verify detection zones with test pieces at specified heights and positions.
- **Safety-rated monitored speed and position functions.** If the system uses collaborative modes, verify speed and force limits with calibrated instruments.

Document each test with pass/fail results, the tester's name, and the date. This documentation is not just good practice—it is a regulatory expectation in most jurisdictions.

## Production Ramp-Up

With I/O verified and safety validated, the system is ready for production ramp-up. Resist the temptation to go straight to full rate. A staged ramp-up catches issues that only appear under sustained production conditions.

**Phase 1: Dry cycling.** Run the system without product to verify motion sequences, timing, and handshake logic. Watch for unexpected collisions, missed sensor transitions, and race conditions in the software.

**Phase 2: Low-rate production.** Introduce product at reduced speed. Verify process quality at each station. For assembly operations, measure critical dimensions and check process capability (Cpk). For [welding systems](/blog/stainless-steel-welding-best-practices/), run destructive test samples.

**Phase 3: Rate verification.** Increase to target speed and run continuously for a defined duration—typically two to four hours minimum. Track OEE during this period: availability, performance, and quality. The system should demonstrate sustained operation at or above the specified rate with acceptable quality.

**Phase 4: Endurance run.** Some contracts require a 24-hour or multi-shift endurance run at full rate. This is where intermittent issues surface—thermal drift, consumable depletion rates, chip or debris accumulation, and operator fatigue factors.

## Training and Documentation Handoff

A system is not truly commissioned until the people who will run and maintain it are prepared. Training should happen during ramp-up, not after the integrator leaves.

Operator training should cover normal operation, changeover procedures, and basic fault recovery. Maintenance training should include preventive maintenance schedules, spare parts identification, and troubleshooting procedures for the most common fault scenarios.

Ensure your team receives complete documentation: electrical schematics, mechanical drawings, PLC program backups, HMI application files, and a maintenance manual. Every custom automation system is unique, and your maintenance team cannot rely on generic manuals from component vendors alone.

## Common Commissioning Mistakes

Based on decades of project experience, these are the pitfalls we see most often:

- **Compressing the schedule.** Cutting commissioning time to recover schedule delays from earlier phases is the single most common and most costly mistake.
- **Skipping the FAT.** Traveling to the integrator's facility costs time and money, but discovering problems after installation costs far more.
- **Insufficient operator involvement.** Operators who first see the system on production day will struggle. Involve them during ramp-up so they build familiarity and ownership.
- **Incomplete punch lists.** Every open item identified during commissioning should be tracked with an owner, a due date, and a clear description. Verbal agreements to fix things later get forgotten.

## Setting Up for Long-Term Success

Commissioning is not the end of the project—it is the beginning of the system's productive life. The data collected during ramp-up establishes your performance baseline. The procedures validated during startup become your standard operating procedures. The relationships built between your team and the integrator's engineers become your support network.

Invest the time to commission properly, and the system will reward you with years of reliable production. Cut corners, and you will spend the first six months in reactive mode, chasing the problems that should have been resolved before the integrator packed up and left.

AMD Machines provides comprehensive commissioning support as part of every automation project. Our field service engineers stay on site through production validation, and our support team remains available long after startup is complete. [Contact us](/contact/) to discuss your next project.
