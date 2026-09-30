---
name: tmux-ops
description: >-
  Portable tmux pane management, layout orchestration, and cross-pane agent
  communication using native tmux commands. Use whenever managing tmux panes,
  reading scrollback from another pane, sending prompts/messages between agents
  in different tmux panes, labeling pane borders, or tiling windows.
---

# Portable `tmux` Operations & Cross-Pane Messaging (`tmux-ops`)

Use native `tmux` commands (or `wt-fleet` for git worktree fleets) to inspect,
label, layout, and communicate across `tmux` panes on any macOS or Linux
machine without external binary dependencies.

---

## 1. Inspecting Panes & Scrollback

```bash
# List all panes in the current session with pane ID, window, label (@name), branch (@branch), and CWD
tmux list-panes -s -F '#{pane_id} win:#{window_index}.#{pane_index} name:#{@name} branch:#{@branch} cwd:#{pane_current_path}'

# Capture the last 40 lines of visible/scrollback output from a pane (e.g., %2)
tmux capture-pane -t "%2" -p -J -S -40
```

---

## 2. Labeling Panes (Visible in Top Border)

The user's `.tmux.conf` displays `@name` and `@branch` in the top border of each
pane:

```bash
# Set the agent role/name label on a pane
tmux set-option -p -t "%2" @name "feat-auth"

# Set the git branch label on a pane
tmux set-option -p -t "%2" @branch "agent/feat-auth"
```

---

## 3. Sending Messages to Another Agent Pane Safely

When sending a prompt or reply into an interactive TUI running in another pane:
1. Always **read** the target pane first (`tmux capture-pane`) to confirm it is
   running an agent TUI.
2. Send the literal text (`send-keys -l`) and the `Enter` key in **separate
   commands** with a short `sleep 0.15` in between so the TUI input buffer does
   not swallow the newline as a multiline paste:

```bash
# 1. Inspect target pane first
tmux capture-pane -t "%2" -p -J -S -20

# 2. Type literal message with sender tag
tmux send-keys -t "%2" -l -- "[from:${TMUX_PANE}] Please run the unit tests and commit."
sleep 0.15

# 3. Submit with Enter
tmux send-keys -t "%2" Enter
```

> **Rule — Do Not Poll**: After sending a message to another agent pane, stop
> calling tools and yield your turn. The receiving agent will reply back into
> your pane when finished.

---

## 4. Creating & Balancing Panes (Max 4 Panes Per Window)

Keep related agents side-by-side in the same window (up to 4 panes max):

```bash
# Split a new pane in the current window starting in a specific directory (-d keeps focus in current pane)
NEW_PANE=$(tmux split-window -d -h -c "/path/to/workdir" -P -F '#{pane_id}')

# For 2 panes: side-by-side
tmux select-layout even-horizontal

# For 3-4 panes: 2x2 balanced grid (or main-vertical)
tmux select-layout tiled
```
