/**
  # biapy.console.media tests

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
      checks."biapy.console.media" = pkgs.testers.runNixOSTest {
        name = "biapy.console.media";

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
                  ../../../../home/_biapy/console/media.nix
                  ../../../../home/_biapy/programs/cava.nix
                  ../../../../home/_biapy/programs/mpv.nix
                  ../../../../home/_biapy/programs/radio-cli.nix
                  ../../../../home/_biapy/programs/yt-dlp.nix
                  ../../../../home/_biapy/user/country.nix
                  inputs.stylix.homeModules.stylix
                ];
                stylix = {
                  enable = true;
                  base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-latte.yaml";
                };
                biapy.console.media.enable = true;
              };
            }
          ];
        };

        testScript = ''
          machine.succeed("su -- testbed -c 'which castero'")
          machine.succeed("su -- testbed -c 'which cliamp'")
          machine.succeed("su -- testbed -c 'which gophertube'")
          machine.succeed("su -- testbed -c 'which kew'")
          machine.succeed("su -- testbed -c 'which mufetch'")
          machine.succeed("su -- testbed -c 'which pulsemixer'")
          machine.succeed("su -- testbed -c 'which pyradio'")
          machine.succeed("su -- testbed -c 'which spotatui'")
          machine.succeed("su -- testbed -c 'which wiremix'")
        '';
      };
    };
}
