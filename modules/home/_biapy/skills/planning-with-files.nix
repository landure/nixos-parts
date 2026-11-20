/**
  # Planning with Files

  Persistent file-based planning for AI coding agents.

  Installs the upstream skill, the Claude Code plugin (hooks + slash
  commands) and the native OpenCode plugin (plan injection, write
  reminders, compaction flush, completion gate and the `pwf_init`,
  `pwf_status` and `pwf_check` tools).

  ## 🛠️ Tech Stack

  - [planning-with-files homepage](https://planningwithfiles.tech/)
    ([planning-with-files @ GitHub](https://github.com/OthmanAdi/planning-with-files)).
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

  cfg = config.biapy.skills.planning-with-files;

  package = pkgs.biapy-parts.planning-with-files;
in
{
  options.biapy.skills.planning-with-files.enable = mkEnableOption "planning-with-files";

  config = mkIf cfg.enable {
    biapy.ai.skills.skills = {
      "planning-with-files" = mkDefault "${package}/skills/planning-with-files";
    };

    # Claude Code plugin: the package root is the plugin directory, it
    # carries the `.claude-plugin/plugin.json` manifest, the lifecycle
    # hooks and the `/plan-*` slash commands.
    programs.claude-code.plugins = mkDefault [
      package
    ];

    programs.opencode = {
      # OpenCode plugin: opencode loads the TypeScript entry point and
      # resolves `@opencode-ai/plugin` from its own runtime.
      settings.plugins = [
        "${package}/.opencode/plugins"
      ];

      # OpenCode slash commands.
      commands = mkDefault {
        pwf = mkDefault "${package}/.opencode/commands/pwf.md";
        pwf-status = mkDefault "${package}/.opencode/commands/pwf-status.md";
      };
    };
  };
}
