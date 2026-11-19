/**
  # biapy.skills.guard-skills tests

  - [Testing Modules @ Nix-Book](https://ekala-project.github.io/nix-book/ch09-08-testing-modules.html).
*/
{ inputs, ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      checks."biapy.skills.guard-skills" = pkgs.testers.runNixOSTest {
        name = "biapy.skills.guard-skills";

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
                  ../../../../home/_biapy/skills/guard-skills.nix
                ];
                biapy = {
                  ai.skills.enable = true;
                  skills.guard-skills.enable = true;
                };
              };
            }
          ];
        };

        testScript = ''
          machine.wait_for_unit("default.target")

          # The default guards are installed in ~/.agents/skills
          machine.succeed("su -- testbed -c 'test -e ~/.agents/skills/clean-code-guard/SKILL.md'")
          machine.succeed("su -- testbed -c 'test -e ~/.agents/skills/docs-guard/SKILL.md'")
          machine.succeed("su -- testbed -c 'test -e ~/.agents/skills/test-guard/SKILL.md'")

          # The non-default guards are not installed
          machine.fail("su -- testbed -c 'test -e ~/.agents/skills/wp-guard/SKILL.md'")
          machine.fail("su -- testbed -c 'test -e ~/.agents/skills/woo-guard/SKILL.md'")

          # Skill assets are installed alongside SKILL.md
          machine.succeed(
              "su -- testbed -c 'test -e ~/.agents/skills/clean-code-guard/references/solid.md'"
          )
        '';
      };
    };
}
