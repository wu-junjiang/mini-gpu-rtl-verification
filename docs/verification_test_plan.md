# Verification Test Plan — Mini-GPU Project

*Fill this in as you go — a real test plan is written before/alongside the
testbenches, not after. Keep it updated; this document itself is a portfolio
artifact, not just working notes.*

## 1. Design Under Test (DUT) Overview
- Brief description of what's being verified this week (FIFO / arbiter / cache / mini-GPU datapath)
- Block diagram reference (link to `/docs/architecture_notes.md` or an image)

## 2. Features to Verify
| # | Feature | Priority |
|---|---|---|
| 1 | e.g. FIFO never reports full and empty simultaneously | High |
| 2 | e.g. Round-robin arbiter grants each requester within N cycles under sustained requests | High |
| 3 | | |

## 3. Corner Cases to Target
- Reset mid-operation
- Simultaneous read+write (FIFO)
- All requesters asserting simultaneously (arbiter)
- Back-to-back miss-then-fill on the same cache line

## 4. Verification Approach per Feature
| Feature | Method (directed / randomized / formal) | Tool |
|---|---|---|
| | | |

## 5. Coverage Goals
- What combinations of inputs/states must be exercised before you consider this "verified"?
- e.g. "every arbiter requester count from 0 to N asserted simultaneously, at least 10 times each"

## 6. Bug Log
See `/docs/bug_log.md` — this is where actual found bugs get recorded (Week 8 exercise).

## 7. Sign-off Criteria
- All directed tests pass
- Coverage goals met (or gaps explicitly justified)
- At least one formal property proven where applicable
