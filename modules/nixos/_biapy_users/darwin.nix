/**
  # Darwin Users settings

  Adjust `users.users.<username>.home` to `/Users/<username>` for Darwin OS (macOS).

  ## 📝 Documentation

  ### ❄️ NixOS

  - [users.users.<name>.home @ NixOS reference](https://search.nixos.org/options?type=options&query=users.users.%3Cname%3E.home)
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
  inherit (pkgs.stdenv) isDarwin;

  buildUserSettings = username: _: {
    home = mkDefault "/Users/${username}";
  };
in
{
  config = mkIf isDarwin {
    users.users = mapAttrs buildUserSettings config.biapy.users.users;
  };
}
