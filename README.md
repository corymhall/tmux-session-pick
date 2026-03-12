# tmux-session-pick

A standalone tmux session picker built around `fzf`/`fzf-tmux`.

It started from ideas in `omerxx/tmux-sessionx`, but this version is intentionally focused on:

- switching across multiple tmux sockets
- creating missing sessions on demand
- using its own `@tmux-session-pick-*` tmux option namespace
- leaving room for custom actions such as Gastown-specific session workflows

## Layout

- `bin/tmux-session-pick`: executable picker script
- `AGENTS.md`: repo-specific guidance for AI coding agents
- `Makefile`: canonical local verification commands

## Usage

Run directly:

```bash
./bin/tmux-session-pick
```

List the current rows without launching `fzf`:

```bash
./bin/tmux-session-pick --list
```

Example tmux binding:

```tmux
bind-key -T prefix u run-shell "$HOME/path/to/tmux-session-pick/bin/tmux-session-pick"
```

## Dependencies

- `tmux`
- `fzf` or `fzf-tmux` for the interactive picker

The `--list` path does not require `fzf`; it is intended to be the cheapest verification path for development and CI.

## Row Model

`bin/tmux-session-pick --list` emits tab-separated rows in this shape:

```text
socket<TAB>session<TAB>attached<TAB>display
```

The first three columns are hidden metadata used for action execution. The final display column is the only column rendered in the picker UI. Keep control flow keyed off the hidden columns instead of re-parsing display text.

## Configuration

The script reads several tmux options for UI and keybind behavior, including:

- `@tmux-session-pick-preview-location`
- `@tmux-session-pick-preview-ratio`
- `@tmux-session-pick-window-height`
- `@tmux-session-pick-window-width`
- `@tmux-session-pick-prompt`
- `@tmux-session-pick-pointer`
- `@tmux-session-pick-bind-accept`
- `@tmux-session-pick-bind-abort`
- `@tmux-session-pick-bind-delete-char`
- `@tmux-session-pick-bind-scroll-up`
- `@tmux-session-pick-bind-scroll-down`
- `@tmux-session-pick-bind-select-up`
- `@tmux-session-pick-bind-select-down`
- `@tmux-session-pick-bind-kill-session`
- `@tmux-session-pick-additional-options`

## Development

Quick validation:

```bash
make verify
```

Useful commands:

```bash
make list
make run
```

Interactive behavior is easiest to verify from inside tmux. For switching or action changes, verify from both inside tmux and outside tmux when practical.
