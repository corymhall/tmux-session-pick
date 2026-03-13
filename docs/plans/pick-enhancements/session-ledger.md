# Session Ledger: pick-enhancements

## Current Status

- Stage: implementation in progress
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

## Files Changed

- `docs/plans/pick-enhancements/session-context.md`
- `docs/plans/pick-enhancements/spec.md`
- `docs/plans/pick-enhancements/session-ledger.md`
- `bin/tmux-session-pick`

## Open Risks / Blockers

- Need to keep the hidden metadata contract understandable as row kinds expand
- Interactive behavior inside tmux still needs end-to-end manual validation after docs are updated
- Prompt-to-sling and real crew lifecycle commands are implemented but only guard-level checked in this session
