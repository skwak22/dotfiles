---
name: gh-pr
description: >-
  Bootstrap the GitHub CLI (`gh`) in user space (`~/.local/bin/gh`) without root
  privileges and create, inspect, or update GitHub Pull Requests (`gh pr create`)
  from feature branches or `wt-fleet` worker branches (`agent/<name>`). Use this
  skill whenever the user asks to open/create a PR, check PR status, or set up
  `gh` CLI.
---

# GitHub Pull Request Workflow & `gh` Bootstrap (`gh-pr`)

Use this skill whenever asked to open, update, or inspect a GitHub Pull Request,
including from an `APPROVED` `wt-fleet` worker branch (`agent/<name>`).

---

## 1. Setup: Ensure `gh` CLI Is Installed & Authenticated

Before running any `gh pr` command, run the bundled bootstrap script:

```bash
bash ~/.gemini/config/skills/gh-pr/scripts/ensure_gh.sh
```

### What `ensure_gh.sh` Does
1. Checks if `gh` is on `PATH` (`$HOME/.local/bin:$HOME/bin:$PATH`).
2. If missing, downloads the latest official release binary from
   `cli/cli` on GitHub for the current OS/architecture (`linux` or `macOS`,
   `amd64` or `arm64`) and installs it to `~/.local/bin/gh` (**no `sudo`
   required**).
3. Detects the GitHub hostname from `git remote get-url origin` and checks
   `gh auth status --hostname <host>`.
4. Exits `0` if authenticated, or exits `2` (`AUTH_REQUIRED`) if not logged in.

### Handling Unauthenticated `gh` (`exit 2`)
- **NEVER run interactive `gh auth login` without flags in an agent subshell**
  (it blocks waiting for browser/device input).
- If `ensure_gh.sh` exits with code `2`:
  1. Still push the branch via `git push -u origin <source-branch>:<pr-branch>`
     (assuming explicit user approval to push / open a PR).
  2. Prompt the user to run `gh auth login --hostname <host>` in their terminal
     (or run `gh pr create` immediately once they authenticate), and provide the
     fallback `https://<host>/<org>/<repo>/pull/new/<pr-branch>` URL plus the
     formatted PR title and body.

---

## 2. Opening a PR (Standard & `wt-fleet` Branches)

### Pre-Flight Checklist
1. **Explicit User Permission**: Never push to a remote repository or open a PR
   unless the user explicitly asked to push or create a PR.
2. **Review & Verification Gates**: If using `wt-fleet`, ensure the worker
   branch (`agent/<worker>`) has passed the **Staff Engineer Review Gate
   (`APPROVED`)** and has a clean working tree.
3. **Clean Branch Name**: When pushing a `wt-fleet` worker branch
   (`agent/<worker>`) to `origin`, push it to a descriptive remote branch name
   (e.g., `feat/<slug>` or `fix/<slug>`) rather than exposing internal
   `agent/...` branch names, unless the repo convention prefers `agent/<worker>`:
   ```bash
   git push -u origin agent/<worker>:feat/<slug>
   ```

### Creating the PR via `gh pr create`
Always pass `--base`, `--head`, `--title`, and `--body-file` (or `--body`)
non-interactively so `gh` never opens an interactive editor:

```bash
cat << 'EOF' > /tmp/pr_body.md
## Summary
- <concise bullet points of architectural changes and why>

## Verification Gates
- `<lint command>`: passed
- `<test command>`: passed
EOF

gh pr create \
  --base main \
  --head feat/<slug> \
  --title "feat(<scope>): <concise imperative summary>" \
  --body-file /tmp/pr_body.md

rm -f /tmp/pr_body.md
```

---

## 3. Post-PR Cleanup with `wt-fleet`

After opening a PR from a `wt-fleet` worker branch (`agent/<worker>`):
- Ask the user whether they want to:
  1. **Keep local `main` clean until the PR merges on GitHub** and tear down the
     worker pane (`wt-fleet teardown <worker>`), or
  2. **Merge into local `main` immediately** (`wt-fleet merge <worker> --teardown`)
     so subsequent stacked slices can branch off the updated local `main`.
