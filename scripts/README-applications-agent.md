# Application-page population system

Iteratively turns the `/applications/<slug>/` **stubs** into deep, SEO-optimized,
buyer-focused landing pages — **one page per fresh Claude Code agent** so quality
never degrades across the batch.

## Files
| File | Purpose |
|------|---------|
| `populate-applications.sh` | The safeguarded SERIAL runner (one agent at a time, full live streaming). |
| `populate-parallel.sh` | The PARALLEL runner — N agents at once on different pages, coordinated by an atomic claim board. |
| `application-page-prompt.md` | The gold-standard per-page prompt each agent receives (`{{PAGE}}`/`{{SLUG}}` are substituted per page). |
| `validate_application_page.py` | Hard quality gate run after every page (word count, links, title/meta length, single-H1, FAQ schema source, no links to removed pages, indexable). |

## Run multiple bots in parallel
```bash
scripts/populate-parallel.sh --board              # show the claim board, do nothing
scripts/populate-parallel.sh --workers 3 --yes    # 3 agents at once over all pending
scripts/populate-parallel.sh --workers 4 --limit 8 --yes
```
**The claim board (rank 1/2/3):** 1 = finished, 2 = being worked on, 3 = pending start.
A worker may only begin a page after **atomically claiming it** (a lock in `locks/` —
the OS guarantees two bots can never claim the same page). The board prints every few
seconds and is exported to `logs/status-board.csv`, which you can open in Excel/Numbers
as a read-only progress view.

**Built-in contention safety:** site builds + git commits are serialized behind a global
lock (concurrent builds would clobber `output/`); builds retry to ride out another
worker's mid-write moment; any failure halts ALL workers; per-worker traps + a stale-lock
sweep give the same stop-anything-anytime guarantees as the serial runner.

**Rules of thumb:**
- **Never run the serial and parallel runners at the same time** (the serial runner
  doesn't take the global build lock).
- 2–4 workers is the sweet spot. Parallel agents consume your Claude plan limits
  N× faster — on a Pro plan, 3+ workers can hit the 5-hour window cap mid-run
  (harmless: the run halts; resume after the window resets).

## Prerequisites
- [Claude Code CLI](https://docs.claude.com) installed and authenticated (`claude` on your PATH).
- Python 3 with PyYAML (`pip install pyyaml --break-system-packages`).
- Run from anywhere inside the repo.

## Quick start
```bash
# See progress (no agents launched)
scripts/populate-applications.sh --status

# See exactly what the next run would do
scripts/populate-applications.sh --dry-run

# Process the next batch (default 3 pages), with a confirmation prompt
scripts/populate-applications.sh

# Unattended: process the next 5 pages, no prompt
MAX_PAGES=5 scripts/populate-applications.sh --yes

# Do a single specific page (great for a first test)
scripts/populate-applications.sh --page automated-leak-test-stations --yes
```
Re-run it as many times as needed — it always resumes from the next unfinished page
(it reads each page's `status:` / `noindex:` frontmatter to know what's done).

## Why quality stays high
Each page is handled by its **own `claude` process** (fresh context). The runner never
asks one agent to do several pages, which is what caused your quality to fall off a cliff
after page one.

## Safeguards (so you never waste tokens)
- **Per-page turn cap** — `MAX_TURNS` (default 60) limits agent tool-calls per page.
- **Per-page timeout** — `TIMEOUT_SECS` (default 1800s) hard-kills a stuck agent.
- **Batch cap** — `MAX_PAGES` (default 3) limits how many pages per invocation.
- **Quality gate** — after each page, `validate_application_page.py` must pass.
- **Build gate** — `python3 build.py` must succeed before the page is accepted.
- **Halt on first failure** — `HALT_ON_FAIL=1` stops the whole run if anything fails,
  so a bad agent can't burn tokens across the rest of the batch.
- **Per-page commit** — each accepted page is committed on its own, so progress is saved
  and any single page is trivial to revert.

## Live progress
Every agent's steps stream to your terminal as they happen — tool calls with elapsed
time, the agent's working notes, and a final line with turn count and approximate cost:
```
    [00:03] ▶ agent session started (model: claude-sonnet-4-6)
    [00:11] → WebSearch: robotic screwdriving torque verification systems
    [02:40] → Edit: content/applications/robotic-screwdriving-systems.md
    [07:12] ■ agent finished (success) · 38 turns · ~$1.40
    Status: 4 complete · 14 pending
```
The raw event log is kept in `logs/<slug>.log`. Set `STREAM=0` for the old quiet mode
(also the fallback if your `claude` CLI is too old for `--output-format stream-json`).

## Stopping safely — you can stop it at ANY time, nothing breaks
- `touch STOP` (graceful): finishes the current page — validation, build, commit — then exits.
- **Ctrl-C / `kill <pid>`** (immediate): the trap shuts the agent down and restores the
  in-flight page to its last committed state before exiting.
- **`kill -9` / crash / power loss** (hard): the run journals which page is in flight
  (`logs/.inflight`); the NEXT invocation — even just `--status` — detects the leftover,
  auto-restores that page, and resumes cleanly.
- Completed pages are committed the moment they pass, so finished work can never be lost,
  and nothing reaches the live site until **you** `git push`.
- Extra net: any other uncommitted application-page changes found at startup are skipped
  (protects your manual edits); discard interrupted-run leftovers with `--reset-dirty`.

## What "done" means (the gate)
A page only counts as complete when its agent has set `status: complete` + `noindex: false`
AND it passes the **visual-first** gate: 550–1,600 body words (skimmable, never a wall of
text), ≥1 data table, ≥2 figure slots, ≥5 `at_a_glance` items, ≥4 FAQ items in frontmatter
(FAQ must NOT be duplicated in the body — the template renders the accordion + schema),
≥5 internal links, title ≤60 chars, meta ≤155 chars, exactly one H1, no links to the removed
medical/pharma pages, and a clean site build.

## Tuning (env vars)
```
MAX_PAGES=3 MAX_TURNS=60 TIMEOUT_SECS=1800 MODEL=
PERMISSION_MODE=acceptEdits CLAUDE_EXTRA_ARGS= STREAM=1
MIN_WORDS=550 MAX_WORDS=1600 MIN_INTERNAL_LINKS=5 MIN_FAQ=4
MIN_FIGURES=2 MIN_TABLES=1 MIN_GLANCE=5
HALT_ON_FAIL=1 REVERT_ON_FAIL=0 COMMIT=1
```
- For a fully hands-off run you may need broader tool permissions:
  `CLAUDE_EXTRA_ARGS="--dangerously-skip-permissions" scripts/populate-applications.sh --yes`
  (only do this in a repo you trust — it lets the agent run tools without prompting).
- `MODEL=claude-sonnet-4-6` (or another model string) to pin the model.

## SEO architecture (how these pages avoid cannibalizing /solutions/*)
- **Solution pages keep the broad head terms.** Application pages target **narrower,
  buyer-intent long-tail clusters** (each page's `primary_keyword`), registered in the
  keyword map in `CLAUDE.md`.
- **Pillar ↔ spoke linking:** every application links up to its parent solution and across
  to siblings; the hub links down. Authority concentrates instead of splitting.
- **No thin pages indexed:** stubs ship `noindex: true` and are excluded from `sitemap.xml`.
  A page only becomes indexable when the agent finishes it and the gate passes.

## After the run
- Drop real images into `static/images/applications/` using the placeholder filenames the
  pages reference (`<slug>.webp` for hero/cards, `<slug>-1.webp`, `<slug>-2.webp` inline).
- `python3 build.py`, review locally, then `git push origin main` to deploy.

Logs for each page are in `logs/<slug>.log` (gitignored).
