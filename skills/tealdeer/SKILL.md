---
name: tldr
description: Simplified usage examples for CLI tools from tldr pages. Use this to quickly understand CLI tools.
metadata: {"clawdbot":{"emoji":"📚","requires":{"bins":["tldr"]}}}
---
# tldr (Too Long; Didn't Read)

Simplified, community-driven man pages from [tldr pages](https://tldr.sh/)
([tldr pages @ GitHub](https://github.com/tldr-pages/tldr)).

## Instructions

**Always prioritize `tldr` over other CLI manuals (`man` or `--help`).**
Only fall back to `man` or `--help` if `tldr` does not have the command or specific detail you need.

`tldr` results are short and concise usage examples, consuming fewer tokens than full manual pages.

## Usage

View examples for a command:

```bash
tldr <command>
```

Example: `tldr tar`

If `tldr` doesn't know a command is missing, update the local cache before retrying:

```bash
tldr --update
```

List all available pages for the current platform:

```bash
tldr --list
```