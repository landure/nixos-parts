/**
  # Home Manager User identity

  Automatically configure SSH identities from sops secrets.

  ## 🙇 Acknowledgements

  - [Keeping Nix Secrets with Sops: Integration and Applications @ ~/kobi-medrish](https://kobimedrish.com/posts/keeping_nix_secrets_with_sops_integratoin_and_applictions/).
*/
{
  config,
  lib,
  osConfig,
  ...
}:
let
  # inherit (lib)  warn;
  inherit (lib.modules) mkDefault mkIf;
  inherit (lib.options) mkOption;
  inherit (lib.strings) toUpper trim;
  inherit (lib.types)
    nullOr
    path
    str
    submodule
    ;

  cfg = config.biapy.user;

  osUser =
    if
      osConfig ? "biapy"
      && osConfig.biapy ? "users"
      && osConfig.biapy.users ? "users"
      && osConfig.biapy.users.users ? config.home.username
    then
      osConfig.biapy.users.users.${config.home.username}
    else
      { };

  osIdentity = osUser.identity or { };

  gecosIdentityOptions = {
    options = {
      firstname = mkOption {
        type = nullOr str;
        default = osIdentity.firstname or null;
        description = "User firstname";
      };
      lastname = mkOption {
        type = nullOr str;
        default = osIdentity.lastname or null;
        description = "User lastname";
      };
      email = mkOption {
        type = nullOr str;
        default = osIdentity.email or null;
        description = "User email address";
      };
      fullname = mkOption {
        type = str;
        default =
          osIdentity.fullname or (trim "${osIdentity.firstname or ""} ${toUpper osIdentity.lastname or ""}");
        description = "User fullname";
      };
      roomNumber = mkOption {
        type = str;
        default = osIdentity.roomNumber or "";
        description = "User room number";
      };
      workPhone = mkOption {
        type = str;
        default = osIdentity.workPhone or "";
        description = "User work phone";
      };
      homePhone = mkOption {
        type = str;
        default = osIdentity.homePhone or "";
        description = "User home phone";
      };
    };
  };

  # secretsDir = "${self}/secrets/users/${username}.yaml";

  # getUserHomeSecretsPath =
  #   username:
  #   let
  #
  #     secretsFile = secretsDir + "/${username}.yaml";
  #   in
  #   if builtins.pathExists secretsFile then secretsFile else null;

  # homeSecretsPath = getUserHomeSecretsPath username;
  # hasHomeSecrets =
  #   if homeSecretsPath != null then
  #     true
  #   else
  #     warn "Warning: user '${username}' `sops.defaultSopsFile` '${homeSecretsPath}' doesn't exists." false;

in
{
  options.biapy.user = {
    identity = mkOption {
      type = submodule gecosIdentityOptions;
      description = "User identity informations";
    };

    secretsSopsFile = mkOption {
      type = nullOr path;
      default = osUser.secretsSopsFile or null;
      description = ''
        Users secrets, stored in a SOPS file. Must contains:

        - `ssh/identities/id_ed25519/private_key`: ed25519 cryptographic identity private key
        - `ssh/identities/id_ed25519/public_key`: ed25519 cryptographic identity public key
      '';
    };
    secretsFormat = mkOption {
      type = str;
      default = osUser.secretsFormat or "yaml";
      description = "User secrets SOPS file format";
    };
  };

  config = {
    programs.git.settings = {
      user = {
        name = mkDefault cfg.identity.fullname;
        email = mkDefault cfg.identity.email;
      };
    };

    sops = mkIf (null != cfg.secretsSopsFile) {
      defaultSopsFile = cfg.secretsSopsFile;
      defaultSopsFormat = cfg.secretsFormat;

      secrets = {
        "ssh/identities/id_ed25519/public_key".path =
          mkDefault "${config.home.homeDirectory}/.ssh/id_ed25519.pub";
        "ssh/identities/id_ed25519/private_key".path =
          mkDefault "${config.home.homeDirectory}/.ssh/id_ed25519";
      };
    };
  };
}
