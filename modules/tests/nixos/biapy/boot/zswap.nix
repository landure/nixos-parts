/**
  # biapy.boot.zswap tests

  ## 🙇 Acknowledgements

  - [NixOS VM tests @ Official NixOS Wiki](https://wiki.nixos.org/wiki/NixOS_VM_tests).
  - [Integration testing with NixOS virtual machines @ nix.dev](https://nix.dev/tutorials/nixos/integration-testing-using-virtual-machines.html).
*/
_: {
  perSystem =
    { pkgs, ... }:
    {
      checks."biapy.boot.zswap" = pkgs.testers.runNixOSTest {
        name = "biapy.boot.zswap";

        nodes.machine = { config, ... }: {
          imports = [
            ../../../../nixos/_biapy/boot/zswap.nix
          ];

          biapy.boot.zswap = {
            enable = true;
            accept_threshold_percent = 90;
            exclusive_loads = false;
            compressor = "zstd";
            max_pool_percent = 50;
            shrinker_enabled = true;
            zpool = "zsmalloc";
          };

          # the VM kernel command line is not built from boot.kernelParams,
          # so expose the evaluated value for the test to assert on
          environment.etc."zswap-params".text = builtins.concatStringsSep "\n" config.boot.kernelParams;
        };

        testScript = ''
          machine.wait_for_unit("default.target")

          machine.succeed("grep -q 'zswap.enabled=1' /etc/zswap-params")
          machine.succeed("grep -q 'zswap.accept_threshold_percent=90' /etc/zswap-params")
          machine.succeed("grep -q 'zswap.exclusive_loads=0' /etc/zswap-params")
          machine.succeed("grep -q 'zswap.compressor=zstd' /etc/zswap-params")
          machine.succeed("grep -q 'zswap.max_pool_percent=50' /etc/zswap-params")
          machine.succeed("grep -q 'zswap.shrinker_enabled=1' /etc/zswap-params")
          machine.succeed("grep -q 'zswap.zpool=zsmalloc' /etc/zswap-params")
        '';
      };
    };
}
