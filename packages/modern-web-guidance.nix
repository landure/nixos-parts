/**
  # modern-web-guidance

  Keep your coding agent up to date with the latest web best practices.

  The upstream GitHub repository only ships the skill markdown; the
  working CLI (search / retrieve / legacy-scan) and its offline search
  index are published on npm, so the npm tarball is packaged here.

  The CLI is exposed as the `modern-web-guidance` binary and the skills
  markdown is patched to call it directly instead of going through `npx`,
  which keeps the guidance fully offline.
*/
{
  lib,
  stdenv,
  nodejs_22,
  fetchurl,
  makeWrapper,
}:
let
  version = "1.0.1";

  src = fetchurl {
    url = "https://registry.npmjs.org/modern-web-guidance/-/modern-web-guidance-${version}.tgz";
    hash = "sha256-cT09NE1vrVySZ/se2Nr/Xdct9GNOmtayvTsMoX+EOKM=";
  };

  skillVersion = "2026_11_10-47b4c80e";
in
stdenv.mkDerivation {
  pname = "modern-web-guidance";
  inherit version src;

  nativeBuildInputs = [
    makeWrapper
    nodejs_22
  ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    mkdir -p "''${out}/share"
    cp -r skills "''${out}/share/skills"

    # The CLI resolves its search index and guides relative to itself,
    # so the whole skill directory has to stay together.
    chmod +x "''${out}/share/skills/modern-web-guidance/"*.mjs

    # Call the packaged CLI instead of `npx modern-web-guidance@latest`
    # so the guidance stays offline and version-locked.
    substituteInPlace \
      "''${out}/share/skills/modern-web-guidance/SKILL.md" \
      --replace-fail 'npx -y modern-web-guidance@latest' 'modern-web-guidance' \
      --replace-fail \
        'Run `modern-web-guidance` directly with `npx` using' \
        'Run `modern-web-guidance` directly using'

    # The upstream "Using npx / pnpx" section only applies to the
    # network-fetched CLI; this one is installed locally and offline.
    substituteInPlace \
      "''${out}/share/skills/modern-web-guidance/SKILL.md" \
      --replace-fail \
        '## Using npx / pnpx' \
        '## Running the CLI' \
      --replace-fail \
        '- **Runner & Permissions**: Prefer `pnpx` over `npx` if `pnpm` is available (`pnpx` does not use `-y`); on Windows, use `npx.cmd`. When requesting tool permissions, allowlist `modern-web-guidance *` (or `pnpx modern-web-guidance@latest *`) specifically, never bare `npx *` or `pnpx *`.' \
        '- **Runner & Permissions**: The `modern-web-guidance` CLI is installed locally and runs offline. Allowlist `modern-web-guidance *` when requesting tool permissions.' \
      --replace-fail \
        '- **Sandboxes & Network**: Fetching `modern-web-guidance` requires outbound network access. In sandboxed or approval-gated environments (e.g., Codex, Claude Code), **proactively request approval/allowlisting with network access BEFORE the first execution** to avoid timeouts, and set `NPM_CONFIG_CACHE=/tmp/npm-cache` if `~/.npm` is read-only.' \
        '- **Sandboxes**: No network access is required; the CLI ships with its own offline search index.' \
      --replace-fail \
        '- **Offline**: If the command hangs due to being offline, retry with `npx --offline …`.' \
        '- **Offline**: The CLI works fully offline.'

    mkdir -p "''${out}/bin"
    makeWrapper "''${out}/share/skills/modern-web-guidance/modern-web.mjs" \
      "''${out}/bin/modern-web-guidance" \
      --set PATH "${lib.makeBinPath [ nodejs_22 ]}:\$PATH"
  '';

  passthru = {
    inherit skillVersion;
  };

  meta = {
    description = "Skills that embed modern web platform expertise and browser compatibility data into coding agents";
    homepage = "https://developer.chrome.com/docs/modern-web-guidance";
    license = lib.licenses.asl20;
    mainProgram = "modern-web-guidance";
  };
}
