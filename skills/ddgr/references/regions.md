# ddgr Region Codes

Source: <https://duckduckgo.com/duckduckgo-help-pages/settings/params>

Pass a code to `ddgr --reg=<CODE>` (or `-r <CODE>`) to bias results to a
region/language.
Format is `<country>-<language>` (lowercase): `fr-fr`, `us-en`, `in-en`, …
Use `wt-wt` for no region (default in this skill's recommended invocation).

## Common choices

| Code | Region |
|------|--------|
| `wt-wt` | No region (neutral, default recommended) |
| `us-en` | United States (English) |
| `uk-en` | United Kingdom (English) |
| `fr-fr` | France (French) |
| `de-de` | Germany (German) |
| `in-en` | India (English) |
| `jp-jp` | Japan (Japanese) |
| `cn-zh` | China (Chinese) |

## Usage examples

```bash
# France, French
ddgr --noua --json --reg=fr-fr "actualités python"

# India, English
ddgr --noua --json --reg=in-en "cricket scores"

# No region (neutral)
ddgr --noua --json --reg=wt-wt "python asyncio tutorial"
```

## Full list

| Code | Region |
|------|--------|
| `xa-ar` | Arabia |
| `xa-en` | Arabia (en) |
| `ar-es` | Argentina |
| `au-en` | Australia |
| `at-de` | Austria |
| `be-fr` | Belgium (fr) |
| `be-nl` | Belgium (nl) |
| `br-pt` | Brazil |
| `bg-bg` | Bulgaria |
| `ca-en` | Canada |
| `ca-fr` | Canada (fr) |
| `ct-ca` | Catalan |
| `cl-es` | Chile |
| `cn-zh` | China |
| `co-es` | Colombia |
| `hr-hr` | Croatia |
| `cz-cs` | Czech Republic |
| `dk-da` | Denmark |
| `ee-et` | Estonia |
| `fi-fi` | Finland |
| `fr-fr` | France |
| `de-de` | Germany |
| `gr-el` | Greece |
| `hk-tzh` | Hong Kong |
| `hu-hu` | Hungary |
| `in-en` | India |
| `id-id` | Indonesia |
| `id-en` | Indonesia (en) |
| `ie-en` | Ireland |
| `il-he` | Israel |
| `it-it` | Italy |
| `jp-jp` | Japan |
| `kr-kr` | Korea |
| `lv-lv` | Latvia |
| `lt-lt` | Lithuania |
| `xl-es` | Latin America |
| `my-ms` | Malaysia |
| `my-en` | Malaysia (en) |
| `mx-es` | Mexico |
| `nl-nl` | Netherlands |
| `nz-en` | New Zealand |
| `no-no` | Norway |
| `pe-es` | Peru |
| `ph-en` | Philippines |
| `ph-tl` | Philippines (tl) |
| `pl-pl` | Poland |
| `pt-pt` | Portugal |
| `ro-ro` | Romania |
| `ru-ru` | Russia |
| `sg-en` | Singapore |
| `sk-sk` | Slovak Republic |
| `sl-sl` | Slovenia |
| `za-en` | South Africa |
| `es-es` | Spain |
| `se-sv` | Sweden |
| `ch-de` | Switzerland (de) |
| `ch-fr` | Switzerland (fr) |
| `ch-it` | Switzerland (it) |
| `tw-tzh` | Taiwan |
| `th-th` | Thailand |
| `tr-tr` | Turkey |
| `ua-uk` | Ukraine |
| `uk-en` | United Kingdom |
| `us-en` | United States |
| `ue-es` | United States (es) |
| `ve-es` | Venezuela |
| `vn-vi` | Vietnam |
| `wt-wt` | No region |
