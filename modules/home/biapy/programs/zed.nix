/**
  # Zed editor

  ## 🛠️ Tech Stack
  - [Zed homepage](https://zed.dev/)
    ([Zed @ GitHub](https://github.com/zed-industries/zed)).

  ### 🧩 Zed extensions

  - [PHP @ Zed documentation](https://zed.dev/docs/languages/php/).
    ([PHP Zed extension @ GitHub](https://github.com/zed-extensions/php)).
  - [psalm Zed Extension @ GitHub](https://github.com/sebcode/psalm-zed).
  - [PHPCS LSP for Zed Editor @ GitHub](https://github.com/GeneaLabs/zed-phpcs-lsp).
  - [PHPMD Language Server for Zed Editor @ GitHub](https://github.com/GeneaLabs/zed-phpmd-lsp).

  ## 📝 Documentation

  ### 🏠 Home Manager

  - [programs.zed](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zed-editor.enable).

  ### 🎨 Stylix

  - [Zed](https://nix-community.github.io/stylix/options/modules/zed.html).

  ## 🙇 Acknowledgements

  - [Zed @ Official NixOS Wiki](https://wiki.nixos.org/w/index.php?title=Zed).
  - [Configuring Zed Editor with Nix: A Modern Development Setup @ Nohup](https://nohup.no/zed-editor/).
  - [Configurer votre éditeur Zed sur le bout des doigts @ Le blog de Seboss666 🇫🇷](https://blog.seboss666.info/2026/04/configurer-votre-editeur-zed-sur-le-bout-des-doigts/).
*/
{ config, lib, ... }:
let
  inherit (lib.modules) mkDefault;

  module =
    { config, lib, ... }:
    let
      inherit (lib.modules) mkDefault mkIf;
      inherit (lib.options) mkEnableOption;

      cfg = config.biapy.programs.zed;

    in
    {
      options = {
        biapy.programs.zed.enable = mkEnableOption "Zed editor";
      };

      config = mkIf cfg.enable {
        home.shellAliases.zed = mkDefault "zeditor";

        programs.zed-editor = {
          enable = mkDefault true;

          # A list of the extensions Zed should install on startup.
          # See https://github.com/zed-industries/extensions/tree/main/extensions
          extensions = mkDefault [
            "git-firefly" # Git Syntax Highlighting
            "nix"
            "opentofu"
            "php"
            "phpcs"
            "phpmd"
            "psalm"
            "php-snippets"
            "dockerfile"
            "docker-compose"
            "helm"
            "markdownlint"
            "marksman"
            "catppucin"
            "catppuccin-icons"
            "golangci-lint"
            "gosum"
            "go-snippets"
            "gotmpl"

            "ruff" # Python linter

            "toml"
          ];

          # Extra packages available to Zed.
          # extraPackages = [ ];

          # Whether to symlink the Zed's remote server binary to the expected location.
          # This allows remotely connecting to this system from a distant Zed client.
          # installRemoteServer = true;

          # Whether user keymaps (keymap.json) can be updated by zed.
          # mutableUserKeymaps = true;

          # Configuration written to Zed's keymap.json.
          userKeymaps = [
            #   {
            #     context = "Workspace";
            #     bindings = {
            #       ctrl-shift-t = "workspace::NewTerminal";
            #     };
            #   }

            # Rebind ctrl-r to history search in terminal
            {
              "context" = "Terminal";
              "bindings" = {
                ctrl-r = [
                  "terminal::SendKeystroke"
                  "ctrl-r"
                ];
              };
            }
          ];

          # Whether user settings (settings.json) can be updated by zed.
          # mutableUserSettings = true;

          # Configuration written to Zed's settings.json.
          userSettings = {
            agent = {
              default_model = {
                provider = mkDefault "copilot_chat";
                model = mkDefault "claude-sonnet-4";
              };
              model_parameters = mkDefault [ ];
            };

            buffer_font_size = mkDefault 12.0;

            languages.PHP = {
              language_servers = mkDefault [
                "!intelephense"
                "phpactor"
                "phpcs"
                "psalm"
                "phpmd"
              ];
            };

            lsp = {
              psalm.settings.require_config_file = mkDefault true;
              phpmd.settings.rulesets = mkDefault "./phpmd.xml";
            };

            # Use Helm language highlighting for some yaml files.
            "file_types" = {
              "Helm" = mkDefault [
                "**/templates/**/*.tpl"
                "**/templates/**/*.yaml"
                "**/templates/**/*.yml"
                "**/helmfile.d/**/*.yaml"
                "**/helmfile.d/**/*.yml"
                "**/values*.yaml"
              ];
            };

            #   features = {
            #     copilot = false;
            #   };

            # Disable telemetry
            telemetry.metrics = mkDefault false;

            #   vim_mode = false;
            #   ui_font_size = 16;
            #   buffer_font_size = 16;

            # Change panels position
            # notification_panel = {
            #   dock = "left";
            # };
            # chat_panel = {
            #   dock = "left";
            # };
            # outline_panel = {
            #   dock = "right";
            # };
            # project_panel = {
            #   dock = "right";
            # };

          };

          # Configuration written to Zed's tasks.json.
          # List of tasks that can be run from the command palette.
          # userTasks = [
          #   {
          #     label = "Format Code";
          #     command = "nix";
          #     args = [
          #       "fmt"
          #       "$ZED_WORKTREE_ROOT"
          #     ];
          #   }
          # ];

          # Each theme is written to $XDG_CONFIG_HOME/zed/themes/theme-name.json
          # where the name of each attribute is the theme-name
          # themes = {}
        };

      };
    };
in
{
  flake-file.inputs = {
    zed = {
      url = mkDefault "github:zed-industries/zed";
      inputs = {
        nixpkgs.follows = mkDefault "nixpkgs";
        flake-parts.follows = mkDefault "flake-parts";
      };
    };
  };

  flake = {
    biapy."programs.zed" = module;

    tests = {
      "biapy.\"programs.zed\"" = {
        "test: declare module" = {
          expr = config.flake.biapy ? "programs.zed";
          expected = true;
        };
      };
    };
  };
}
