/**
  # biapy.programs.neovide tests

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
      checks."biapy.programs.neovide" = pkgs.testers.runNixOSTest {
        name = "biapy.programs.neovide";

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
                  ../../../../home/_biapy/programs/neovide.nix
                  ../../../../home/_biapy/programs/neovim.nix
                  {
                    options.biapy.console.text-editors.default = lib.options.mkOption {
                      type = lib.types.nullOr lib.types.str;
                      default = "neovide";
                    };
                  }
                ];
                biapy.programs.neovide.enable = true;
              };
            }
          ];
        };

        testScript = ''
          machine.succeed("su -- testbed -c 'which nvim'")
        '';
      };
    };
}
