/**
  # GitHub CLI

  ## 🛠️ Tech Stack

  - [GitHub CLI homepage](https://cli.github.com/)
    ([GitHub CLI @ GitHub](https://github.com/cli/cli)).

  # 🧩 Extensions

  - [GH Dash homepage](https://www.gh-dash.dev/)
    ([GH Dash @ GitHub](https://github.com/dlvhdr/gh-dash))
    displays a dashboard with pull requests and issues.
  - [Enhance @ GH Dash](https://www.gh-dash.dev/enhance)
    ([Enhance @ GitHub](https://github.com/dlvhdr/gh-enhance))
    is a Terminal UI for GitHub Actions.
  - [GH eco @ GitHub](https://github.com/jrnxf/gh-eco)
    allows to explore the ecosystem.
  - [gh-f @ GitHub](https://github.com/gennaro-tedesco/gh-f).
    is the ultimate, compact and snappy `fzf` extension for `gh` cli.
    It addresses most of your daily GitHub workflow, if not all of it:
    `f` stands for filter, `fzf,y or fomething felse.
  - [gh-notify @ GitHub](https://github.com/meiji163/gh-notify)
    allows to view your GitHub notifications from the command line.
  - [gh-poi @ GitHub](https://github.com/seachicken/gh-poi)
    allows to safely clean up local branches you no longer need.
  - [gh-s @ GitHub](https://github.com/gennaro-tedesco/gh-s)
    allows to search GitHub repositories interactively
    from the command line.
  - [gh-signoff @ GitHub](https://github.com/basecamp/gh-signoff)
    allows to run tests on your own machine and sign off when they pass.

  ## 📝 Documentation

  ### 🏠 Home Manager Configuration Options

  - [programs.gh](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.gh.enable).
*/
{
  config,
  lib,
  pkgs,
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
    biapy.programs = {
      bat.enable = mkDefault true;
      fzf.enable = mkDefault true;
    };

    programs.gh = {
      enable = mkDefault true;
      gitCredentialHelper.enable = mkDefault true;

      extensions = with pkgs; [
        gh-dash
        gh-enhance
        gh-f
        gh-notify
        gh-poi
        gh-s
        gh-signoff
        biapy-parts.gh-secure
      ];

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
