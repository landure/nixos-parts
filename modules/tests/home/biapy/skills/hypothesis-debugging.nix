/**
  # biapy.skills.hypothesis-debugging tests

  - [Testing Modules @ Nix-Book](https://ekala-project.github.io/nix-book/ch09-08-testing-modules.html).
  - [Integration testing with NixOS virtual machines @ nix.dev](https://nix.dev/tutorials/nixos/integration-testing-using-virtual-machines.html).
*/
{ inputs, ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      checks."biapy.skills.hypothesis-debugging" = pkgs.testers.runNixOSTest {
        name = "biapy.skills.hypothesis-debugging";

        nodes.machine =
          { pkgs, ... }:
          {
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
                    ../../../../home/_biapy/skills/hypothesis-debugging.nix
                  ];
                  biapy = {
                    ai.skills.enable = true;
                    skills.hypothesis-debugging.enable = true;
                  };

                  # The agents only write their skills folder when enabled.
                  # Stub/empty packages keep the test VM free of the agent binaries.
                  programs = {
                    opencode.enable = true;
                    opencode.package = pkgs.writeShellApplication {
                      name = "opencode";
                      text = "exit 0";
                    };
                    claude-code.enable = true;
                    claude-code.package = null;
                  };
                };
              }
            ];
          };

        testScript = ''
          machine.wait_for_unit("default.target")

          # The skill is installed in ~/.agents/skills
          machine.succeed(
              "su -- testbed -c 'test -e ~/.agents/skills/hypothesis-debugging/SKILL.md'"
          )

          # The skill is propagated to the supported agents' skill folders
          machine.succeed(
              "su -- testbed -c 'test -e ~/.config/opencode/skills/hypothesis-debugging/SKILL.md'"
          )
          machine.succeed(
              "su -- testbed -c 'test -e ~/.claude/skills/hypothesis-debugging/SKILL.md'"
          )

          # The skill assets are installed alongside SKILL.md
          machine.succeed(
              "su -- testbed -c 'test -e ~/.agents/skills/hypothesis-debugging/agents/openai.yaml'"
          )
        '';
      };
    };
}
