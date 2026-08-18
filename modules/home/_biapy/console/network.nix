/**
  # command-line network tools

  ## 🛠️ Tech Stack

  - [dog-community homepage](https://dog.ramfield.net/)
    ([dog-community @ GitHub](https://github.com/Dj-Codeman/dog_community))
    is a modern `dig` written in Rust.
  - [doggo homepage](https://doggo.mrkaran.dev/)
    ([doggo @ GitHub](https://github.com/mr-karan/doggo)).
    is a modern `dig` written Go.
  - [gping @ GitHub](https://github.com/orf/gping)
    is `ping`, but with a graph.
  - [NBping @ GitHub](https://github.com/hanshuaikang/NBping)
    is a `ping` tool in Rust with real-time data and visualizations
  - [quien @ GitHub](https://github.com/retlehs/quien)
    is a better `whois` and domain intelligence toolkit
  - [snitch @ GitHub](https://github.com/karol-broda/snitch)
    is a friendler `ss`/`netstat` for humans.

  ## 🙇 Acknowledgements

  - [dog @ GitHub](https://github.com/ogham/dog).
  - [iproute2 @ GitHub](https://wiki.linuxfoundation.org/networking/iproute2)
    provides `ss`.
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

  cfg = config.biapy.console.network;
in
{
  options = {
    biapy.console.network = {
      enable = mkEnableOption "command-line network tools";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      dogedns # dig alternative
      doggo
      gping # ping with data visualization
      nbping
      snitch # ss alternative

      local.quien
    ];

    biapy.programs.trippy.enable = mkDefault true;
  };
}
