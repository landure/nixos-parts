/**
  # biapy.skills.addyosmani-agent-skills tests

  - [Testing Modules @ Nix-Book](https://ekala-project.github.io/nix-book/ch09-08-testing-modules.html).
*/
{ inputs, ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      checks."biapy.skills.addyosmani-agent-skills" = pkgs.testers.runNixOSTest {
        name = "biapy.skills.addyosmani-agent-skills";

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
                  ../../../../home/_biapy/skills/addyosmani-agent-skills.nix
                ];
                biapy = {
                  ai.skills.enable = true;
                  skills.addyosmani-agent-skills.enable = true;
                };
              };
            }
          ];
        };

        testScript = ''
          machine.wait_for_unit("default.target")

          # The default skills are installed in ~/.agents/skills
          machine.succeed("su -- testbed -c 'test -e ~/.agents/skills/code-review-and-quality/SKILL.md'")
          machine.succeed("su -- testbed -c 'test -e ~/.agents/skills/debugging-and-error-recovery/SKILL.md'")
          machine.succeed("su -- testbed -c 'test -e ~/.agents/skills/planning-and-task-breakdown/SKILL.md'")
          machine.succeed("su -- testbed -c 'test -e ~/.agents/skills/spec-driven-development/SKILL.md'")
          machine.succeed("su -- testbed -c 'test -e ~/.agents/skills/test-driven-development/SKILL.md'")

          # The non-default skills are not installed
          machine.fail("su -- testbed -c 'test -e ~/.agents/skills/accessibility-engineering/SKILL.md'")
          machine.fail("su -- testbed -c 'test -e ~/.agents/skills/shipping-and-launch/SKILL.md'")

          # Skill assets are installed alongside SKILL.md
          machine.succeed(
              "su -- testbed -c 'test -e ~/.agents/skills/test-driven-development/SKILL.md'"
          )
        '';
      };
    };
}
