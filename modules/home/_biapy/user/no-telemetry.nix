/**
  # No Telemetry

  Set DO_NOT_TRACK and DISABLE_TELEMETRY env vars.

  ## 🙇 Acknowledgements

  - [DO_NOT_TRACK homepage](https://donottrack.sh/).
  - [z_env: Disable telemetry ENV VARIABLES @ HariantoAtWork's GitHub Gist](https://gist.github.com/HariantoAtWork/24ebe0b32910fb3e81aeab9995666b0b).
  - [Common opt-out of telemetry environment variables @ Jon LaBelle's snippets](https://jonlabelle.com/snippets/view/markdown/common-opt-out-of-telemetry-environment-variables).
*/
{
  config,
  lib,
  ...
}:
let
  # inherit (lib)  warn;
  inherit (lib.modules) mkDefault mkIf;
  inherit (lib.options) mkEnableOption;
  cfg = config.biapy.user.no-telemetry;
in
{
  options.biapy.biapy.user.no-telemetry.enable = mkEnableOption "Turn Off Telemetry" // {
    default = true;
  };

  config = mkIf cfg.enable {
    home.sessionVariables = {
      DO_NOT_TRACK = mkDefault "1";
      DISABLE_TELEMETRY = mkDefault "1";
      TELEMETRY_OPTOUT = mkDefault "1";

      # JS / Frontend frameworks
      NEXT_TELEMETRY_DISABLED = mkDefault "1";
      NG_CLI_ANALYTICS = mkDefault "false";
      VERCEL_ANALYTICS_ID = mkDefault "";
      SENTRY_DSN = mkDefault "";
      GA_DISABLE = mkDefault "true";
      ASTRO_TELEMETRY_DISABLED = mkDefault "1";
      GATSBY_TELEMETRY_DISABLED = mkDefault "1";
      # Prisma
      CHECKPOINT_DISABLE = mkDefault "1";

      # Package managers
      NO_UPDATE_NOTIFIER = mkDefault "1"; # npm
      YARN_DISABLE_SELF_UPDATE_CHECK = mkDefault "1";
      PNPM_DISABLE_OPTOUT = mkDefault "1";
      HOMEBREW_NO_ANALYTICS = mkDefault "1";

      # Microsoft / .NET
      DOTNET_CLI_TELEMETRY_OPTOUT = mkDefault "1";
      POWERSHELL_TELEMETRY_OPTOUT = mkDefault "1";

      # Rust
      CARGO_DISABLE_CREDENTIAL_HELPER = mkDefault "1";

      # Python / pip
      PIP_DISABLE_PIP_VERSION_CHECK = mkDefault "1";

      # VSCode
      VSCODE_DISABLE_TELEMETRY = mkDefault "1";

      # Better Auth
      BETTER_AUTH_TELEMETRY = mkDefault "0";
      BETTER_AUTH_TELEMETRY_DEBUG = mkDefault "0";

      # Nuxt
      NUXT_TELEMETRY_DISABLED = mkDefault "true";
    };
  };
}
