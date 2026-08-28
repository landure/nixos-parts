# List of users for darwin or nixos system and their top-level configuration.
{
  config,
  lib,
  self,
  ...
}:
let
  inherit (lib.attrsets)
    attrValues
    mapAttrs
    mergeAttrsList
    ;
  inherit (lib.modules) mkDefault;
  inherit (lib.options) mkOption;
  inherit (lib.types) path;

  cfg = config.biapy.users.users;
in
{
  options = {
    biapy.users.secretsDirectory = mkOption {
      type = path;
      default = "${self}/secrets/users";
      defaultText = "<flake>/secrets/users";
      description = "Path of the users SOPS secrets files";
    };
  };

  config = {
    sops.secrets = (
      mergeAttrsList (
        attrValues (
          mapAttrs (
            username: userConfig:
            if null != userConfig.secretsSopsFile then
              {
                "${username}:hashedPassword" = {
                  neededForUsers = true;
                  key = "hashedPassword";
                  sopsFile = userConfig.secretsSopsFile;
                  format = userConfig.secretsFormat;
                };

                # Install users age keys indepently of Home Manager.
                # This allows Home Manager service to decrypt secrets.
                "${username}:sops-age-keys.txt" = {
                  key = "config/sops/age/keys.txt";
                  sopsFile = userConfig.secretsSopsFile;
                  format = userConfig.secretsFormat;
                  path = "/var/lib/sops-nix/users/${username}.txt";
                  owner = username;
                };
              }
            else
              { }
          ) cfg
        )
      )
    );

    users.users = (
      mapAttrs (username: _: {
        hashedPasswordFile = mkDefault config.sops.secrets."${username}:hashedPassword".path;
      }) cfg
    );
  };
}
