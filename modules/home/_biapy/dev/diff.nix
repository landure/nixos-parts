/**
  # diff tools

  ## 🛠️ Tech Stack

  - [delta homepage](https://dandavison.github.io/delta/)
    ([delta @ GitHub](https://github.com/dandavison/delta))
    is a syntax-highlighting pager for git, diff, grep, rg --json, and blame output.
  - [difftastic homepage](https://difftastic.wilfred.me.uk/)
    ([difftastic @ GitHub](https://github.com/Wilfred/difftastic))
    is a structural diff tool that compares files based on their syntax.
  - [hunk homepage](https://hunk.dev/)
    ([hunk @ GitHub](https://github.com/modem-dev/hunk))
    is a review-first terminal diff viewer for agentic coders.
*/
{
  config,
  lib,
  pkgs,
  pkgs-unstable,
  ...
}:
let
  inherit (lib.modules) mkDefault mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.biapy.dev.diff;

in
{
  options = {
    biapy.dev.diff.enable = mkEnableOption "diff tools";
  };

  config = mkIf cfg.enable {
    programs = {
      delta.enable = mkDefault true;
      difftastic.enable = mkDefault true;
    };

    home.packages = with pkgs; [
      diffutils
      pkgs-unstable.hunk
    ];
  };
}
