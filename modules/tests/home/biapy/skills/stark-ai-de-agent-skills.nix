/**
  # biapy.skills.stark-ai-de-agent-skills tests

  - [Testing Modules @ Nix-Book](https://ekala-project.github.io/nix-book/ch09-08-testing-modules.html).
  - [Integration testing with NixOS virtual machines @ nix.dev](https://nix.dev/tutorials/nixos/integration-testing-using-virtual-machines.html).
*/
{ inputs, ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      checks."biapy.skills.stark-ai-de-agent-skills" = pkgs.testers.runNixOSTest {
        name = "biapy.skills.stark-ai-de-agent-skills";

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
                  ../../../../home/_biapy/skills/stark-ai-de-agent-skills.nix
                ];
                biapy = {
                  ai.skills.enable = true;
                  skills.stark-ai-de-agent-skills = {
                    enable = true;
                    skills = [
                      "architecture-compass"
                      "visual-reports"
                    ];
                  };
                };
              };
            }
          ];
        };

        testScript = ''
          machine.wait_for_unit("default.target")

          # The selected skills are installed in ~/.agents/skills
          machine.succeed("su -- testbed -c 'test -e ~/.agents/skills/architecture-compass/SKILL.md'")
          machine.succeed("su -- testbed -c 'test -e ~/.agents/skills/visual-reports/SKILL.md'")

          # Unselected skills are not installed
          machine.fail("su -- testbed -c 'test -e ~/.agents/skills/codex-memory-curator/SKILL.md'")

          # Skill assets are installed alongside SKILL.md
          machine.succeed(
              "su -- testbed -c 'test -e ~/.agents/skills/architecture-compass/references/adr-catalog.md'"
          )
        '';
      };
    };
}
