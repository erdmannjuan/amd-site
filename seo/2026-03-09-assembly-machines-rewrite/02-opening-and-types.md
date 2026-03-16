# Section 1: Opening + Section 2: Types of Automated Assembly Systems

---

## Opening (replaces intro + "What Are Automated Assembly Machines")

AMD Machines has built automated assembly machines for over 30 years. More than 2,500 systems delivered — rotary indexing, linear transfer, robotic cells, and hybrid configurations that combine multiple architectures on a single line. Our machines assemble products across automotive, medical device, consumer goods, and electronics manufacturing. We handle every phase from concept and process development through build, debug, and commissioning at the customer's plant.

The architecture you choose for an automated assembly system determines its throughput ceiling, its flexibility when products change, and its cost per assembled part. There is no universal best choice. A rotary indexer that excels at high-speed valve assembly would be the wrong platform for a medical device with 30 process steps and annual volumes under 50,000 units. We have built enough of both to know where each architecture breaks down, and that experience drives our recommendations before a single CAD model is created.

---

## Types of Automated Assembly Systems

### Rotary Indexing Machines

A rotary indexing machine mounts tooling nests on a circular dial that indexes between fixed stations. Each index moves every nest simultaneously, and all stations operate in parallel on different parts.

We recommend rotary indexers when the assembly has a small number of balanced operations — typically 8 to 15 stations — and high annual volumes justify the tooling investment. Cycle times of 3 to 8 seconds per index are standard, producing throughput rates that linear and robotic systems cannot match at equivalent cost. The compact footprint is another advantage: a 12-station dial takes roughly the floor space of two desks.

Where rotary does not work: assemblies with widely varying station cycle times, processes that require long dwell (curing, leak testing with extended hold), or products that need frequent changeover. Every station on a dial runs at the speed of the slowest station. If one operation takes 12 seconds while the rest take 4, you are wasting two-thirds of the capacity at every other station. In those cases, a linear transfer system with independent station timing is the better architecture.

### Linear Transfer Systems

Linear transfer is our most common architecture, and for good reason. A pallet or workpiece carrier moves along a track — belt, chain, walking beam, or servo-driven — stopping at each station for its specific operation. Stations operate with independent cycle times, which means a 5-second press operation and a 14-second leak test can coexist on the same line without one penalizing the other.

Linear systems scale from 6 stations to 40 or more. You can start with a core set of operations and add stations later as volumes grow or processes change. That scalability matters when a product is in early production and the final assembly sequence is still being refined. Typical station cycle times range from 5 to 15 seconds depending on process complexity, supporting annual volumes from 100,000 to 2,000,000 units. The tradeoff is footprint — a 30-station linear system takes real floor space — and higher upfront engineering since each station is independently designed.

### Robotic Assembly Cells

A [robotic assembly cell](/solutions/robotic-cells/) uses one or more industrial robots as the primary motion platform. The robot handles part manipulation, process execution, or both — picking components from feeders, presenting them to fixed tooling, and moving the assembly between operations within the cell.

Robotic cells are the right choice when you need the widest part range, complex multi-axis motions, or the ability to change products by loading a new program rather than retooling the machine. Cycle times of 10 to 30 seconds per assembly are typical, with the volume sweet spot at 10,000 to 500,000 units per year. Program changes take minutes, not hours or days. The tradeoff is that a robot performing sequential operations will never match the throughput of a dedicated dial or transfer line running parallel stations — physics does not allow it. For volumes above 500,000 units annually, robotic cells usually need to be duplicated rather than sped up.

### Collaborative Robot Stations

Cobots have a place in assembly, but it is narrower than the marketing suggests. A collaborative robot station operates without full safety guarding, allowing an operator to work alongside the robot in a shared workspace. That is a genuine advantage when floor space is constrained, volumes are low, and the process requires a mix of human judgment and automated consistency.

Where cobots actually make sense: low-volume assembly (1,000 to 100,000 units per year), tasks that benefit from operator flexibility combined with robotic repeatability — things like applying sealant while the operator positions a gasket, or driving fasteners on assemblies that are awkward to fixture. Cycle times run 15 to 45 seconds per assembly. Where cobots do not make sense: high-speed operations where force and speed limitations reduce throughput below manual rates, or fully automated lines where the "collaborative" capability provides no benefit because no operator is present. We spec cobots when they solve a real problem, not because they look good in a facility tour.

---

### Comparison Table

| System Type | Best For | Typical Cycle Time | Volume Sweet Spot | Changeover Time | Relative Cost |
|---|---|---|---|---|---|
| Rotary Indexing | High-volume, balanced ops, compact | 3–8 sec/index | 500K–5M+ units/yr | Hours to days | $$ |
| Linear Transfer | Scalable, varying cycle times, larger parts | 5–15 sec/station | 100K–2M units/yr | Hours | $$–$$$ |
| Robotic Cells | Medium volume, high mix, complex motions | 10–30 sec/cycle | 10K–500K units/yr | Minutes | $$$ |
| Cobot Stations | Low volume, shared workspace | 15–45 sec/cycle | 1K–100K units/yr | Minutes | $ |

---

### Choosing the Right Architecture

The decision between these four types of automated assembly machinery comes down to three variables: your annual volume, the number and complexity of process steps, and how often the product changes. High volume with stable product design points toward rotary or linear. Frequent changeovers and moderate volumes favor robotic cells. Low volumes with mixed human-automation workflows are where cobots earn their cost back.

In practice, many of the systems we build are hybrids. A linear transfer backbone with robotic stations at complex process steps and dedicated fixed tooling at high-speed operations. The architecture should follow the process requirements — not the other way around. We start every project with a detailed process analysis and cycle time study, then match the platform to the data. That approach has worked across 2,500 machines, and it eliminates the most expensive mistake in assembly automation: choosing the wrong architecture and discovering it after the machine is built.
