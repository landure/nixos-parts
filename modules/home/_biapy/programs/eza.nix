/**
  # eza

  eza is a modern alternative to ls.

  ## 🛠️ Tech Stack

  - [eza homepage](https://eza.rocks/)
    ([eza @ GitHub](https://github.com/eza-community/eza)).

  ## 📝 Documentation

  ### 🏠 Home Manager

  - [programs.eza](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.eza.enable).

  ## 🙇 Acknowledgements

  - [default -t to modified -r to be backward compatible with ls @ eza's GitHub](https://github.com/eza-community/eza/issues/980).
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

  cfg = config.biapy.programs.eza;

  eza_exe = getExe config.programs.eza.package;
in
{
  options = {
    biapy.programs.eza = {
      enable = mkEnableOption "eza";
    };
  };

  config = mkIf cfg.enable {
    programs.eza = {
      enable = mkDefault true;
      colors = mkDefault "auto";
      git = mkDefault true;
      icons = mkDefault "auto";
      extraOptions = mkDefault [
        "--group-directories-first"
        "--header"
      ];
    };

    home.packages = [
      (pkgs.writeShellScriptBin "lazes" ''
        # ls compatibility wrapper for eza
        args=()
        while [ "''${#}" -gt 0 ]; do
            arg="''${1}"
            shift
            case "''${arg}" in
                --)
                    args+=("''${arg}")
                    break;
                    ;;
                --directory)
                    args+=('--list-dirs')
                    ;; # Replace --directory with --list-dirs
                --numeric-uid-gid)
                    args+=('--numeric')
                    ;; # Replace --numeric-uid-gid with --numeric
                --block-size | --author | --escape | --dired | --full-time | --kibibytes | --literal | --quoting-style | --size | --time-style | --width)
                    if [ "''${#}" -gt 0 ] && [ "''${1#-}" = "''${1}" ]; then
                        shift
                    fi
                    ;;
                --sort | --sort=* | --time | --time=* | --indicator-style | --indicator-style=* | --color | --color=* | --hyperlink | --hyperlink=*)
                    if [ "''${arg#*=}" != "''${arg}" ]; then
                        args+=("''${arg}")
                    else
                        if [ "''${#}" -gt 0 ] && [ "''${1#-}" = "''${1}" ]; then
                            args+=("''${arg}" "''${1}")
                            shift
                        else
                            args+=("''${arg}")
                        fi
                    fi
                    ;;
                --*)
                    args+=("''${arg}")
                    ;;
                -*)
                    arg="''${arg#-}"
                    while [ -n "''${arg}" ]; do
                        char="''${arg%"''${arg#?}"}"
                        case "''${char}" in
                            t)
                                args+=('--sort=modified')
                                ;; # Suppress -t
                            r)
                                args+=('--reverse')
                                ;; # Suppress -r
                            S)
                                args+=('--sort=size')
                                ;; # Supress -S
                            s)
                                ;; # Supress -s (no equivalent in eza)
                            c)
                                args+=('--sort=changed')
                                ;; # Supress -c
                            u)
                                args+=('--sort=accessed')
                                ;; # Supress -u
                            1)
                                args+=('--oneline')
                                ;; # Supress -1
                            g)
                                args+=('--group')
                                ;; # Supress -g
                            d)
                                args+=('--list-dirs')
                                ;; # Supress -d
                            p)
                                args+=('--indicator-style=slash')
                                ;; # Supress -p
                            *)
                                args+=("-''${char}")
                                ;;
                        esac
                        arg="''${arg#?}"
                    done
                    ;;
                *)
                    args+=("''${arg}")
                    ;;
            esac
        done

        args+=("''${@}")

        # Execute eza with the processed arguments
        exec ${eza_exe} "''${args[@]}"
      '')
    ];
  };
}
