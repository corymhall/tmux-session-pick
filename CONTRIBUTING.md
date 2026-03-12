# Contributing

## Start Here

Read `AGENTS.md` first. This repo is intentionally small, and almost every change should stay scoped to `bin/tmux-session-pick` plus any matching README updates.

## Development Workflow

1. Make the smallest change that solves the problem.
2. Keep picker metadata in hidden tab-separated columns instead of parsing rendered display text.
3. Update `README.md` when keybinds, tmux options, row shape, or action semantics change.
4. Run `make verify` before you submit the change.
5. If you changed switching or action behavior, verify from a real tmux session when practical.

## Validation Expectations

Include the commands you ran in your PR or handoff notes.

- Script or row-model change: `make verify`
- Row-layout debugging: `make list`
- Interactive behavior change: `make run` from tmux, plus an outside-tmux check when practical

## AI-Assisted Contributions

- Read `AGENTS.md`, `README.md`, and `bin/tmux-session-pick` before editing.
- Keep changes narrow; do not refactor unrelated shell flow while touching behavior.
- Do not claim tests passed unless you ran the commands.
- Prefer extending existing functions and metadata columns before introducing new structure.

## Dependencies

This project intentionally keeps runtime dependencies minimal:

- `tmux`
- `fzf` or `fzf-tmux`
- standard shell utilities already used by the script

Discuss any additional runtime dependency before adding it.
