# ddgr Reference

Full flag reference for [ddgr](https://github.com/jarun/ddgr). Flags marked
*(human)* affect interactive/human-readable output and are not relevant
when using `--json`.

## Core flags

| Flag | Description |
|------|-------------|
| `--noua` | Disable user agent (always use) |
| `--json` | Output JSON; implies `--np` |
| `--np`, `--noprompt` | Exit after results, no interactive prompt |
| `--num=<N>`, `-n <N>` | Number of results (0-25, default 10); 0 = actual fetched count |
| `--time=<SPAN>`, `-t <SPAN>` | Age filter: `d` (1 day), `w` (1 week), `m` (1 month), `y` (1 year) |
| `--site=<SITE>`, `-w <SITE>` | Search within a specific site |
| `--reg=<REG>`, `-r <REG>` | Region (e.g. `us-en`, `uk-en`, `fr-fr`, `wt-wt` no region) |
| `--unsafe` | Disable safe search |
| `--reverse`, `--rev` | Reverse result order |
| `--proxy=<URI>`, `-p <URI>` | HTTPS proxy (else `HTTPS_PROXY`) |
| `-d`, `--debug` | Enable debugging |
| `-v`, `--version` | Show version |

## Interactive / human-only flags

| Flag | Description |
|------|-------------|
| `-x`, `--expand` | Show complete URLs *(human)* |
| `-j`, `--ducky` | Open first result in browser; implies `--np` *(human)* |
| `--gb`, `--gui-browser` | Open a bang directly in GUI browser *(human)* |
| `--url-handler <UTIL>` | Custom opener for results *(human)* |
| `--colorize [{auto,always,never}]` | Colorize output *(human)* |
| `-C`, `--nocolor` | Disable color *(human)* |
| `--colors <COLORS>` | Set output colors *(human)* |
| `--show-browser-logs` | Do not suppress browser output *(human)* |

## Unreleased features

- `--instant`: instant answers. Available only in unreleased ddgr; not in 2.2.
  Example: `ddgr --noua --json --instant "weather new york"`

## Regions

See [regions.md](./regions.md). Full list: <https://duckduckgo.com/duckduckgo-help-pages/settings/params>

## DuckDuckGo Bangs

Bangs redirect to other sites.
`ddgr` open bangs queries in the user browser
and doesn't output JSON results.
Use `--site` instead to search in a specific website.

Full bang list: <https://duckduckgo.com/bang_lite.html>.

## JSON output structure

Each result: `title`, `url`, `abstract`.

```bash
ddgr --noua --json --reg=wt-wt "query" | jq '.[].title'
ddgr --noua --json --reg=wt-wt "query" | jq -r '.[0].url'
ddgr --noua --json --reg=wt-wt "query" | jq -r '.[] | "\(.title)\t\(.url)\n\(.abstract)\n"'
```
