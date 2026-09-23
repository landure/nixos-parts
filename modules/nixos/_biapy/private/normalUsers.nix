{ config, lib, ... }:
let
  inherit (lib.attrsets) attrNames filterAttrs;
  inherit (lib.options) mkOption;
  inherit (lib.types) listOf str;
in
{
  options.biapy.normalUsers = mkOption {
    description = "list of normal users (users with `isNormalUser` set to `true`)";
    type = listOf str;
    default = attrNames (filterAttrs (_: user: user.isNormalUser) config.users.users);
  };
}
