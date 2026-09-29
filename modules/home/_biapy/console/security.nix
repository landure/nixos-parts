/**
  # command-line security tools

  ## 🛠️ Tech Stack

  ### Secret scanning

  - [betterleaks @ GitHub](https://github.com/betterleaks/betterleaks)
    is a code scanner that hunts for leaked secrets
    in source files, Git history, and CI logs.
  - [TruffleHog @ GitHub](https://github.com/trufflesecurity/trufflehog)
    finds leaked credentials, API keys, and tokens across
    filesystems, Git history, S3 buckets, Docker images, and CI logs.

  ### Password generation & strength

  - [apg @ GitHub](https://github.com/wilx/apg)
    is an Automated Password Generator for pronounceable
    and random passwords.
*/
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.modules) mkDefault mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.biapy.console.security;
in
{
  options.biapy.console.security.enable = mkEnableOption "command-line security tools";

  config = mkIf cfg.enable {
    biapy.programs.gpg.enable = mkDefault true;

    home = {
      shellAliases = {
        genpass = mkDefault ''apg -M SNCL -m 12 -x 20 -t -c "$(openssl rand 128)"'';
      };

      packages = with pkgs; [
        betterleaks # Code scanner for leaked secrets.
        trufflehog # Find leaked credentials, keys and tokens.
        apg # Automated Password Generator.
      ];
    };
  };
}
