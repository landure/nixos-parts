/**
  # biapy.programs.ne tests

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
      checks."biapy.programs.ne" = pkgs.testers.runNixOSTest {
        name = "biapy.programs.ne";

        nodes.machine = { lib, ... }: {
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
                  {
                    options.biapy.console.text-editors.default = lib.options.mkOption {
                      type = lib.types.nullOr lib.types.str;
                      default = "ne";
                    };
                  }
                  ../../../../home/_biapy/programs/ne.nix
                ];
                biapy.programs.ne.enable = true;
              };
            }
          ];
        };

        testScript = ''
          machine.succeed("su -- testbed -c 'which ne'")
        '';
      };
    };
}
