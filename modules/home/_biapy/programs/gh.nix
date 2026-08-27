/**
  # GitHub CLI

  ## 🛠️ Tech Stack

  - [GitHub CLI homepage](https://cli.github.com/)
    ([GitHub CLI @ GitHub](https://github.com/cli/cli)).

  ## 📝 Documentation

  ### 🏠 Home Manager Configuration Options

  - [programs.gh](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.gh.enable).
*/
{
  config,
  lib,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkDefault mkIf;

  cfg = config.biapy.programs.gh;
in
{
  options.biapy.programs.gh.enable = mkEnableOption "GitHub CLI";

  config = mkIf cfg.enable {
    programs.gh = {
      enable = mkDefault true;
      gitCredentialHelper.enable = mkDefault true;
      settings = {
        git_protocol = mkDefault "ssh";

        prompt = mkDefault "enabled";

        # see https://www.theregister.com/2026/04/22/github_opts_all_cli_users/
        telemetry = mkDefault "disabled";

        aliases = {
          co = mkDefault "pr checkout";
          pv = mkDefault "pr view";
        };
      };
    };
  };
}
