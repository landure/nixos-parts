/**
  # GNU/Linux Users settings

  Set `users.users.<username>.isNormalUser` to `true` for GNU\Linx operating systems.

  ## 📝 Documentation

  ### ❄️ NixOS

  - [users.users.<name>.isNormalUser @ NixOS reference](https://search.nixos.org/options?type=options&query=users.users.%3Cname%3E.isNormalUser)
*/
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.attrsets) mapAttrs;
  inherit (lib.modules) mkDefault mkIf;
  inherit (pkgs.stdenv) isLinux;

  buildUserSettings = username: _: {
    isNormalUser = mkDefault true;
  };
in
{
  config = mkIf isLinux {
    users.users = mapAttrs buildUserSettings config.biapy.users.users;
  };
}
