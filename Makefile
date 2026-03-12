SHELL := /usr/bin/env bash

.PHONY: lint test verify list run help

lint: ## Syntax-check the picker script
	bash -n bin/tmux-session-pick

test: ## Exercise the non-interactive row builder
	bin/tmux-session-pick --list >/dev/null

verify: lint test ## Run the local verification loop
	@echo "Verification passed."

list: ## Print picker rows without launching fzf
	bin/tmux-session-pick --list

run: ## Launch the interactive picker
	bin/tmux-session-pick

help: ## Show available targets
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  %-10s %s\n", $$1, $$2}'
