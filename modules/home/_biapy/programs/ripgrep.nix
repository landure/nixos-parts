/**
  # ripgrep

  ripgrep (`rg`) recursively searches directories for a regex pattern
  while respecting your gitignore.

  ## 🛠️ Tech Stack

  - [ripgrep @ GitHub](https://github.com/BurntSushi/ripgrep)

  ## 📝 Documentation

  ### 🏠 Home Manager

  - [programs.ripgrep @ Home Manager](https://nix-community.github.io/home-manager/options/home-manager/programs/ripgrep.html).
  - [programs.ripgrep @ NixOS reference](https://search.nixos.org/options?source=home_manager&query=programs.ripgrep.).

  ## 🙇 Acknowledgements

  - [ripgrep skill @ ratacat's Claude Skills' GitHub](https://github.com/ratacat/claude-skills/tree/main/skills/ripgrep).
*/
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.modules) mkDefault mkIf;
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.types) bool;

  cfg = config.biapy.programs.ripgrep;

in
{
  options.biapy.programs.ripgrep = {
    enable = mkEnableOption "ripgrep";

    withSkill = mkOption {
      type = bool;
      default = true;
      description = "Install the ripgrep agent skill.";
    };
  };

  config = mkIf cfg.enable {
    programs.ripgrep.enable = mkDefault true;

    biapy.ai.skills.skills = mkIf cfg.withSkill {
      ripgrep = mkDefault (
        pkgs.fetchFromGitHub {
          owner = "ratacat";
          repo = "claude-skills";
          rev = "d4b471d05ddad5c69a8c0e1da69fd94e957f0a4b";
          hash = "sha256-1/UCDkqqrylEvNvss3LAL1MRFzk7FTzTPDUgvenddu8=";
        }
        + "/skills/ripgrep"
      );
    };
  };
}
