/**
  # biapy.skills.planning-with-files tests

  - [Testing Modules @ Nix-Book](https://ekala-project.github.io/nix-book/ch09-08-testing-modules.html).
*/
{ inputs, ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      checks."biapy.skills.planning-with-files" = pkgs.testers.runNixOSTest {
        name = "biapy.skills.planning-with-files";

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
                    ../../../../home/_biapy/skills/planning-with-files.nix
                  ];
                  biapy = {
                    ai.skills.enable = true;
                    skills.planning-with-files.enable = true;
                  };

                  programs.claude-code = {
                    enable = true;
                    package = pkgs.writeShellApplication {
                      name = "claude";
                      text = "exit 0";
                    };
                  };

                  programs.opencode = {
                    enable = true;
                    package = pkgs.writeShellApplication {
                      name = "opencode";
                      text = "exit 0";
                    };
                  };
                };
              }
            ];
          };

        testScript = ''
          machine.wait_for_unit("default.target")

          # The skill is installed for every agent
          machine.succeed("su -- testbed -c 'test -e ~/.agents/skills/planning-with-files/SKILL.md'")
          machine.succeed("su -- testbed -c 'test -e ~/.claude/skills/planning-with-files/SKILL.md'")

          # The skill assets are installed alongside SKILL.md
          machine.succeed(
              "su -- testbed -c 'test -e ~/.agents/skills/planning-with-files/scripts/inject-plan.sh'"
          )

          # The Claude Code plugin is passed to the `claude` wrapper via --plugin-dir
          machine.succeed(
              "su -- testbed -c 'grep -q -- \"--plugin-dir\" \"$(readlink -f $(which claude))\"'"
          )
          machine.succeed(
              "su -- testbed -c 'grep -q -- \"planning-with-files\" \"$(readlink -f $(which claude))\"'"
          )

          # The OpenCode plugin and commands are configured
          machine.succeed(
              "su -- testbed -c 'grep -q \"planning-with-files.ts\" ~/.config/opencode/opencode.json'"
          )
          machine.succeed("su -- testbed -c 'test -e ~/.config/opencode/commands/pwf.md'")
          machine.succeed("su -- testbed -c 'test -e ~/.config/opencode/commands/pwf-status.md'")
        '';
      };
    };
}
