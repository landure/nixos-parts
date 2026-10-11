{ config, lib, ... }:
let
  inherit (lib.attrsets) attrNames;
  inherit (lib.options) mkOption; 
  inherit (lib.types) listOf str;
in
{
  options.biapy.normalUsers = mkOption {
    description = "list of normal users (users with `isNormalUser` set to `true`)";
    type = listOf str;
    internal = true;
    default = attrNames config.biapy.users.users;
  };
}
