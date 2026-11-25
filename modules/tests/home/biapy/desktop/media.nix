/**
  # biapy.desktop.media tests

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
      checks."biapy.desktop.media" = pkgs.testers.runNixOSTest {
        name = "biapy.desktop.media";

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
                  inputs.spicetify-nix.homeManagerModules.spicetify
                  ../../../../home/_biapy/desktop/media.nix
                  ../../../../home/_biapy/programs/spicetify.nix
                ];
                biapy.desktop.media.enable = true;
              };
            }
          ];
        };

        testScript = ''
          machine.succeed("su -- testbed -c 'which ghb'")
          machine.succeed("su -- testbed -c 'which HandBrakeCLI'")
          machine.succeed("su -- testbed -c 'which vlc'")
          # spicetify-nix ships a spiced Spotify, not the spicetify CLI.
          machine.succeed("su -- testbed -c 'which spotify'")
        '';
      };
    };
}
