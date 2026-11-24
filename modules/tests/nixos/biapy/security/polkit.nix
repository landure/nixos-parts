/**
  # biapy.security.polkit tests

  ## 🙇 Acknowledgements

  - [NixOS VM tests @ Official NixOS Wiki](https://wiki.nixos.org/wiki/NixOS_VM_tests).
  - [Integration testing with NixOS virtual machines @ nix.dev](https://nix.dev/tutorials/nixos/integration-testing-using-virtual-machines.html).
*/
_: {
  perSystem =
    { pkgs, ... }:
    {
      checks."biapy.security.polkit" = pkgs.testers.runNixOSTest {
        name = "biapy.security.polkit";

        nodes.machine = _: {
          imports = [
            ../../../../nixos/_biapy/security/polkit.nix
          ];

          biapy.security.polkit.enable = true;
        };

        testScript = ''
          machine.wait_for_unit("default.target")

          # polkit is enabled and running
          machine.wait_for_unit("polkit.service")

          # the extra rule granting reboot/power-off to the users group is written
          machine.succeed("grep -q 'org.freedesktop.login1.reboot' /etc/polkit-1/rules.d/10-nixos.rules")
          machine.succeed("grep -q 'org.freedesktop.login1.power-off' /etc/polkit-1/rules.d/10-nixos.rules")
          machine.succeed("grep -q 'isInGroup(\"users\")' /etc/polkit-1/rules.d/10-nixos.rules")
        '';
      };
    };
}
