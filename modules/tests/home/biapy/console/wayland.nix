/**
  # biapy.console.wayland tests

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
      checks."biapy.console.wayland" = pkgs.testers.runNixOSTest {
        name = "biapy.console.wayland";

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
                  ../../../../home/_biapy/console/wayland.nix
                  ../../../../home/_biapy/desktop/clipboard.nix
                  ../../../../home/_biapy/programs/grim.nix
                  ../../../../home/_biapy/programs/tray-tui.nix
                  ../../../../home/_biapy/services/flameshot.nix
                  ../../../../home/_biapy/xdg/portal.nix
                ];
                biapy.console.wayland.enable = true;
              };
            }
          ];
        };

        testScript = ''
          machine.succeed("su -- testbed -c 'which wl-screenrec'")
        '';
      };
    };
}
