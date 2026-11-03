/**
  # systemd-inhibit aliases

  Add aliases to inhibit energy saving features in systemd.

  ## Aliases

  - `block-sleep`: block systemd from sleeping
  - `unblock-sleep`: unblock systemd from sleeping

  ## Thanks

  - [Keeping sessions alive with systemd-inhibit @ ~/kd8bny](https://kd8bny.com/posts/session_inhibit/).
*/
{ config, lib, ... }:
let
  inherit (lib.modules) mkDefault mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.biapy.shellAliases.systemd-inhibit;

in
{
  options.biapy.shellAliases.systemd-inhibit.enable = mkEnableOption "block-sleep & unblock-sleep";

  config = mkIf cfg.enable {
    home.shellAliases = {
      block-sleep = mkDefault ''command systemd-inhibit --no-ask-password --what="idle" --who="''${USER}" --why="cuz I said so" sh & disown; export INHIBIT_PID="''${!}"'';
      unblock-sleep = mkDefault ''command kill -SIGKILL "''${INHIBIT_PID}"; INHIBIT_PID=""'';
    };
  };
}
