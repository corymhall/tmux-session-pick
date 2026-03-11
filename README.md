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
bind-key -T prefix u run-shell "$HOME/personal/tmux-session-pick/bin/tmux-session-pick"
```

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
bash -n ./bin/tmux-session-pick
./bin/tmux-session-pick --list
```

Interactive behavior is easiest to verify from inside tmux.
