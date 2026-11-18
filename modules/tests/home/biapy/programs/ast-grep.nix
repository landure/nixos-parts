/**
  # biapy.programs.ast-grep tests

  - [Testing Modules @ Nix-Book](https://ekala-project.github.io/nix-book/ch09-08-testing-modules.html).
  - [Integration testing with NixOS virtual machines @ nix.dev](https://nix.dev/tutorials/nixos/integration-testing-using-virtual-machines.html).
*/
{ inputs, ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      checks."biapy.programs.ast-grep" = pkgs.testers.runNixOSTest {
        name = "biapy.programs.ast-grep";

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
                    ../../../../home/_biapy/programs/ast-grep.nix
                  ];
                  biapy = {
                    ai.skills.enable = true;
                    programs.ast-grep.enable = true;
                  };

                  # The Claude Code plugin is only installed when Claude Code is enabled.
                  programs.claude-code = {
                    enable = true;
                    package = pkgs.writeShellApplication {
                      name = "claude";
                      text = "exit 0";
                    };
                  };
                };
              }
            ];
          };

        testScript = ''
          machine.wait_for_unit("default.target")

          # The ast-grep binary is installed
          machine.succeed("su -- testbed -c 'which ast-grep'")
          machine.succeed("su -- testbed -c 'ast-grep --version'")

          # The agent skills are installed
          machine.succeed("su -- testbed -c 'test -e ~/.agents/skills/ast-grep/SKILL.md'")
          machine.succeed("su -- testbed -c 'test -e ~/.agents/skills/ast-grep-outline/SKILL.md'")

          # The Claude Code plugin is passed to the `claude` wrapper via --plugin-dir
          machine.succeed(
              "su -- testbed -c 'grep -q -- \"--plugin-dir\" \"$(readlink -f $(which claude))\"'"
          )
          machine.succeed(
              "su -- testbed -c 'grep -q -- \"ast-grep\" \"$(readlink -f $(which claude))\"'"
          )
        '';
      };
    };
}
