/**
  # D-Bus

  D-Bus is a message bus system,
  a simple way for applications to talk to one another.
  In addition to inter-process communication,
  D-Bus helps coordinate process lifecycle;
  it makes it simple and reliable to code a "single instance" application
  or daemon, and to launch applications and daemons on demand
  when their services are needed.

  ### D-Bus Broker

  The dbus-broker project is an implementation of a message bus as defined by
  the D-Bus specification.
  Its aim is to provide high performance and reliability,
  while keeping compatibility to the D-Bus reference implementation.
  It is exclusively written for linux systems,
  and makes use of many modern features provided by recent linux kernel releases.

  ## 🛠️ Tech Stack

  - [D-Bus @ freedesktop.org](https://www.freedesktop.org/wiki/Software/dbus/).
  - [D-Bus Broker Wiki](https://github.com/bus1/dbus-broker/wiki)
    ([D-Bus Broker @ GitHub](https://github.com/bus1/dbus-broker)).

  ## 📝 Documentation

  - [services.dbus @ NixOS reference](https://search.nixos.org/options?query=services.dbus).
*/
{ config, lib, ... }:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf mkDefault;

  cfg = config.biapy.services.dbus;
in
{
  options.biapy.services.dbus = {
    enable = mkEnableOption "D-Bus defaults";
  };

  config = mkIf cfg.enable {
    services.dbus = {
      enable = mkDefault true;

      # The implementation to use for D-Bus message bus.
      # Can be either the classic dbus daemon or dbus-broker.
      implementation = mkDefault "broker";

      # AppArmor mode for D-Bus.
      # - enabled enables mediation when it's supported in the kernel,
      # - disabled always disables AppArmor even with kernel support,
      # - and required fails when AppArmor was not found in the kernel.
      apparmor = mkDefault "disabled";
    };
  };
}
