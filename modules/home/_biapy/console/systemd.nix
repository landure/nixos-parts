/**
  # command-line systemd tools

  ## 🛠️ Tech Stack

  - [isd](https://kainctl.github.io/isd/)
    ([isd @ GitHub](https://github.com/kainctl/isd))
    is a systemd TUI
  - [LazyJournal @ GitHub](https://github.com/Lifailon/lazyjournal).
  - [systeroid](https://systeroid.cli.rs/)
    ([systeroid @ GitHub](https://github.com/orhun/systeroid)).

  ## 🙇 Acknowledgements

  - [ISD 0.6 Released For Interactive Systemd Management @ phoronix](https://www.phoronix.com/news/interactive-systemd-isd-0.6).
  - [Episode 635: The Texas Linux Fest Special @ Linux Unplugged](https://linuxunplugged.com/635).
*/
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;

  cfg = config.biapy.console.systemd;
in
{
  options = {
    biapy.console.systemd = {
      enable = mkEnableOption "systemd tools";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      isd
      lazyjournal
      systeroid
    ];
  };
}
