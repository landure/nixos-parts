/**
  # Zswap configuration

  enable Zswap compressed swap.

  ## 📝 Documentation

  ### ❄️ NixOS

  - [boot.kernelParams @ NixOS reference](https://search.nixos.org/options?query=boot.kernelParams).

  ## 🙇 Acknowledgements

  - [Linux kernel @ Official NixOS Wiki](https://wiki.nixos.org/wiki/Linux_kernel).
  - [Swap @ Official NixOS Wiki](https://wiki.nixos.org/wiki/Swap).
  - [zswap @ kernel.org](https://www.kernel.org/doc/html/latest/admin-guide/mm/zswap.html).
*/
{ config, lib, ... }:
let
  inherit (lib.attrsets) mergeAttrsList;
  inherit (lib.lists) elem;
  inherit (lib.modules) mkDefault mkIf;
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.types) enum bool int;

  cfg = config.biapy.boot.zswap;

  # the lz4 algorithm requires setting boot.initrd.systemd.enable to true
  initrdSystemdEnabled = elem cfg.compressor [
    "lz4"
    "lz4hc"
  ];
in
{
  options = {
    biapy.boot.zswap = {
      enable = mkEnableOption "Zswap";

      accept_threshold_percent = mkOption {
        type = int;
        default = 90;
        description = ''
          the percentage threshold at which  zswap  starts
          accepting pages again after it became full. Default to  90%  in Ubuntu.
        '';
      };

      exclusive_loads = mkOption {
        type = bool;
        default = false;
        description = ''
          invalidate zswap entries when loading pages ( 0  or  1 ).
        '';
      };

      compressor = mkOption {
        type = enum [
          "842"
          "deflate"
          "lz4"
          "lz4hc"
          "lzo"
          "zstd"
        ];
        default = "zstd";
        description = ''
          set the compression algorithm.
        '';
      };

      max_pool_percent = mkOption {
        type = int;
        default = 50;
        description = ''
          the upper percentage of physical memory that zswap can use.
        '';
      };

      shrinker_enabled = mkOption {
        type = bool;
        default = true;
        description = ''
          whether to shrink the pool proactively on high memory pressure
        '';
      };

      zpool = mkOption {
        type = enum [
          "zbud"
          "z3fold"
          "zsmalloc"
        ];
        default = "zsmalloc";
        description = ''
          control the management of the compressed memory pool,
          possible values are:

          - `zbud` : 2:1 or less compression ratio,
          - `z3fold` : 3:1 or less,
          - `zsmalloc` : more complex method available since kernel 6.3.
        '';
      };
    };
  };

  config = mkIf cfg.enable (mergeAttrsList [
    {
      boot.kernelParams = [
        "zswap.enabled=1"
        "zswap.accept_threshold_percent=${cfg.accept_threshold_percent}"
        "zswap.exclusive_loads=${if cfg.exclusive_loads then 1 else 0}"
        "zswap.compressor=${cfg.compressor}"
        "zswap.max_pool_percent=${cfg.max_pool_percent}"
        "zswap.shrinker_enabled=${if cfg.shrinker_enabled then 1 else 0}"
        "zswap.zpool=${cfg.zpool}"
      ];
    }
    (mkIf initrdSystemdEnabled { boot.initrd.systemd.enable = mkDefault true; })
  ]);
}
