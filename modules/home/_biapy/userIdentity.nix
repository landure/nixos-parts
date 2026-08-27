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
  self,
  ...
}:
let
  # inherit (lib)  warn;
  inherit (lib.types) path str;
  inherit (lib.modules) mkDefault;
  inherit (lib.options) mkOption;
  inherit (lib.strings) toUpper;

  cfg = config.biapy.userIdentity;

  osIdentity = osConfig.biapy.users.users.${config.home.username}.identity;

  # secretsDir = "${self}/secrets/users/${username}.yaml";

  # getUserHomeSecretsPath =
  #   username:
  #   let
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
  options.biapy.userIdentity = {
    firstname = mkOption {
      type = str;
      default = osIdentity.firstname or null;
      description = "User firstname";
    };
    lastname = mkOption {
      type = str;
      default = osIdentity.lastname or null;
      description = "User lastname";
    };
    fullname = mkOption {
      type = str;
      default = osIdentity.fullname or "${cfg.firstname} ${toUpper cfg.lastname}";
      description = "User fullname";
    };
    email = mkOption {
      type = str;
      default = osIdentity.email or null;
      description = "User email address";
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
    sopsFile = mkOption {
      type = path;
      default = "${self}/secrets/users/${config.home.username}.${config.biapy.userIdentity.sopsFormat}";
      description = ''
        Users secrets, stored in a SOPS file. Must contains:

        - `ssh/identities/id_ed25519/private_key`: ed25519 cryptographic identity private key
        - `ssh/identities/id_ed25519/public_key`: ed25519 cryptographic identity public key
      '';
    };
    sopsFormat = mkOption {
      type = str;
      default = "yaml";
      description = "User secrets SOPS file format";
    };
  };

  config = {
    programs.git.settings = {
      user = {
        name = mkDefault cfg.fullname;
        email = mkDefault cfg.email;
      };
    };

    sops = {
      defaultSopsFile = cfg.sopsFile;
      defaultSopsFormat = "yaml";

      secrets = {
        "ssh/identities/id_ed25519/public_key".path =
          mkDefault "${config.home.homeDirectory}/.ssh/id_ed25519.pub";
        "ssh/identities/id_ed25519/private_key".path =
          mkDefault "${config.home.homeDirectory}/.ssh/id_ed25519";
      };
    };
  };
}
