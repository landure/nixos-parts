/**
  # biapy.dev.nix tests

  ## 🙇 Acknowledgements

  - [NixOS VM tests @ Official NixOS Wiki](https://wiki.nixos.org/wiki/NixOS_VM_tests).
  - [Testing Modules @ Nix-Book](https://ekala-project.github.io/nix-book/ch09-08-testing-modules.html).
*/
{
  inputs,
  ...
}:
{
  perSystem =
    { pkgs, ... }:
    {
      checks."biapy.dev.nix" = pkgs.testers.runNixOSTest {
        name = "biapy.dev.nix";

        nodes.machine = _: {
          imports = [
            inputs.home-manager.nixosModules.home-manager

            {
              users.users.testbed = {
                isNormalUser = true;
              };

              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = {
                  inherit inputs;
                };
                users.testbed = {
                  home.stateVersion = "26.05";
                };
              };
            }
            {
              home-manager.users.testbed = {
                imports = [
                  ../../../../home/_biapy/dev/nix.nix
                  ../../../../home/_biapy/programs/nil.nix
                  ../../../../home/_biapy/programs/nixfmt-rs.nix
                ];
                biapy.dev.nix.enable = true;
              };
            }
          ];
        };

        testScript = ''
          machine.succeed("su -- testbed -c 'which nix-inspect'")
          machine.succeed("su -- testbed -c 'which nom'")
          machine.succeed("su -- testbed -c 'which nixd'")
          machine.succeed("su -- testbed -c 'which nixf'")
          machine.succeed("su -- testbed -c 'which nixf-diagnose'")
          machine.succeed("su -- testbed -c 'which nixos-rebuild-ng'")
          machine.succeed("su -- testbed -c 'which nurl'")
          machine.succeed("su -- testbed -c 'which statix'")
        '';
      };
    };
}
