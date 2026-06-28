/**
  # Boot configuration

  Configure Grub, Plymouth, and hibernation.

  GNU GRUB is a Multiboot boot loader.
  It was derived from GRUB, the GRand Unified Bootloader,
  which was originally designed and implemented by Erich Stefan Boleyn.

  Memtest86+ is a stand-alone memory tester for x86 and x86-64 architecture
  computers.

  ## 🛠️ Tech Stack

  ### Bootloaders

  - [Grub homepage](https://www.gnu.org/software/grub/).
  - [Limine bootloader @ Codeberg](https://codeberg.org/Limine/Limine).
  - [The rEFInd Boot Manager homepage](https://www.rodsbooks.com/refind/)
    ([rEFInd Boot Manager @ SourceForge](https://sourceforge.net/projects/refind/)).
  - [systemd-boot UEFI Boot Manager homepage](https://www.freedesktop.org/wiki/Software/systemd/systemd-boot/).

  ### Splash screen

  - [Plymouth @ freedesktop.org](https://www.freedesktop.org/wiki/Software/Plymouth/).

  ### Utilities

  - [Memtest86+ homepage](https://memtest.org/)
     ([Memtest86+ @ GitHub](https://github.com/memtest86plus/memtest86plus/)).

  ## 📝 Documentation

  ### ❄️ NixOS

  - [boot.loader.grub @ NixOS reference](https://search.nixos.org/options?query=boot.loader.grub.).
  - [boot.loader.grub.memtest86 @ NixOS reference](https://search.nixos.org/options?query=boot.loader.grub.memtest86.).
  - [boot.loader.limine @ NixOS reference](https://search.nixos.org/options?query=boot.loader.limine.).
  - [boot.loader.refind @ NixOS reference](https://search.nixos.org/options?query=boot.loader.refind.).
  - [boot.loader.systemd-boot @ NixOS reference](https://search.nixos.org/options?query=boot.loader.systemd-boot.).
  - [boot.plymouth @ NixOS reference](https://search.nixos.org/options?query=boot.plymouth.).

  ### 🎨 Stylix

  - [GRUB @ Stylix](https://nix-community.github.io/stylix/options/modules/grub.html).
  - [Limine @ Stylix](https://nix-community.github.io/stylix/options/modules/limine.html).
  - [Plymouth @ Stylix](https://nix-community.github.io/stylix/options/modules/plymouth.html).

  ## 🙇 Acknowledgements

  - [Plymouth @ Official NixOS Wiki](https://wiki.nixos.org/wiki/Plymouth).
  - [Plymouth @ Arch Linux Wiki](https://wiki.archlinux.org/title/Plymouth).
*/
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.modules) mkDefault mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.biapy.boot.loader;
in
{
  options = {
    biapy.boot.loader = {
      enable = mkEnableOption "Nice Boot";
    };
  };

  config = mkIf cfg.enable {
    # Broken by ImageMagick 7
    # see https://github.com/nix-community/stylix/issues/2255
    # stylix.targets.grub.useWallpaper = mkDefault true;

    boot = {
      loader = {
        timeout = 3;

        grub = {
          enable = mkDefault true;
          # no need to set devices, disko will add all devices that have a EF02 partition to the list already
          # devices = [ ];
          efiSupport = mkDefault true;
          efiInstallAsRemovable = mkDefault true;

          memtest86 = {
            enable = mkDefault true;
            params = [
              # @see https://github.com/memtest86plus/memtest86plus/?tab=readme-ov-file#boot-options
              "dark" # change the default background colour from blue to black
              "screen.mode=1024x768" # (EFI framebuffer only) the preferred screen resolution
            ];
          };
        };
      };

      # Enable hibernation
      initrd.systemd.enable = mkDefault true;

      plymouth = {
        enable = mkDefault true;
        theme = mkDefault "nixos-bgrt";
        themePackages = mkDefault [ pkgs.nixos-bgrt-plymouth ];
      };

      kernelParams = [ "quiet" ];
    };
  };
}
