/**
  # User GECOS identity

  Automatically configure SSH identities from sops secrets.

  ## 📝 Documentation

  ### ❄️ NixOS

  - [users.users.<name>.description @ NixOS reference](https://search.nixos.org/options?query=users.users.%3Cname%3E.description&type=options)

  ## 🙇 Acknowledgements

  - [GECOS field @ Wikipedia](https://en.wikipedia.org/wiki/Gecos_field).
*/
{
  config,
  lib,
  ...
}:
let
  inherit (lib.attrsets) attrNames mapAttrs;
  inherit (lib.modules) mkDefault mkIf;
  inherit (lib.options) mkOption;
  inherit (lib.strings)
    hasSuffix
    toUpper
    ;
  inherit (lib.trivial) pathExists;
  inherit (lib.types)
    attrsOf
    enum
    nullOr
    path
    str
    submodule
    ;

  cfg = config.biapy.users.users;

  getUserSecretsFormat =
    username:
    let
      secretsFile = config.biapy.users.users.${username}.secretsSopsFile or "";
    in
    if hasSuffix ".json" secretsFile then
      "json"
    else if hasSuffix ".ini" secretsFile then
      "ini"
    else
      "yaml";

  gecosIdentityOptions = {
    options = {
      firstname = mkOption {
        type = str;
        description = "User firstname";
      };
      lastname = mkOption {
        type = str;
        description = "User lastname";
      };
      email = mkOption {
        type = str;
        description = "User email address";
      };
      fullname = mkOption {
        type = str;
        default = "${cfg.firstname} ${toUpper cfg.lastname}";
        description = "User fullname";
      };
      roomNumber = mkOption {
        type = str;
        default = "";
        description = "User room number";
      };
      workPhone = mkOption {
        type = str;
        default = "";
        description = "User work phone";
      };
      homePhone = mkOption {
        type = str;
        default = "";
        description = "User home phone";
      };
    };
  };

  userOptions =
    { name, ... }:
    {
      options = {
        username = mkOption {
          type = str;
          default = name;
          readOnly = true;
          defaultText = "<username>";
          description = "username (login) of the user";
        };

        identity = mkOption {
          type = submodule gecosIdentityOptions;
          description = "User identity informations";
        };

        secretsSopsFile = mkOption {
          type = nullOr path;
          description = "Path of user secrets SOPS file";
          default = null;
          apply =
            value:
            if value == null then
              null
            else if !pathExists value then
              builtins.warn "Warning: '${value}' doesn't exits." null
            else
              value;
        };

        secretsFormat = mkOption {
          type = enum [
            "yaml"
            "json"
            "ini"
          ];
          default = getUserSecretsFormat name;
          description = "Path of user configuration is stored";
          defaultText = "<flake>/secrets/users/<username>.yaml";
        };
      };
    };

  toGECOS =
    identity:
    let
      gecos = {
        inherit (identity)
          fullname
          roomNumber
          workPhone
          homePhone
          ;
        other = identity.email;
      };
    in
    with gecos;
    "${fullname},${roomNumber},${workPhone},${homePhone},${other}";
in
{
  options.biapy.users.users = mkOption {
    type = attrsOf (submodule userOptions);
    description = "configuration of the user";
  };

  config = mkIf (builtins.length (attrNames cfg) > 0) {
    users.users = mapAttrs (username: userConfig: {
      description = mkDefault (toGECOS userConfig.identity);
    }) cfg;
  };
}
