/**
  # biapy.skills.mattpocock-skills tests

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
      checks."biapy.skills.mattpocock-skills" = pkgs.testers.runNixOSTest {
        name = "biapy.skills.mattpocock-skills";

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
                  ../../../../home/_biapy/skills/mattpocock-skills.nix
                  ../../../../home/_biapy/ai/skills.nix
                  ../../../../home/_biapy/programs/bat.nix
                  ../../../../home/_biapy/programs/fzf.nix
                  ../../../../home/_biapy/programs/gh.nix
                ];
                biapy.skills.mattpocock-skills.enable = true;
              };
            }
          ];
        };

        testScript = ''
          machine.succeed("su -- testbed -c 'which gh'")
        '';
      };
    };
}
