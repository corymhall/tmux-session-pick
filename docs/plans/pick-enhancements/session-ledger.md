# Session Ledger: pick-enhancements

## Current Status

- Stage: review workers launched, awaiting reports
- Branch: `integration/build-gastown-picker-hub`
- Epic: `pick-28n`
- Review profiles: `general`
- Tracking mode: `milestones`

## Implementation Checklist

- [x] Extend picker row collection to support Gastown-aware entries alongside tmux session rows
- [x] Introduce a richer hidden metadata contract with explicit entry kinds
- [x] Keep session switching behavior intact for tmux session rows
- [x] Add rig-targeted prompt-to-sling action
- [x] Add crew lifecycle actions for restart and stop
- [ ] Keep crew entries visible by default and polecats hidden by default
- [ ] Preserve lightweight verification via `make verify`, `make list`, and interactive checks
- [ ] Update `README.md` and `AGENTS.md` for metadata, keybinds, and semantics changes

## Proof Model

- Slice 1 proof model: red-green
  - Red: current picker only emits tmux session rows and has no Gastown-aware action metadata
  - Green target: `--list` emits mixed row kinds with explicit hidden metadata while preserving session rows

## Milestone Self-Checks

- Planning milestone
  - Status: complete
  - Evidence: spec drafted and enriched in `docs/plans/pick-enhancements/spec.md`
  - Counts: 6 decision log rows, 7 non-negotiables
- Slice 1: mixed entry rows and action dispatch
  - Status: complete
  - Spec coverage: Design sections on Architecture, Actions, Implementation Components
  - Proof model: red-green
  - Evidence: `bash -n bin/tmux-session-pick` passed and `bin/tmux-session-pick --list` now emits `session`, `rig`, and `crew` rows with stable hidden metadata
  - Remaining risk: user-facing docs and final verification still need to catch up to the new actions and row model
  - Next milestone still makes sense: yes
- Slice 2: documentation and safe command-path verification
  - Status: complete
  - Spec coverage: Design sections on Documentation and Verification plus the rig-targeted prompt-routing decision
  - Proof model: command-path verification with guarded side-effect checks
  - Evidence: `make verify` passed; rig and crew previews returned expected data; row-kind guard for crew actions returned cleanly on a non-crew row
  - Remaining risk: prompt-to-sling and actual crew restart/stop have not been exercised live in this session to avoid unnecessary side effects
  - Next milestone still makes sense: yes
- Slice 3: review-driven guard fixes
  - Status: complete
  - Spec coverage: Implementation Components and action-guard requirements from the enriched spec
  - Proof model: red-green against review findings
  - Evidence: docked rig prompt routing is now explicitly guarded and session-kill uses the shared guarded action path instead of a silent no-op
  - Remaining risk: side-effecting happy paths still rely on command-shape verification rather than live execution
  - Next milestone still makes sense: yes

## Commands Run + Outcomes

- `gt hook` -> delivery workflow attached for `pick-enhancements`
- `bd show pick-28n` -> confirmed root epic
- `gt mq integration create pick-28n` -> created `integration/build-gastown-picker-hub`
- `git push -u origin integration/build-gastown-picker-hub` -> integration branch published
- `make verify` -> passed before implementation stage
- `gt rig list --json` -> confirmed rig metadata source for rig rows
- `gt crew list --rig tmux_session_pick --json` -> confirmed crew metadata source for crew rows
- `gt sling --help` -> confirmed `--args` and `--hook-raw-bead` path for prompt routing
- `gt crew restart --help` / `gt crew stop --help` -> confirmed lifecycle command shapes
- `bash -n bin/tmux-session-pick` -> passed after row-model and action changes
- `bin/tmux-session-pick --list` -> emitted mixed session, rig, and crew rows
- `make verify` -> passed after implementation and docs updates
- `bin/tmux-session-pick --preview rig gastown ...` -> showed rig preview data
- `bin/tmux-session-pick --preview crew gastown quick ...` -> showed crew preview data
- `bin/tmux-session-pick --action crew-restart rig ...` -> returned via unsupported-row guard without side effects
- reviewer fallback report -> identified missing docked-rig guard and silent session-kill behavior
- `git commit --allow-empty -m "checkpoint: prepare pick-enhancements for external review"` -> created review checkpoint `ba14bdd`
- `git push` -> pushed checkpoint commit to `origin/integration/build-gastown-picker-hub`
- `gt crew start tmux_session_pick reviewcodex --agent codex` -> created local codex review sidecar workspace/session
- `gt crew start tmux_session_pick reviewclaude --agent claude` -> created local claude review sidecar workspace/session
- `gt sling mol-review-implementation tmux_session_pick --crew reviewcodex ...` -> attached review wisp `pick-wisp-6pon`
- `gt sling mol-review-implementation tmux_session_pick --crew reviewclaude ...` -> attached review wisp `pick-wisp-jja2`
- `gt nudge tmux_session_pick/crew/reviewcodex --mode=queue ...` -> queued explicit review-start reminder
- `gt nudge tmux_session_pick/crew/reviewclaude ...` -> delivered explicit review-start reminder

## Files Changed

- `docs/plans/pick-enhancements/session-context.md`
- `docs/plans/pick-enhancements/spec.md`
- `docs/plans/pick-enhancements/session-ledger.md`
- `bin/tmux-session-pick`

## Open Risks / Blockers

- Need to keep the hidden metadata contract understandable as row kinds expand
- Interactive behavior inside tmux still needs end-to-end manual validation after docs are updated
- Prompt-to-sling and real crew lifecycle commands are implemented but only guard-level checked in this session
- The rig is docked, so review workers had to run as same-rig crew sidecars rather than polecats

## Review Runs

- Review directory: `/Users/chall/gt/tmux_session_pick/.runtime/reviews/pick-enhancements/20260313-052259`
- Review checkpoint: `ba14bdd`
- Implementation scope: `origin/integration/build-gastown-picker-hub`
- Worker: `tmux_session_pick/crew/reviewcodex`
  - Agent: `codex`
  - Wisp: `pick-wisp-6pon`
  - Expected report: `/Users/chall/gt/tmux_session_pick/.runtime/reviews/pick-enhancements/20260313-052259/codex-review.md`
- Worker: `tmux_session_pick/crew/reviewclaude`
  - Agent: `claude`
  - Wisp: `pick-wisp-jja2`
  - Expected report: `/Users/chall/gt/tmux_session_pick/.runtime/reviews/pick-enhancements/20260313-052259/claude-review.md`
