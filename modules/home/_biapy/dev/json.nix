/**
  # JSON command-line tools

  ## 🛠️ Tech Stack

  - [fx homepage](https://fx.wtf/)
    ([fx @ GitHub](https://github.com/antonmedv/fx))
    is a terminal JSON viewer & processor.
  - [jsongrep (`jg`) @ GitHub](https://github.com/micahkepe/jsongrep)
    is a command-line tool and Rust library for fast querying of JSON, YAML,
    TOML, JSONL, CBOR, and MessagePack documents
    with regular path expressions.
  - [Json Incremental Digger (`jid`) @ GitHub](https://github.com/simeji/jid)
    drills down JSON interactively.
  - [jq homepage](https://jqlang.org/)
    ([jq @ GitHub](https://github.com/jqlang/jq))
    is a lightweight and flexible command-line JSON processor akin to `sed`.
  - [jqp @ Noah Gorstein](https://www.noahgorstein.com/projects/jqp)
    ([jqp @ GitHub](https://github.com/noahgorstein/jqp))
    is a TUI playground to experiment with `jq`.

  ## 📝 Documentation

  ### 🏠 Home Manager

  - [programs.jq @ Home Manager documentation](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.jq.enable).
  - [programs.jq @ NixOS reference](https://search.nixos.org/options?source=home_manager&query=programs.jq.).
  - [programs.jqp @ Home Manager documentation](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.jqp.enable).
  - [programs.jqp @ NixOS reference](https://search.nixos.org/options?source=home_manager&query=programs.jqp.).
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

  cfg = config.biapy.dev.json;

in
{
  options.biapy.dev.json.enable = mkEnableOption "JSON command-line tools";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      fx
      jsongrep
      jid
    ];

    programs = {
      jq.enable = mkDefault true;
      jqp.enable = mkDefault true;
    };
  };
}
