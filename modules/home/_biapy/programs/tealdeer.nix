/**
  # Tealdeer

  Tealdeer is a very fast implementation of `tldr` in Rust:
  Simplified, example based and community-driven man pages.

  ## 🛠️ Tech Stack

  - [tldr pages homepage](https://tldr.sh/).
  - [Tealdeer homepage](https://docs.tealdeer.org/stable/)
    ([Tealdeer @ GitHub](https://github.com/tealdeer-rs/tealdeer)).

  ## 📝 Documentation

  ### 🏠 Home Manager

  - [programs.tealdeer @ Home Manager](https://nix-community.github.io/home-manager/options/home-manager/programs/tealdeer.html).
  - [programs.tealdeer @ NixOS reference](https://search.nixos.org/options?source=home_manager&query=programs.tealdeer.).
*/
{
  config,
  lib,
  ...
}:
let
  inherit (lib.meta) getExe;
  inherit (lib.modules) mkDefault mkIf;
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.types) bool;

  cfg = config.biapy.programs.tealdeer;

in
{
  options.biapy.programs.tealdeer = {
    enable = mkEnableOption "Tealdeer";

    withSkill = mkOption {
      type = bool;
      default = true;
      description = "Install the tldr agent skill.";
    };
  };

  config = mkIf cfg.enable {
    home.shellAliases = {
      help = "${getExe config.programs.tealdeer.package}";
    };

    programs.tealdeer = {
      enable = mkDefault true;
      settings = {
        # Whether to enable auto-update.
        updates.auto_update = mkDefault true;
      };
    };

    biapy.ai.skills.skills = mkIf cfg.withSkill {
      tldr = mkDefault ''
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
      '';
    };
  };
}
