/**
  # biapy.skills.architecture-decision-record tests

  - [Testing Modules @ Nix-Book](https://ekala-project.github.io/nix-book/ch09-08-testing-modules.html).
*/
{ inputs, ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      checks."biapy.skills.architecture-decision-record" = pkgs.testers.runNixOSTest {
        name = "biapy.skills.architecture-decision-record";

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
                  ../../../../home/_biapy/skills/architecture-decision-record.nix
                ];
                biapy = {
                  ai.skills.enable = true;
                  skills.architecture-decision-record.enable = true;
                };
              };
            }
          ];
        };

        testScript = ''
          machine.wait_for_unit("default.target")

          # The default skill is installed in ~/.agents/skills
          machine.succeed(
              "su -- testbed -c 'test -e ~/.agents/skills/architecture-decision-record-skill/SKILL.md'"
          )

          # The maintainer skill is not installed by default
          machine.fail(
              "su -- testbed -c 'test -e ~/.agents/skills/architecture-decision-record-maintainer-skill/SKILL.md'"
          )

          # Skill references are installed alongside SKILL.md
          machine.succeed(
              "su -- testbed -c 'test -e ~/.agents/skills/architecture-decision-record-skill/reference/templates.md'"
          )
          machine.succeed(
              "su -- testbed -c 'test -e ~/.agents/skills/architecture-decision-record-skill/reference/writing-guide.md'"
          )
        '';
      };
    };
}
