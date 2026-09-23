/**
 # System default user

 Set the main user of the system.

 */
{ config, lib, ... }:
let
  inherit (lib.modules) mkDefault;
  inherit (lib.options) mkOption;
  inherit (lib.types) str;

  cfg = config.biapy;
in
{
  options.biapy.defaultUser = mkOption {
    description = "username of the Operating System's main user";
    type = str;
  };

  config = {
    users.users.${cfg.defaultUser}.isNormalUser = mkDefault true;
  };
}
