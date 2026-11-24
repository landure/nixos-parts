/**
  # biapy.desktop.design tests

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
      checks."biapy.desktop.design" = pkgs.testers.runNixOSTest {
        name = "biapy.desktop.design";

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
                  ../../../../home/_biapy/desktop/design.nix
                  ../../../../home/_biapy/desktop/graphics.nix
                  ../../../../home/_biapy/services/flameshot.nix
                ];
                biapy.desktop.design.enable = true;
              };
            }
          ];
        };

        testScript = ''
          machine.succeed("su -- testbed -c 'which gimp'")
          machine.succeed("su -- testbed -c 'which inkscape'")
          machine.succeed("su -- testbed -c 'which krita'")
        '';
      };
    };
}
