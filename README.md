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
- `gt` for Gastown-aware rig and crew rows plus crew/prompt actions

The `--list` path does not require `fzf`; it is intended to be the cheapest verification path for development and CI. If `gt` is unavailable, the picker falls back to tmux session rows only.

## Row Model

`bin/tmux-session-pick --list` emits tab-separated rows in this shape:

```text
entry_kind<TAB>rig<TAB>name<TAB>status<TAB>socket<TAB>session<TAB>attached<TAB>display
```

Current entry kinds:

- `session`: tmux session rows
- `rig`: Gastown rig rows
- `crew`: Gastown crew rows

The hidden columns are the action contract. The final display column is the only column rendered in the picker UI. Keep control flow keyed off the hidden columns instead of re-parsing display text.

## Actions

Default picker behavior now depends on the selected row kind:

- `session` row + `Enter`: switch or attach to the tmux session
- `crew` row + `Enter`: attach to that crew workspace via `gt crew at`
- `rig` row + typed query + `Enter`: create a prompt bead in that rig and sling it to the selected rig

Rig prompt routing is only actionable on non-docked rigs. Docked rig rows stay visible for context, but the picker now guards that action explicitly instead of failing silently.

Additional default keybinds:

- `alt-r`: restart the selected crew row via `gt crew restart`
- `alt-x`: stop the selected crew row via `gt crew stop`
- `alt-bspace`: kill the selected tmux session row

Unsupported action/row combinations are guarded explicitly with a user-facing message.

Crew rows are shown by default. Polecats are not included in the first pass.

## Modes

The picker now supports four row modes:

- `sessions`: tmux session rows only
- `crews`: Gastown crew rows only
- `rigs`: Gastown rig rows only
- `all`: mixed session, rig, and crew rows

The default mode is `sessions`, so the picker opens like the original session switcher unless you explicitly change modes.

Default mode-switch keybinds:

- `alt-m`: cycle `sessions -> crews -> rigs -> all -> sessions`
- `alt-1`: switch to `sessions`
- `alt-2`: switch to `crews`
- `alt-3`: switch to `rigs`
- `alt-4`: switch to `all`

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
- `@tmux-session-pick-bind-crew-restart`
- `@tmux-session-pick-bind-crew-stop`
- `@tmux-session-pick-bind-cycle-mode`
- `@tmux-session-pick-bind-mode-sessions`
- `@tmux-session-pick-bind-mode-crews`
- `@tmux-session-pick-bind-mode-rigs`
- `@tmux-session-pick-bind-mode-all`
- `@tmux-session-pick-mode`
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
