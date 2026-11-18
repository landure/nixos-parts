/**
  # biapy.ai.skills tests

  - [Testing Modules @ Nix-Book](https://ekala-project.github.io/nix-book/ch09-08-testing-modules.html).
  - [Integration testing with NixOS virtual machines @ nix.dev](https://nix.dev/tutorials/nixos/integration-testing-using-virtual-machines.html).
*/
{ inputs, ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      checks."biapy.ai.skills" = pkgs.testers.runNixOSTest {
        name = "biapy.ai.skills";

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
                  ];
                  biapy.ai.skills = {
                    enable = true;
                    skills = {
                      inline = ''
                        ---
                        name: inline
                        ---

                        Inline skill body.
                      '';
                      dir = pkgs.writeTextDir "SKILL.md" ''
                        ---
                        name: dir
                        ---

                        Directory skill body.
                      '';
                    };
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
                    codex.enable = true;
                    codex.package = null;
                  };
                };
              }
            ];
          };

        testScript = ''
          machine.wait_for_unit("default.target")

          # Inline text skills land in ~/.agents/skills/<name>/SKILL.md
          machine.succeed("su -- testbed -c 'test -e ~/.agents/skills/inline/SKILL.md'")
          machine.succeed(
              "su -- testbed -c 'grep -q \"Inline skill body\" ~/.agents/skills/inline/SKILL.md'"
          )

          # Directory skills are copied recursively as ~/.agents/skills/<name>/
          machine.succeed("su -- testbed -c 'test -e ~/.agents/skills/dir/SKILL.md'")
          machine.succeed(
              "su -- testbed -c 'grep -q \"Directory skill body\" ~/.agents/skills/dir/SKILL.md'"
          )

          # Skills are propagated to the supported agents' skill folders
          machine.succeed("su -- testbed -c 'test -e ~/.config/opencode/skills/inline/SKILL.md'")
          machine.succeed("su -- testbed -c 'test -e ~/.config/opencode/skills/dir/SKILL.md'")
          machine.succeed("su -- testbed -c 'test -e ~/.claude/skills/inline/SKILL.md'")
          machine.succeed("su -- testbed -c 'test -e ~/.claude/skills/dir/SKILL.md'")
          machine.succeed("su -- testbed -c 'test -e ~/.codex/skills/inline/SKILL.md'")
          machine.succeed("su -- testbed -c 'test -e ~/.codex/skills/dir/SKILL.md'")
        '';
      };
    };
}
