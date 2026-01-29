---
title: Data Acquisition and Historian Systems
description: How to design and implement data acquisition and historian systems for
  automated manufacturing, covering sensor integration, data architecture, and analytics
  strategies for production optimization.
keywords: data acquisition, historian systems, manufacturing data, SCADA, process
  data, production analytics, OPC UA, time-series database, industrial IoT
date: '2025-04-11'
author: AMD Machines Team
category: Guides
read_time: 12
template: blog-post.html
url: /blog/data-acquisition-and-historian-systems/
---

## Why Data Acquisition Matters in Modern Manufacturing

Every automated production line generates data — temperatures, pressures, cycle times, torque values, pass/fail results, robot positions, and hundreds of other variables. The question is whether that data gets captured, stored, and turned into something useful, or whether it simply evaporates at the end of each shift.

Data acquisition (DAQ) systems and process historians solve this problem by collecting machine-level data in real time and storing it in time-series databases that support long-term trending, root cause analysis, and regulatory compliance. When implemented correctly, these systems become the backbone of continuous improvement programs, giving engineers the evidence they need to optimize processes, reduce scrap, and predict equipment failures before they cause downtime.

At AMD Machines, we integrate data acquisition into the [automated systems](/solutions/assembly-automation/) we build, ensuring that the data infrastructure is designed alongside the mechanical and controls architecture — not bolted on as an afterthought.

## Core Components of a DAQ System

A manufacturing data acquisition system has four main layers, each with its own design considerations.

### Sensor and Field Device Layer

This is where data originates. Sensors, transducers, encoders, load cells, thermocouples, flow meters, and vision systems all produce raw signals that need to be captured. The key decisions at this layer include:

- **Signal type** — analog (4-20mA, 0-10V), digital (discrete I/O), or fieldbus (EtherNet/IP, PROFINET, IO-Link)
- **Sample rate** — how frequently the signal needs to be read to capture meaningful process variation
- **Resolution** — the bit depth of analog-to-digital conversion, which determines the smallest detectable change
- **Environmental protection** — IP ratings, EMI shielding, and cable routing for harsh plant environments

A common mistake is over-specifying sample rates. A temperature measurement on a curing oven might need a reading every 5 seconds, while a press force signature during a stamping operation might require 10 kHz sampling to capture the full force curve. Matching sample rate to actual process dynamics avoids both data gaps and storage bloat.

### Data Collection and Aggregation Layer

PLCs, PACs, and dedicated DAQ hardware sit at this layer, converting raw sensor data into structured process values. Modern [PLC platforms](/blog/plc-memory-types-and-organization/) handle much of this natively — most controllers can timestamp data, buffer it during network interruptions, and push it to higher-level systems via OPC UA or MQTT.

For high-speed data collection that exceeds PLC scan rates, dedicated DAQ modules from vendors like National Instruments, HBM, or Beckhoff provide multi-channel analog input at sampling rates from kilohertz to megahertz. These modules typically connect to the plant network via EtherCAT or dedicated Ethernet interfaces.

Edge computing devices are increasingly common at this layer, performing local aggregation, filtering, and compression before forwarding data upstream. This reduces network bandwidth requirements and keeps the historian focused on storing meaningful data rather than raw noise.

### Historian and Storage Layer

The historian is the central time-series database that stores process data for long-term access. Unlike relational databases designed for transactional workloads, historians are optimized for sequential writes and time-range queries — the two dominant patterns in manufacturing data.

Leading historian platforms include OSIsoft PI (now AVEVA PI), GE Proficy Historian, Honeywell PHD, Wonderware (AVEVA) Historian, and InfluxDB. Selection criteria include:

- **Compression efficiency** — historians use lossy compression algorithms (like swinging door compression) that dramatically reduce storage requirements while preserving process trends within configurable deadbands
- **Query performance** — how quickly engineers can retrieve and visualize years of production data
- **Integration ecosystem** — connectors to PLCs, SCADA systems, MES platforms, and analytics tools
- **Scalability** — the number of tags (data points) the system can handle, from thousands to millions
- **High availability** — failover and redundancy for continuous data capture

A mid-size automated production line might generate 500 to 2,000 data tags. A large plant with dozens of lines and utility systems can easily exceed 50,000 tags. Sizing the historian correctly from the start prevents painful migrations later.

### Visualization and Analytics Layer

Raw data in a historian has limited value until it is presented in a way that supports decision-making. This layer includes:

- **Real-time dashboards** — live process displays showing current machine states, OEE metrics, and alarm summaries
- **Trend analysis tools** — overlaying multiple tags across time to identify correlations between process variables
- **Statistical process control (SPC)** — control charts that flag when a process is drifting out of specification before it produces defective parts
- **Reporting and compliance** — automated batch reports, shift summaries, and regulatory documentation

Modern analytics platforms add machine learning capabilities on top of historian data, enabling predictive maintenance models that identify bearing degradation, pump cavitation, or motor overheating patterns weeks before failure occurs.

## Architecture Decisions That Matter

### Polling vs. Exception-Based Collection

Polling collects data at fixed intervals regardless of whether values have changed. Exception-based (report-by-exception) collection only transmits data when a value changes beyond a configured deadband. Most historians use exception-based collection to minimize storage, but critical safety and quality parameters may warrant fixed-interval polling to guarantee no gaps exist in the record.

### Edge vs. Cloud Storage

On-premise historians provide low-latency access and keep sensitive production data inside the plant network. Cloud-based historians (or cloud extensions of on-premise systems) enable cross-plant analytics, remote monitoring, and scalable compute for advanced analytics. Many manufacturers adopt a hybrid approach — local historians for real-time operations with cloud replication for enterprise analytics and long-term archival. For more on this decision, see our guide on [cloud vs. on-premise approaches for manufacturing data](/blog/cloud-vs-on-premise-for-manufacturing-data/).

### Data Contextualization

Raw tag data (Tag_12345 = 47.3 at timestamp T) is nearly useless without context. Effective DAQ systems associate each data point with metadata: which machine, which product, which batch, which operator, which recipe. This contextualization — often called an asset model or equipment hierarchy — transforms raw numbers into answers. Instead of asking "what was Tag_12345 at 2pm?", engineers can ask "what was the curing temperature on Line 3 during Batch 4472?"

Building this context model early in the system design saves enormous effort compared to retroactively mapping tags to equipment after years of data accumulation.

## Implementation Best Practices

### Start With the Questions You Need to Answer

Before selecting hardware or software, define the questions your data system needs to answer. Common examples include:

- What is our actual OEE by line, shift, and product?
- Which process parameters correlate with scrap events?
- Are we meeting regulatory requirements for environmental monitoring?
- What is the mean time between failures for critical equipment?
- How do cycle time distributions change over a tool's wear life?

These questions drive tag selection, sample rates, retention policies, and visualization requirements. Working backward from desired outputs prevents both over-collection (storing everything "just in case") and under-collection (missing the one variable that explains a quality problem).

### Design for Data Integrity

Data acquisition systems must handle real-world conditions: network interruptions, PLC restarts, time synchronization drift, and sensor failures. Design features that protect data integrity include:

- **Store-and-forward buffering** at the edge, so data is not lost during network outages
- **NTP or PTP time synchronization** across all devices, ensuring events from different systems can be correlated accurately
- **Bad-quality flagging** that marks data from suspect sensors rather than recording false values
- **Redundant collection paths** for critical process variables

### Plan Retention and Archival

Not all data needs to live in the active historian forever. Define retention tiers: high-resolution data for recent production (weeks to months), downsampled data for medium-term trending (months to years), and compressed archives for regulatory compliance (years to decades). Automated lifecycle management moves data between tiers without manual intervention.

## The ROI of Getting Data Right

Manufacturers who invest in solid data acquisition infrastructure consistently find that the payback extends far beyond the original justification. A system installed for quality traceability ends up driving energy optimization. A historian deployed for regulatory compliance becomes the foundation for predictive maintenance. Data that was collected for one purpose reveals patterns that improve processes in entirely unexpected ways.

The key is building the infrastructure — sensors, networks, historians, and context models — with enough rigor and flexibility to support uses that have not been imagined yet. That requires treating data acquisition as a core engineering discipline, not as an IT project that happens after the machines are running.

## Partner With AMD Machines

AMD Machines designs data acquisition architectures as an integral part of our automation systems. From sensor selection and PLC programming to historian configuration and dashboard development, our engineers build systems that capture the data you need and present it in ways that drive better decisions. [Contact us](/contact/) to discuss how we can help you turn production data into a competitive advantage.
