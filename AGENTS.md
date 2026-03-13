# Repository Guidelines

## What This Repo Is

`tmux-session-pick` is a small Bash-based tmux session picker. The whole product lives in one executable, so high-quality contributions here are usually small, behavior-focused shell edits rather than framework work.

## Start Here

- `bin/tmux-session-pick` is the primary executable and source of truth.
- `README.md` documents user-facing behavior, keybinds, and tmux options.
- `Makefile` is the canonical command surface for verification and local runs.

## Command Canon

- `make lint`: syntax-check the script with `bash -n`
- `make test`: exercise the non-interactive row builder with `--list`
- `make verify`: run the local pre-commit verification loop
- `make list`: print the picker rows without opening `fzf`
- `make run`: launch the interactive picker

## Project Structure

- Keep the project small and script-first unless a clear need for helper modules appears.
- Prefer hidden tab-separated columns for picker metadata instead of parsing display text late.
- Keep selection parsing separate from action execution so new keybinds do not depend on display formatting.

## Key Invariants

- Use only `@tmux-session-pick-*` tmux options for repo-owned configuration.
- Preserve the current cross-socket behavior: switch in-place when staying on the same socket, detach/reattach when crossing sockets.
- The display column is presentation only. Hidden metadata columns are the contract for actions.
- Mixed row kinds are now part of the contract: `session`, `rig`, and `crew`.
- New session creation must keep working both inside tmux and outside tmux.
- Prompt routing is rig-targeted only in the first pass. Crew rows are for crew attachment and lifecycle actions.
- Docked rig rows may remain visible, but prompt routing against them must guard explicitly rather than failing silently.

## Editing Guidelines

- Favor small shell functions with explicit inputs/outputs.
- Keep external dependencies minimal: `tmux`, `fzf` or `fzf-tmux`, and standard POSIX utilities.
- Preserve the existing `--list` path as the cheapest verification path.
- Add brief comments only where the shell flow would otherwise be hard to recover.

## Testing

- Run `make verify` after script edits.
- For row-generation changes, inspect `make list` output as well as `make test`.
- For Gastown-aware changes, confirm `make list` shows sensible `session`, `rig`, and `crew` rows and that crew actions only apply to crew rows.
- For tmux switching or action changes, verify from both inside tmux and outside tmux when practical.

## Documentation

- Update `README.md` when adding new keybinds, tmux options, or action semantics.
- Mention new non-obvious metadata columns, row kinds, or naming assumptions in the README.
- Keep command examples aligned with `Makefile` targets.

## Forbidden Actions

- Do not add a new runtime dependency or rewrite this into another language without discussion.
- Do not parse the display string for control flow when hidden metadata columns can carry the data directly.
- Do not rename or silently repurpose an existing `@tmux-session-pick-*` tmux option.
- Do not silently widen prompt routing from rig rows to crew rows without updating the spec and docs.
- Do not claim interactive tmux behavior was verified unless you actually tested it.
- Do not use destructive git commands such as `git reset --hard` or `git checkout --` without explicit approval.

## Escalate If

- A change needs a new runtime dependency beyond `tmux`, `fzf`, `fzf-tmux`, or standard shell tools.
- A change alters socket discovery, default socket choice, or cross-socket attach behavior.
- A proposed action needs state that cannot be carried cleanly in hidden metadata columns.
- You cannot verify a tmux-only behavior change from an actual tmux session.

## If You Change...

- `bin/tmux-session-pick` logic: run `make verify`
- Row layout or hidden metadata columns: run `make list` and update `README.md`
- Keybinds, tmux options, or action semantics: update `README.md`
- Rig and crew actions: verify guards for unsupported row kinds stay explicit
- Cross-socket switching or session creation behavior: verify inside tmux and outside tmux when practical
