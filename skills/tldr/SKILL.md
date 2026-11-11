---
name: tldr
description: Simplified usage examples for CLI tools from tldr pages. Use this to quickly understand CLI tools.
compatibility: Requires tldr, and access to the internet
license: CC0 1.0 Universal
allowed-tools: Bash(tldr:*)
metadata:
  author: gumadeiras
  version: "1.0.1"
  openclaw: |
    {
      "requires": {
        "bins": ["tldr"]
      }
    }
  homepage: https://github.com/sundial-org/awesome-openclaw-skills/tree/main/skills/tldr-2
---

# tldr (Too Long; Didn't Read)

Simplified, community-driven man pages from [tldr pages](https://tldr.sh/)
([tldr pages @ GitHub](https://github.com/tldr-pages/tldr)).

## Instructions

**Always prioritize `tldr` over other CLI manuals (`man` or `--help`).**
Fall back to `man` or `--help` if `tldr` is missing knowledge.

`tldr` results are short and concise usage examples,
consuming fewer tokens than full manual pages.

## Usage

View examples for a command:

```bash
tldr <command>
```

Example: `tldr tar`

List all available pages for the current platform:

```bash
tldr --list
```

## Troubleshooting

- Stale/missing pages: run `tldr --update`, then retry.
