/**
  # Modern Web Guidance

  Keep your coding agent up to date with the latest web best practices.

  Installs the upstream skills (`modern-web-guidance` and
  `chrome-extensions`) and the `modern-web-guidance` CLI, which serves
  the guidance from an offline search index — no network access and no
  `npx` round-trip at query time.

  ## 🛠️ Tech Stack

  - [Modern Web Guidance @ Chrome for Developers](https://developer.chrome.com/docs/modern-web-guidance)
    ([modern-web-guidance @ GitHub](https://github.com/GoogleChrome/modern-web-guidance)).
*/
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.types) enum listOf;

  cfg = config.biapy.skills.modern-web-guidance;

  package = pkgs.biapy-parts.modern-web-guidance;

  skills = [
    "chrome-extensions"
    "modern-web-guidance"
  ];
in
{
  options.biapy.skills.modern-web-guidance = {
    enable = mkEnableOption "Modern Web Guidance";

    skills = mkOption {
      type = listOf (enum skills);
      default = skills;
      description = "The Modern Web Guidance skills to install.";
      example = [
        "modern-web-guidance"
      ];
    };
  };

  config = mkIf cfg.enable {
    biapy.ai.skills.skills = builtins.listToAttrs (
      map (name: {
        inherit name;
        value = "${package}/share/skills/${name}";
      }) cfg.skills
    );

    # The CLI is called by the agent to search and retrieve guides.
    home.packages = [
      package
    ];
  };
}
