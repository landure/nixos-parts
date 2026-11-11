---
name: ddgr
description: Search the web via DuckDuckGo. USE PROACTIVELY for current/real-time info, versions/releases, external docs, or anything not verifiable from repo/training data. Supports DuckDuckGo Bangs (!w,!so,!gh,!yt). Prefer over guessing/hedging.
compatibility: Requires ddgr, and access to the internet
license: MIT
allowed-tools: Bash(ddgr:*) Bash(jq:*) WebFetch
metadata:
  author: ysm-dev
  version: "1.0.1"
  homepage: https://github.com/ysm-dev/ddgr-skill
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

## JSON Output Structure

Each result contains:

- `title`: Page title
- `url`: Full URL
- `abstract`: Description/snippet

Parse with `jq`:

```bash
ddgr --noua --json --reg=wt-wt "query" | jq '.[].title'
ddgr --noua --json --reg=wt-wt "query" | jq -r '.[0].url'  # First result URL
```

### Other flags

| Flag | Description |
|------|-------------|
| `--np` | (noprompt): Exit after showing results, no interactive prompt |
| `--num=<N>`, `-n <N>` | Number of results (0-25, default 10) |
| `--time=<SPAN>`, `-t <SPAN>` | Restrict results by age: `d` (1 day), `w` (1 week), `m` (1 month), `y` (1 year) |
| `--site=<SITE>`, `-w <SITE>` | Search within a specific site |
| `--reg=<REG>`, `-r <REG>` | Region-specific search (`us-en`, `uk-en`, `fr-fr`, `wt-wt` for No region, …) |
| `--unsafe` | Disable safe search |
| `--reverse` | List results in reversed order |
| `--proxy=<URI>`, `-p <URI>` | HTTPS proxy (otherwise, use `HTTPS_PROXY` environment variable) |

Full regions list: <https://duckduckgo.com/duckduckgo-help-pages/settings/params>

## DuckDuckGo Bangs

Bangs redirect searches to other sites. Escape `!` in bash/zsh:

```bash
ddgr --noua --np \!w "search term"      # Wikipedia
ddgr --noua --np \!so "python error"    # StackOverflow
ddgr --noua --np \!gh "repo name"       # GitHub
ddgr --noua --np \!yt "video topic"     # YouTube
ddgr --noua --np \!a "product"          # Amazon
```

Full bang list: <https://duckduckgo.com/bang_lite.html>

## Search Keywords

```bash
ddgr --noua --json "filetype:pdf annual report"
ddgr --noua --json "site:reddit.com python tips"
```

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

Instant answer:

```bash
ddgr --noua --json --instant "weather new york"
```

Limit to 5 results:

```bash
ddgr --noua --json --num=5 "quick query"
```
