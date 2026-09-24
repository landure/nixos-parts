/**
  # PHP tools

  ## 🛠️ Tech Stack

  - [mago homepage](http://mago.carthage.software/)
    ([mago @ GitHub](https://github.com/carthage-software/mago))
    is a toolchain for PHP that aims to provide a set of tool
    to help developers write better code.
  - [PHPantom homepage](https://phpantom-dev.github.io/phpantom_lsp/)
    ([PHPantom @ GitHub](https://github.com/PHPantom-dev/phpantom_lsp))
    is a fast, lightweight PHP language server written in Rust.
  - [PHP Zed Extension @ GitHub](https://github.com/zed-extensions/php).

  ## 📝 Documentation

  - [PHP @ Zed documentation](https://zed.dev/docs/languages/php).
*/
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.meta) getExe;
  inherit (lib.modules) mkDefault mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.biapy.dev.php;
in
{
  options.biapy.dev.php.enable = mkEnableOption "PHP development tools";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      mago
      phpantom-lsp
      phpactor
      php85
    ];

    programs = {
      opencode.settings.lsp.phpantom = mkDefault {
        command = [ (getExe pkgs.phpantom-lsp) ];
        extensions = [ ".php" ];
      };

      zed-editor = {
        extensions = mkDefault [
          "php"
          "phpcs"
          "phpmd"
          "psalm"
          "php-snippets"
        ];

        userSettings = {
          languages.PHP = {
            language_servers = mkDefault [
              "phpantom"
              "phpactor"
              "!intelephense"
              "!phpcs"
              "!psalm"
              "!phpmd"
            ];
            format_on_save = mkDefault "on";
            formatter.external = {
              command = mkDefault (getExe pkgs.mago);
              arguments = mkDefault [
                "format"
                "--stdin-input"
              ];
            };
          };

          lsp = {
            psalm.settings.require_config_file = mkDefault true;
            phpmd.settings.rulesets = mkDefault "./phpmd.xml";
          };
        };
      };
    };
  };
}
