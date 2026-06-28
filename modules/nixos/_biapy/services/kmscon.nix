/**
  # kmscon

  kmscon is a system console for linux.
  It does not depend on any graphics-server on your system (like X.org),
  but instead provides a raw console layer that can be used independently

  ## 🛠️ Tech Stack

  - [General Purpose Mouse homepage](https://www.nico.schottelius.org/software/gpm/)
    ([general purpose mouse (gpm) @ GitHub](https://github.com/telmich/gpm)).
  - [kmscon homepage](https://www.freedesktop.org/wiki/Software/kmscon/).
  - [kmscon @ GitHub](https://github.com/kmscon/kmscon).
  - [Aetf's kmscon @ GitHub](https://github.com/Aetf/kmscon).
  - [NixOS Facter Modules homepage](https://nix-community.github.io/nixos-facter-modules/latest/)
    ([NixOS Facter Modules @ GitHub](https://github.com/nix-community/nixos-facter-modules)).
  - [Physlock @ GitHub](https://github.com/xJ7v0/physlock).

  ## 📝 Documentation

  ### ❄️ NixOS

  - [services.gpm @ NixOS reference](https://search.nixos.org/options?&query=services.gpm.)
  - [services.kmscon @ NixOS reference](https://search.nixos.org/options?&query=services.kmscon.)
  - [services.physlock @ NixOS reference](https://search.nixos.org/options?query=services.physlock.).

  ## 🙇 Acknowledgements

  - [General purpose mouse @ ArchLinux Wiki](https://wiki.archlinux.org/title/General_purpose_mouse).
  - [KMSCON @ ArchLinux Wiki](https://wiki.archlinux.org/title/KMSCON).
*/
{
  config,
  flake,
  lib,
  pkgs,
  ...
}:
let
  inherit (flake.inputs) nixpkgs-unstable;
  inherit (lib.modules) mkDefault mkIf;
  inherit (lib.options) mkEnableOption;
  inherit (lib.strings) concatStringsSep;

  # Use pkgs-unstable to get kmscon > 9.2 with mouse support.
  pkgs-unstable = import nixpkgs-unstable { inherit (pkgs.stdenv.hostPlatform) system; };

  cfg = config.biapy.services.kmscon;

  # Set custom compiler flags for kmscon,
  # to ensure compatibility between Zellij shortcuts and backspace key.
  # zellijCompatibleKmscon = pkgs-unstable.kmscon.overrideAttrs {
  #   mesonFlags = [ "-Dbackspace_sends_delete=true" ];
  # };
in
{
  options = {
    biapy.services.kmscon.enable = mkEnableOption "kmscon";
  };

  config = mkIf cfg.enable {

    services = {
      gpm.enable = mkDefault false;

      # physlock does detect kmscon logged-in session
      # physlock.enable = mkDefault true;

      kmscon = {
        # Use kmscon as the virtual console instead of gettys
        enable = mkDefault true;

        package = mkDefault pkgs-unstable.kmscon;

        # Configure keymap from xserver keyboard settings (not needed)
        useXkbConfig = mkDefault true;

        # Extra flags to pass to kmscon.
        extraOptions = mkDefault (
          concatStringsSep " " [
            "--mouse"
            # "--term xterm-256color"
          ]
        );

        # Extra contents of the kmscon.conf file.
        # extraConfig = ''
        # font-size=14
        # '';

        # Fonts used by kmscon, in order of priority.
        # Stylix centralize this.
        # fonts = [
        #   # {
        #   #  name = "Fira Code Nerd Font";
        #   #  package = pkgs.nerd-fonts.fira-code;
        #   # }
        #   {
        #     name = "JetBrains Nerd Font Mono";
        #     package = pkgs.nerd-fonts.jetbrains-mono;
        #   }
        #   {
        #     name = "Noto Sans Nerd Font Mono";
        #     package = pkgs.nerd-fonts.noto;
        #   }
        #   {
        #     name = "DejaVu Sans Nerd Font Mono";
        #     package = pkgs.nerd-fonts.dejavu-sans-mono;
        #   }
        # ];

        # Whether to use 3D hardware acceleration to render the console.
        hwRender = mkDefault config.hardware.facter.detected.graphics.enable;
      };
    };

    systemd.services."kmsconvt@".path = [ pkgs.gawk ];
  };
}
