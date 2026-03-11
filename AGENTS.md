# Repository Guidelines

## Project Structure

- `bin/tmux-session-pick` is the primary executable and source of truth.
- Keep the project small and script-first unless a clear need for helper modules appears.
- Prefer hidden tab-separated columns for picker metadata instead of parsing display text late.

## Commands

- `bash -n bin/tmux-session-pick`: syntax check
- `bin/tmux-session-pick --list`: inspect generated rows without opening `fzf`
- `bin/tmux-session-pick`: interactive picker run

## Editing Guidelines

- Use only `@tmux-session-pick-*` tmux options.
- Favor small shell functions with explicit inputs/outputs.
- Keep external dependencies minimal: `tmux`, `fzf` or `fzf-tmux`, and standard POSIX utilities.
- When adding actions, keep selection parsing separate from action execution.

## Testing

- Run `bash -n bin/tmux-session-pick` after edits.
- For row-generation changes, run `bin/tmux-session-pick --list`.
- For tmux switching or action changes, verify from both inside tmux and outside tmux when practical.

## Documentation

- Update `README.md` when adding new keybinds, tmux options, or action semantics.
- Mention new non-obvious metadata columns or naming assumptions in the README.
