/**
  # biapy.programs.gum tests

  - [Testing Modules @ Nix-Book](https://ekala-project.github.io/nix-book/ch09-08-testing-modules.html).
  - [Integration testing with NixOS virtual machines @ nix.dev](https://nix.dev/tutorials/nixos/integration-testing-using-virtual-machines.html).
*/
{ inputs, ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      checks."biapy.programs.gum" = pkgs.testers.nixosTest {
        name = "biapy.programs.gum";

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
                  ../../../../home/_biapy/ai/skills.nix
                  ../../../../home/_biapy/programs/gum.nix
                ];
                biapy.programs.gum.enable = true;
              };
            }
          ];
        };

        testScript = ''
          machine.wait_for_unit("default.target")
          machine.succeed("su -- testbed -c 'which gum'")
          machine.succeed("test -e /home/testbed/.agents/skills/gum-cli/SKILL.md")
        '';
      };
    };
}
