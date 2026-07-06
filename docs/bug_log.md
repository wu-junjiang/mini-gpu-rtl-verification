# Bug Log

Week 8 exercise: deliberately inject 3-5 subtle bugs into working modules,
confirm your verification catches each one, then record them here. This is
one of the strongest interview artifacts in the whole project — treat it
as a real deliverable, not a formality.

Real example from building the FIFO starter code in this repo (kept here as
a template for the format expected below):

## Bug #0 (found while building the starter code, not deliberately injected)
- **Module:** `verification/tb_fifo_sync.v`
- **Symptom:** Reads returned stale/incorrect data intermittently; reset-clear check failed.
- **Root cause:** Testbench checked `rd_data` in the same simulation-time Active
  region as the clock edge that updated it via non-blocking assignment (`<=`).
  This is a classic race condition — the DUT's NBA update hadn't settled yet
  when the check ran.
- **How it was found:** Directed test comparing expected vs. actual read values
  failed inconsistently on specific reads, not all of them — a signature of a
  timing race rather than a logic bug.
- **Fix:** Added a `tick()` task that waits `#1` after every `@(posedge clk)`
  before sampling DUT outputs, letting NBA updates settle first.

---

## Bug #1 (deliberately injected)
- **Module:**
- **Symptom:**
- **Root cause:**
- **How it was found:** (which test/coverage gap exposed it)
- **Fix:**

## Bug #2 (deliberately injected)
- **Module:**
- **Symptom:**
- **Root cause:**
- **How it was found:**
- **Fix:**

## Bug #3 (deliberately injected)
- **Module:**
- **Symptom:**
- **Root cause:**
- **How it was found:**
- **Fix:**
