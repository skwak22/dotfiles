# My Dotfiles

Uses [GNU Stow](https://www.gnu.org/software/stow/) to manage configuration files and portable agentic coding tools.

## Setup

Install `stow` (e.g., `brew install stow` or `sudo apt install stow`), then from this directory run:

```bash
stow --no-folding -t ~ tmux zsh git ghostty wt-fleet
```

## Packages

- **`tmux`**: `.tmux.conf` with `Ctrl-a` prefix, `Alt+Arrow` pane navigation, top pane border labels (`@name` & `@branch`), and `wt-fleet` layout shortcuts (`Ctrl-a =`, `Ctrl-a M`, `Ctrl-a W`).
- **`zsh`**: `.zshrc` with history search, Starship prompt, and `wt-fleet` aliases (`wfm`, `wfs`).
- **`git`**: `.gitconfig`.
- **`ghostty`**: Ghostty terminal configuration.
- **`wt-fleet`**: Portable Git worktree + `tmux` multi-agent orchestrator (`~/bin/wt-fleet`), custom agents (`mayor`, `staff`, `worker`), and modular skills (`wt-fleet`, `staff-review`, `tmux-ops`, `gh-pr`).
