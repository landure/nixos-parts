/**
  # biapy.desktop.note-taking tests

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
      checks."biapy.desktop.note-taking" = pkgs.testers.runNixOSTest {
        name = "biapy.desktop.note-taking";

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
                  inputs.sops-nix.homeManagerModules.sops
                  ../../../../home/_biapy/desktop/note-taking.nix
                  ../../../../home/_biapy/programs/joplin-desktop.nix
                  ../../../../home/_biapy/user/identity.nix
                ];
                biapy.desktop.note-taking.enable = true;
              };
            }
          ];
        };

        testScript = ''
          machine.succeed("su -- testbed -c 'which zettlr'")
        '';
      };
    };
}
