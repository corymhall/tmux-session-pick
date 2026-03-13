# Pick Enhancements

## Overview

We are extending `tmux-session-pick` from a tmux session switcher into a Gastown-aware action hub. The first pass should keep the current Bash + `fzf` architecture and make one picker capable of showing both tmux session entries and crew-oriented Gastown entries, while preserving the repo's current lightweight verification loop and metadata-driven action model.

The immediate goal is to reduce context-switching across separate scripts by bringing the highest-value Gastown actions into one place. In the first pass, that means:
- keeping normal session switching intact
- showing rig and crew metadata in the picker
- supporting a prompt-to-sling flow against a selected target
- adding keymapped crew lifecycle actions for restart and stop
- reusing the selection and metadata patterns from `~/personal/config/bin/gt-crew-pick` without yet importing its heavier bootstrap flows wholesale

This work is for the maintainer workflow inside the existing tmux-driven Gastown environment, not for a generic standalone picker product.

## Design

### Architecture

`bin/tmux-session-pick` remains the only executable and source of truth. The implementation continues to use Bash plus `fzf` or `fzf-tmux`, with no new runtime stack in the first pass.

The picker will evolve from a single row shape:

`socket<TAB>session<TAB>attached<TAB>display`

into a richer hidden-metadata contract that can represent multiple entry kinds. The display column remains presentation-only. Hidden metadata becomes the authoritative action contract.

Candidate first-pass metadata columns:
- `entry_kind`
- `rig`
- `role_type`
- `crew`
- `status`
- `socket`
- `session`
- `attached`
- `action_target`
- `display`

The exact order can change during implementation, but actions must continue to read from hidden columns instead of reparsing rendered labels.

### Data Sources

The first pass should merge two data sources:
- existing tmux session discovery already implemented in `bin/tmux-session-pick`
- Gastown rig and crew discovery patterns adapted from `~/personal/config/bin/gt-crew-pick`

For Gastown-aware rows, reuse the proven patterns from `gt-crew-pick`:
- combined rig and crew selection rows
- typed-query plus selected-row handling via `--print-query`
- validation helpers and structured TSV output

The first pass should optimize for crew entries. Polecats should be hidden by default. The design may leave room for later toggles or explicit include-polecats behavior, but the default view should stay crew-first.

### Interaction Model

The first pass should use a single enhanced picker rather than multiple modes or a two-step chooser. A user opens one picker and can:
- switch to a tmux session
- inspect crew-target rows with richer Gastown labels
- type prompt text and use it with an action bind
- invoke crew lifecycle actions on the selected row

The query box serves two purposes:
- normal fuzzy filtering
- prompt capture for the prompt-to-sling action

Prompt routing should work by taking the current query text plus the selected row metadata and dispatching through one action function that runs the appropriate `gt` command for the selected target. The UI should not need separate prompt forms in the first pass.
For the first pass, prompt-to-sling should be rig-targeted only. Crew rows remain visible and actionable for crew lifecycle commands, but prompt submission should only be enabled on rows that carry a rig-capable sling target.

### Actions

The first pass must preserve existing session switching behavior and add at least these Gastown-aware actions:
- prompt-to-sling on the selected rig target
- `gt crew restart`
- `gt crew stop`

Each action should be implemented as a metadata-driven dispatch path, not as custom parsing of display text. After side-effecting actions like restart or stop, the picker should reload so the list reflects the latest state.

The current session-kill action pattern in `fzf` is a good model for this reload behavior and should be generalized carefully rather than replaced.

### Implementation Components

The first-pass implementation should stay explicit about responsibilities inside `bin/tmux-session-pick`:
- tmux session collection for existing socket and session rows
- Gastown row collection for rig and crew-derived entries
- one merged row builder that emits the full hidden-metadata contract
- a display formatter that keeps rendered labels separate from action data
- an action dispatch layer that maps `entry_kind` plus the selected hidden metadata to the appropriate command path

Unsupported actions for a given `entry_kind` must be guarded explicitly. The first pass should no-op with a clear user-facing message, or otherwise refuse safely, instead of trying to execute a mismatched command against the wrong row type.

### Integration with Existing Scripts

`~/personal/config/bin/gt-crew-pick` should inform the first-pass implementation, but full behavioral parity is out of scope. The intended first-pass integration is:
- reuse rig and crew discovery patterns
- reuse combined-row ideas
- reuse typed-query selection behavior where it improves the hub

The first pass should not yet absorb the full set of `gt-crew-pick` flows such as new crew bootstrap, workspace creation, or broader integration-branch setup unless implementation reveals that one of those is required for a coherent hub.

### Documentation and Verification

Any new metadata columns, keybinds, tmux options, or action semantics must be documented in `README.md`. Repo-level agent guidance in `AGENTS.md` must stay aligned with the new row model and verification commands.

The lightweight local verification loop must continue to work with:
- `make verify`
- `make list`
- `make run`

The non-interactive row-generation path should remain cheap and CI-compatible.

## Scope

In:
- extend `bin/tmux-session-pick` into a Gastown-aware action hub
- merge tmux session rows with crew-oriented Gastown rows
- show rig and crew metadata in picker entries
- hide polecats by default in the first pass
- support prompt-to-sling using typed query text plus selected row metadata
- add keymaps for `gt crew restart` and `gt crew stop`
- reuse `gt-crew-pick` selection patterns where they fit this repo's architecture
- update README and AGENTS guidance for user-visible or contributor-visible behavior changes

Out:
- rewriting the tool in Go, Bubble Tea, or another framework
- building a multi-pane dashboard or long-lived control center UI
- full import of all `gt-crew-pick` bootstrap behavior in the first pass
- treating polecats as equal-default entries on day one
- adding new runtime dependencies beyond `tmux`, `fzf` or `fzf-tmux`, and standard shell tools

## Non-Negotiables

- [N-1] The first pass must stay on the current Bash + `fzf` or `fzf-tmux` foundation.
- [N-2] Hidden metadata columns must remain the action contract; display text must stay presentation-only.
- [N-3] Existing tmux session switching behavior must continue to work.
- [N-4] The first pass must function as a single enhanced picker rather than a separate app or multi-mode control center.
- [N-5] Crew entries must be the default Gastown-focused view, with polecats hidden by default.
- [N-6] The first pass must include prompt-to-sling plus `gt crew restart` and `gt crew stop`.
- [N-7] The implementation must keep the lightweight verification loop and CI compatibility intact.

## Forbidden Approaches

- [F-1] Do not rewrite the project into Go, Bubble Tea, or another heavier UI stack for the first pass. This increases complexity before the current shell architecture is exhausted.
- [F-2] Do not drive actions by parsing rendered display labels. Hidden metadata already exists for this purpose and is a repo invariant.
- [F-3] Do not make polecats first-class default entries in the first pass. The chosen scope is crew-first.
- [F-4] Do not attempt full `gt-crew-pick` behavioral parity in the first pass. That would expand scope beyond the selected “selection only” integration level.
- [F-5] Do not add new runtime dependencies to solve first-pass interaction problems that can be handled by Bash plus `fzf`.

## Decision Log

Every material trade-off from the session is serialized here.

| Decision ID | Topic | Chosen Option | Rejected Alternatives | Rationale | Status |
|-------------|-------|---------------|------------------------|-----------|--------|
| D-1 | First-pass optimization target | Action hub | Crew parity first; prompt routing first | The immediate value is one picker with Gastown metadata and high-value actions, rather than broader bootstrap parity or a narrower single-feature rollout. | Resolved |
| D-2 | Default role visibility | Hide polecats by default | Show all roles; crew only forever | The picker should stay crew-first without closing off later expansion. | Resolved |
| D-3 | `gt-crew-pick` integration level | Selection patterns only | Most behaviors in first pass; keep fully separate | Reusing rig/crew discovery and picker patterns is high value without absorbing heavier flows too early. | Resolved |
| D-4 | Interaction shape | Single enhanced picker | Mode-based picker; two-step action then target flow | This is the closest fit to the existing tool and minimizes new state and documentation overhead. | Resolved |
| D-5 | Runtime stack | Stay with Bash + `fzf` | Rewrite to a heavier TUI stack | The repo is intentionally script-first and the current design can still absorb the first-pass feature set. | Resolved |
| D-6 | Prompt routing target model | Rig rows only | Rig and crew rows; crew rows only | This matches the original rig-targeted sling goal and keeps first-pass dispatch semantics narrower and clearer. | Resolved |

## Traceability

| Spec Element | Source | Notes |
|--------------|--------|-------|
| Non-Negotiables N-1 through N-7 | user answers + prior research + repo AGENTS/README | Captures the explicit first-pass constraints chosen during this session and the repo's existing invariants. |
| Architecture and metadata-driven action model | `bin/tmux-session-pick` + `docs/plans/pick-enhancements/codebase-context.tmp` | Grounded in the current TSV row contract and separation between selection parsing and action execution. |
| Crew-first default visibility | user answer on role scope | Serialized from the selected “Hide by default” direction for polecats. |
| `gt-crew-pick` reuse boundary | user answer on integration level + local script review | Limits the first pass to selection and metadata reuse rather than full workflow absorption. |
| Single enhanced picker interaction | user architecture choice + prior recommendation | Records why this feature stays close to the current tool instead of branching into modes or a separate action chooser. |
| Action list for prompt-to-sling, restart, and stop | original feature brief + user scope choice | Converts the starting conversation into concrete, first-pass implementation targets. |
| Rig-targeted prompt routing | enrichment decision D-6 | Narrows prompt submission to rig-capable rows while keeping crew rows focused on lifecycle actions. |

## Risks

| Risk | Impact | Mitigation |
|------|--------|------------|
| Row metadata growth makes the script harder to reason about | Medium | Keep hidden-column order explicit, document it in README, and preserve one action-dispatch layer instead of scattering parsing logic. |
| Mixing tmux sessions and Gastown entries in one list causes confusing labels or action collisions | Medium | Use clear entry-kind labeling in the display column while keeping action dispatch keyed off hidden metadata. |
| Prompt-to-sling semantics may vary depending on whether the target is a rig or a crew entry | Medium | Centralize prompt dispatch in one function and document the supported first-pass target rules clearly. |
| Pulling in too much `gt-crew-pick` behavior expands scope unexpectedly | High | Treat deeper bootstrap flows as explicitly out of scope for the first pass unless implementation proves a hard dependency. |

## Testing

- Run `make verify` after picker logic changes.
- Use `make list` to inspect the expanded row model and confirm metadata ordering.
- Use `make run` for interactive checks from tmux when verifying keybind behavior.
- For lifecycle or action changes, verify list reload behavior after side-effecting commands where practical.
