/**
  # biapy.programs.micro tests

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
      checks."biapy.programs.micro" = pkgs.testers.runNixOSTest {
        name = "biapy.programs.micro";

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
                  ../../../../home/_biapy/programs/micro.nix
                  ../../../../home/_biapy/console/text-editors.nix
                  ../../../../home/_biapy/desktop/clipboard.nix
                  ../../../../home/_biapy/programs/emacs.nix
                  ../../../../home/_biapy/programs/fresh-editor.nix
                  ../../../../home/_biapy/programs/helix.nix
                  ../../../../home/_biapy/programs/kakoune.nix
                  ../../../../home/_biapy/programs/msedit.nix
                  ../../../../home/_biapy/programs/ne.nix
                  ../../../../home/_biapy/programs/neovim.nix
                  ../../../../home/_biapy/programs/vim.nix
                ];
                biapy.programs.micro.enable = true;
              };
            }
          ];
        };

        testScript = ''
          machine.succeed("su -- testbed -c 'which micro'")
        '';
      };
    };
}
