# System Architecture Notes

*Written for the Alpha & Omega Semiconductor System Architect framing —
this document should read as architecture-level reasoning, not RTL detail.
A reviewer should understand your design tradeoffs without reading any code.*

## 1. System Block Diagram
(Insert a diagram here — see Week 5 resource: draw.io. Show the mini-GPU's
major blocks: instruction fetch/decode, ALU lanes, FIFO, arbiter, cache,
and how data/control flows between them.)

## 2. Interfaces Between Blocks
| Interface | Signals | Purpose |
|---|---|---|
| FIFO → Arbiter | | |
| Arbiter → ALU lanes | | |
| ALU lanes → Cache | | |

## 3. Memory Map / Addressing Scheme
- How instruction and data addresses are structured
- Cache index/tag split rationale (why this NUM_LINES, why this associativity)

## 4. Key Architectural Tradeoffs
For each major decision, capture: what you chose, what the alternative was,
and why you chose what you chose. This is the section an interviewer will
actually ask you to defend.

| Decision | Chosen approach | Alternative considered | Why |
|---|---|---|---|
| Number of SIMD lanes | | | |
| Arbiter policy (fixed vs. round-robin vs. weighted) | | | |
| Cache associativity | | | |
| FIFO depth | | | |

## 5. Power Considerations
(Ties to the Week 9 power-aware add-on — e.g. clock gating on idle lanes)
- Where is power being spent in this design?
- What technique did you add, and what's the estimated benefit?
- What would you do next if you had more time/tools (e.g. power gating, DVFS)?

## 6. Area vs. Performance vs. Power Tradeoffs
Summarize, at a system level, where this design sits on the classic
area/power/performance triangle, and why that's the right choice for
the stated use case.
