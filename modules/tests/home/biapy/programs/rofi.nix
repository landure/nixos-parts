/**
  # biapy.programs.rofi tests

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
      checks."biapy.programs.rofi" = pkgs.testers.runNixOSTest {
        name = "biapy.programs.rofi";

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
                  ../../../../home/_biapy/programs/rofi.nix
                  ../../../../home/_biapy/desktop/clipboard.nix
                  ../../../../home/_biapy/desktop/terminalEmulators.nix
                  ../../../../home/_biapy/programs/ghostty.nix
                  ../../../../home/_biapy/programs/foot.nix
                  inputs.stylix.homeModules.stylix
                ];
                stylix = {
                  enable = true;
                  base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-latte.yaml";
                };
                biapy.programs.rofi.enable = true;
              };
            }
          ];
        };

        testScript = ''
          machine.succeed("su -- testbed -c 'which dotool'")
        '';
      };
    };
}
