/**
  # Sound

  Enable PipeWire when sound devices are available.

  ## 🛠️ Tech Stack

  - [PipeWire homepage](https://pipewire.org/)
    ([PipeWire @ FreeDesktop's GitLab](https://gitlab.freedesktop.org/pipewire/pipewire/))
  - [RealtimeKit @ FreeDesktop's GitLab](https://gitlab.freedesktop.org/pipewire/rtkit).
  - [WirePlumber homepage](https://pipewire.pages.freedesktop.org/wireplumber/)
    ([WirePlumber @ FreeDesktop's GitLab](https://gitlab.freedesktop.org/pipewire/wireplumber/)).
  - [wiremix @ GitHub](https://github.com/tsowell/wiremix).

  ## 📝 Documentation

  ### ❄️ NixOS

  - [services.pipewire @ NixOS reference](https://search.nixos.org/options?query=services.pipewire).
  - [security.rtkit @ NixOS reference](https://search.nixos.org/options?query=security.rtkit).

  ## 🙇 Acknowledgements

  - [WirePlumber @ ArchLinux Wiki](https://wiki.archlinux.org/title/WirePlumber).
*/
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf mkDefault;
  inherit (config.hardware.facter) report;
  inherit (lib.lists) length;
  inherit (pkgs) wiremix;

  cfg = config.biapy.hardware.sound;

  sound_available = length (report.hardware.sound or [ ]) > 0;
in
{
  options = {
    biapy.hardware.sound = {
      enable = mkEnableOption "audio (sound) support" // {
        default = sound_available;
      };
    };
  };

  config = mkIf cfg.enable {
    # PulseAudio and PipeWire use rtkit to acquire realtime priority
    security.rtkit.enable = mkDefault true;

    services = {
      # Disable pulseaudio
      pulseaudio.enable = mkDefault false;

      # Enable sound with pipewire
      pipewire = {
        enable = mkDefault true;
        alsa.enable = mkDefault true;
        alsa.support32Bit = mkDefault true;
        pulse.enable = mkDefault true;
        wireplumber.enable = mkDefault true;
        # If you want to use JACK apps, uncomment this
        # jack.enable = true;

        # use the example session manager (no others are packaged yet, so this is enable by default)
        # no need to redefine it in your config for now)
        # media-session.enable = true;
      };
    };

    environment.defaultPackages = [ wiremix ];
  };
}
