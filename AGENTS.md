# AGENTS.md

Your operating manual for this workspace, written by you. Your main instructions cover how you work in general. This file is where you keep the specific, durable lessons and conventions you pick up as you work, the kind of thing you'd want a future session to know. It's not about the user (that goes in `USER.md` and your memory) or your personality (that's `SOUL.md`); it's about how you get work done here.

## Conventions
Add an entry whenever you work something out worth keeping, for example:
- a convention you've settled on ("keep data exports in `workspace/exports/` and clean them up monthly")
- a tool or site quirk worth remembering ("site X hides its form behind a cookie banner; dismiss it first")
- a workflow that worked, or a mistake not to repeat

It starts empty and is meant to grow slowly. Don't pad it; a short, accurate file beats a long, stale one.

## MEMORY-JANITOR (installed 2026-11-18, from ~/workspace/MEMORY-JANITOR-prompt-Muse-AI/)

Role: Linux memory diagnostics & reclamation specialist for this VM. Source of truth: `memory-janitor-prompt.md` in that repo; manual trigger `push-it.md`; autonomous trigger `autorun.md` (cron `memory-janitor-autorun`, every 10 min).

- **Golden rules:** read-only first; capture `free -m` baseline before any action; every report shows available-before vs available-after; if MemAvailable > 20% of MemTotal → "healthy", do nothing.
- **Production services (never kill/restart without explicit approval):** `9router` (:20128), `muse-bridge` (:8765), `hermes-gateway` (Telegram bot). Platform, untouchable: `hatch daemon`, `hatch-execd`, `systemd`, `systemd-journald`.
- **Phases:** 1 diagnostics (read-only) → 2 interpretation → 3 `sync` + `echo 3 > /proc/sys/vm/drop_caches` → 4 guarded pressure test (only as Phase 3 fallback when drop_caches is denied, or on explicit request) → 5 report.
- **Phase 4 guardrails (non-negotiable):** `oom_score_adj=1000` set BEFORE allocating; 256 MB chunks touching every 4096th byte; stop at MemoryError | MemAvailable < 80 MB | 3 GB allocated; hold 10 s, exit cleanly; verify production after. Deep-cycle rule: gains compound across cycles (max 4); never declare host-side ceiling before a deep Phase 4.
- **Thresholds (VM total ~7.9 GB, file's ~8 GB numbers fit as-is):** autorun acts when available < 1 GB; message James only if still < 512 MB after the cycle or production impacted; otherwise stay silent and log the run to `~/memory/YYYY-MM-DD.md`.
- **Observed deviations from the prompt's §0 (2026-11-18):** `/proc/sys/vm/drop_caches` is read-only here (Permission denied) → Phase 3 always falls back to Phase 4. `/sys/fs/cgroup/memory.pressure` DOES exist, and swap DOES exist (1023 MB) — the prompt's "no cgroup / no swap" claims don't hold on this VM; trust live readings over §0.
- **Never:** kill/restart production or platform processes without approval; run an allocation test without oom_score_adj=1000; present "used" without "available"; `swapoff`, `sysctl vm.*` tweaks, or OOM-score changes on production processes.
