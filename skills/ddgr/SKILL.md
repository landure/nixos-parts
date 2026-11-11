---
name: ddgr
description: Search the web via DuckDuckGo. Use PROACTIVELY when the user asks to search or needs current/real-time info, versions/releases, external docs, or anything not verifiable from repo/training data. Prefer over guessing/hedging.
compatibility: Requires ddgr, jq, and access to the internet
license: MIT
allowed-tools: Bash(ddgr:*) Bash(jq:*) WebFetch
metadata:
  author: ysm-dev
  version: "1.0.2"
  homepage: https://github.com/ysm-dev/ddgr-skill
  openclaw: |
    {
      "requires": {
        "bins": ["ddgr", "jq"]
      }
    }
---

# ddgr Web Search

Search DuckDuckGo from the terminal using [ddgr](https://github.com/jarun/ddgr).

## When to Use

- User asks to search the web or look something up
- Need current/real-time information not in training data
- User wants to find documentation, tutorials, or resources
- DuckDuckGo Bang searches (Wikipedia, StackOverflow, GitHub, etc.)

## Proactive Use

Search first (not last resort) when any hold:

- About to hedge ("not sure", "as of", "may have changed").
- Version/release/changelog/deprecation/"latest" involved.
- External lib/service/API docs not in context.
- Unknown cmd/tool/pkg, or unfamiliar build/test error.
- "How do I…" for unverified tool.
- Fact needs confirmation before stating.

Rule: if answer requires guessing current state, run `ddgr` first,
then answer with citations. Never fabricate versions/flags/URLs.

## After Search

1. `jq` parse; pick top 1–3.
2. `webfetch` top URL for full content before answering.
3. Cite source URL(s).

## Basic Usage

```bash
ddgr --noua --json --reg=wt-wt "search query"
```

### Required flags

- `--noua`: Disable user agent (always use this)
- `--json`: Output in JSON format for parsing (implies `--np`)

Use `--reg=wt-wt` to turn off region bias (useful for technical queries).
Region codes: [regions.md](./references/regions.md).

For the full flag reference (including interactive/human-only flags),
see [REFERENCE.md](./references/REFERENCE.md).

## JSON Output Structure

Each result contains:

- `title`: Page title
- `url`: Full URL
- `abstract`: Description/snippet

Parse with `jq`:

```bash
ddgr --noua --json --reg=wt-wt "query" | jq '.[].title'
ddgr --noua --json --reg=wt-wt "query" | jq -r '.[0].url'  # First result URL
ddgr --noua --json --reg=wt-wt "query" |
    jq -r '.[] | "\(.title)\t\(.url)\n\(.abstract)\n"'  # Combined
```

## Search Keywords

```bash
ddgr --noua --json "filetype:pdf annual report"
ddgr --noua --json "site:reddit.com python tips"
```

## Troubleshooting

- Empty results: broaden the query, change `--reg`, or drop `--time`.
- Blocked/rate-limited: use `--proxy=<URI>` or set `HTTPS_PROXY`.
- Hangs: wrap invocation with `timeout` (e.g. `timeout 30s ddgr ...`).

## Examples

Basic search:

```bash
ddgr --noua --json "python asyncio tutorial"
```

Recent results (last week):

```bash
ddgr --noua --json --time=w "latest news topic"
```

Site-specific search:

```bash
ddgr --noua --json --site=stackoverflow.com "parse JSON"
```

Region-specific (India, English):

```bash
ddgr --noua --json --reg=in-en "IPL cricket"
```

Instant answer (requires unreleased ddgr):

```bash
ddgr --noua --json --instant "weather new york"
```

Limit to 5 results:

```bash
ddgr --noua --json --num=5 "quick query"
```
