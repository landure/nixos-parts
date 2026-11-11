# ddgr skill

DuckDuckGo web search skill for AI coding agents using
[ddgr](https://github.com/jarun/ddgr) command-line tool.

Forked from [Chris Yang (ysm-dev)'s ddgr-skill @ GitHub](https://github.com/ysm-dev/ddgr-skill).

## Installation

```bash
npx skills add -g 'ysm-dev/ddgr-skill'
```

## Prerequisites

Install `ddgr` and `jq`:

```bash
# Mise-en-place (https://mise.jdx.dev)
mise use --global 'pipx:ddgr' 'jq'

# macOS & GNU/Linux with Homebrew
brew install ddgr

# pip
pip install ddgr

```

For other installation methods, see [Installation @ ddgr's GitHub](https://github.com/jarun/ddgr#installation).

## Usage

Once installed, AI agents use this skill when asked to:

- Search the web
- Look something up online
- Find documentation or tutorials
- Get current information
- Use DuckDuckGo Bangs (`!w` for Wikipedia, `!so` for StackOverflow, …)

## Examples

```text
Search for React hooks best practices
```

```text
Look up the latest Node.js release
```

```text
Find Python asyncio documentation
```

## License

MIT
