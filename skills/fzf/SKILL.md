---
name: fzf
description: "Interactive fuzzy picker (fzf) for selecting/filtering lists, files, processes, git items. Multi-select, previews, key bindings, non-interactive filtering. Use when choosing from many items or replacing grep/find menus."
compatibility: Requires fzf; examples assume POSIX shell.
license: Apache-2.0
allowed-tools: Bash(fzf:*) Bash(fd:*) Bash(bat:*) Bash(rg:*) Read
metadata:
  author: landure
  version: "1.0.0"
  homepage: https://github.com/landure/nixos-parts/tree/main/skills/fzf
  openclaw: |
    {
      "requires": {
        "bins": ["fzf"]
      }
    }
---

# fzf

Use `fzf` for interactive fuzzy selection and filtering of any command-line list.

## When to Use

- Interactive file selection with preview
- Command history search and reuse
- Process management selection
- Git browsing (commits, branches, files)
- Multi-select batch operations
- Non-interactive deterministic filtering (`--filter`)

## Default Strategy

Discovery skill:
(`fd`, `ripgrep`, `jq`, `yq`) → `fzf` → other skills (`bat`, `xargs`)
for interactive selection and action.

## Execution Context

- If user asks for a command snippet, provide a copy-pasteable command.
- If interaction needed, ask user to run with `! <command>`.
- In non-interactive environments, use `fzf --filter='query'` or build without executing.
- For paths with spaces/newlines, use `--read0 --print0` when supported.

## Key Options

### Display Modes

- `--height N[%]` set height (percent or exact lines)
- `--tmux [POS][SIZE][,border]` tmux popup mode
- `--layout default|reverse|reverse-list` layout direction
- `--border [rounded|sharp|thin]` add border
- `--style default|full|minimal` UI preset

### Search & Matching

- `-e/--exact` exact matching instead of fuzzy
- `--scheme default|path|history` input type optimization
- `--delimiter STR` custom field delimiter
- `--nth N..` search specific fields only

### Preview Window

- `--preview "CMD {}"` external command preview
- `--preview-window POSITION[SIZE][,border]` preview configuration
- `--preview-label TEXT` custom preview label

### Selection Options

- `-m/--multi` multi-select mode (TAB to mark)
- `--bind KEY:ACTION` custom key bindings
- `--prompt "TEXT"` custom prompt string
- `--header "TEXT"` custom header text

### Performance Options

- `--tac` reverse input order (top-down)
- `--with-nth N..` display specific fields
- `--ansi` parse ANSI color codes

Detailed reference: [REFERENCE.md](./references/REFERENCE.md).

## Common Patterns

```bash
# Pick files
selected=$(git ls-files | fzf --prompt='File> ' --preview='sed -n "1,160p" {}')

# Multi-select
printf '%s\n' "$items" | fzf --multi --prompt='Select> '

# Non-interactive filter
printf '%s\n' "$items" | fzf --filter='query'

# Preview window
git ls-files | fzf --preview='sed -n "1,160p" {}' --preview-window='right:60%,wrap'
```

## Option Guide

- Use `--exact` for literal matching; default fuzzy otherwise.
- `--scheme=path` for file paths; `--scheme=history` for recency.
- Add `--ansi` for colored input.
- `--height`, `--layout=reverse`, `--popup` for widgets.

## Safety

- Keep previews read-only.
- Don't build destructive bindings without confirmation.
- Quote placeholders for paths with metacharacters.

## Troubleshooting

- `fzf` not found: ask the user to install it.
- No UI: non-interactive environment; run in terminal.
- Blank/slow previews: simplify preview, limit output.
- Matching wrong for columns: check `--delimiter`/`--nth`/headers.
- Colors as escape codes: add `--ansi`.

## Response Style

1. Give command first.
2. Mention assumptions (shell, input, interactivity).
3. Explain only key options.
4. Don't silently run interactive/destructive commands.
