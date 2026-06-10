/**
  # Bluetooth support

  ## 🛠️ Tech Stack

  - [bluez-tools @ GitHub](https://github.com/khvzak/bluez-tools).
  - [BlueTUI @ GitHub](https://github.com/pythops/bluetui).

  ### Left-out

  - [bluetuith @ GitHub](https://github.com/bluetuith-org/bluetuith).

  ### Blueman

  Blueman is a GTK+ Bluetooth Manager.

  - [Blueman @ GitHub](https://github.com/blueman-project/blueman).

  ## 📝 Documentation

  ### ❄️ NixOS

  - [hardware.bluetooth @ NixOS reference](https://search.nixos.org/options?query=hardware.bluetooth).
  - [services.blueman @ NixOS reference](https://search.nixos.org/options?query=services.blueman).

  ## 🙇 Acknowledgements

  - [Bluetooth @ Official NixOS Wiki](https://wiki.nixos.org/wiki/Bluetooth).
  - [Bluetooth @ NixOS Wiki](https://nixos.wiki/wiki/Bluetooth).
  - [Bluetooth @ ArchLinux Wiki](https://wiki.archlinux.org/title/Bluetooth).
*/
{
  config,
  lib,
  pkgs,

  ...
}:
let
  inherit (lib) getName;
  inherit (lib.lists) any length toList;
  inherit (pkgs) nixos;

  nixosWithModule =
    configuration:
    nixos (
      [
        {
          imports = [ ./bluetooth.nix];
        }
      ]
      ++ (toList configuration)
    );

  containsPackage = name: packages: any (pkg: getName pkg == name) packages;

  inherit (lib.modules) mkDefault mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.biapy.facter.bluetooth;

  bluetooth_hardware = 0 < length (config.hardware.facter.report.hardware.bluetooth or [ ]);

  bluetooth_usb = any (
    {
      driver ? null,
      driver_module ? null,
      ...
    }:
    driver == "btusb" || driver_module == "btusb"
  ) (config.hardware.facter.report.hardware.usb or [ ]);

  bluetooth_detected = bluetooth_hardware || bluetooth_usb;
in
{
  options = {
    hardware.facter.detected.biapy.bluetooth.enable =
      mkEnableOption "Enable the Facter bluetooth module"
      // {
        default = bluetooth_detected;
        defaultText = "hardware dependent";
        readOnly = true;
      };

    biapy.facter.bluetooth.enable = mkEnableOption "Enable the Facter bluetooth module" // {
      default = config.hardware.facter.detected.biapy.bluetooth.enable;
      defaultText = "`config.hardware.facter.detected.biapy.bluetooth.enable`";
    };
  };

  config = mkIf cfg.enable {
    environment.defaultPackages = with pkgs; [
      # gnome-bluetooth
      bluez-tools
      bluetui
      # bluetuith
    ];

    hardware.bluetooth = {
      enable = mkDefault true;
      powerOnBoot = mkDefault false;
      settings = {
        General = {
          # Shows battery charge of connected devices on supported
          # Bluetooth adapters. Defaults to 'false'.
          Experimental = mkDefault true;

          # Enables kernel experimental features, alternatively a list of UUIDs
          # can be given.
          # Possible values: true,false,<UUID List>
          # Possible UUIDS:
          # d4992530-b9ec-469f-ab01-6c481c47da1c (BlueZ Experimental Debug)
          # 671b10b5-42c0-4696-9227-eb28d1b049d6 (BlueZ Experimental Simultaneous Central and Peripheral)
          # 15c0a148-c273-11ea-b3de-0242ac130004 (BlueZ Experimental LL privacy)
          # 330859bc-7506-492d-9370-9a6f0614037f (BlueZ Experimental Bluetooth Quality Report)
          # a6695ace-ee7f-4fb9-881a-5fac66c629af (BlueZ Experimental Offload Codecs)
          # 6fbaf188-05e0-496a-9885-d6ddfdb4e03e (BlueZ Experimental ISO socket)
          # Defaults to false.

          # BAP (Basic Audio Profile) requires ISO socket support.
          KernelExperimental = "6fbaf188-05e0-496a-9885-d6ddfdb4e03e";

          # When enabled other devices can connect faster to us, however
          # the tradeoff is increased power consumption.
          # Defaults to 'false'.
          FastConnectable = mkDefault false;
        };
        Policy = {
          # Enable all controllers when they are found. This includes
          # adapters present on start as well as adapters that are plugged
          # in later on. Defaults to 'true'.
          AutoEnable = mkDefault true;
        };
      };
    };

    # Alternative bluetooth manager
    # services.blueman.enable = mkDefault true;
  };

  tests = {
    "biapy.\"facter.bluetooth\"" = {
      "test: declare module" = {
        expr = config.flake.biapy ? "facter.bluetooth";
        expected = true;
      };
    };
  };

  nix-unit.tests."biapy.facter.bluetooth" = {
    without-bluetooth-hardware =
      let
        sut = nixosWithModule {
          hardware.facter.report.hardware = {
            bluetooth = [ ];
            usb = [ ];
          };
        };
      in
      {
        "test: no bluetooth detected" = {
          expr = sut.config.hardware.facter.detected.biapy.bluetooth.enable;
          expected = false;
        };

        "test: biapy facter module disabled" = {
          expr = sut.config.biapy.facter.bluetooth.enable;
          expected = false;
        };
      };

    with-adapter =
      let
        sut = nixosWithModule {
          hardware.facter.report.hardware = {
            bluetooth = [ { name = "adapter"; } ];
            usb = [ ];
          };
        };
      in
      {
        "test: bluetooth detected" = {
          expr = sut.config.hardware.facter.detected.biapy.bluetooth.enable;
          expected = true;
        };
      };

    with-btusb-driver =
      let
        sut = nixosWithModule {
          hardware.facter.report.hardware = {
            bluetooth = [ ];
            usb = [ { driver = "btusb"; } ];
          };
        };
      in
      {
        "test: bluetooth detected" = {
          expr = sut.config.hardware.facter.detected.biapy.bluetooth.enable;
          expected = true;
        };
      };

    with-btusb-driver-module =
      let
        sut = nixosWithModule {
          hardware.facter.report.hardware = {
            bluetooth = [ ];
            usb = [ { driver_module = "btusb"; } ];
          };
        };
      in
      {
        "test: bluetooth detected" = {
          expr = sut.config.hardware.facter.detected.biapy.bluetooth.enable;
          expected = true;
        };
      };

    with-hardware-detected =
      let
        sut = nixosWithModule {
          hardware.facter.report.hardware = {
            bluetooth = [ { name = "adapter"; } ];
            usb = [ ];
          };
        };
      in
      {
        "test: biapy facter module enabled" = {
          expr = sut.config.biapy.facter.bluetooth.enable;
          expected = true;
        };
      };

    with-hardware-detected-but-module-disabled =
      let
        sut = nixosWithModule {
          hardware.facter.report.hardware = {
            usb = [ { driver = "btusb"; } ];
          };

          biapy.facter.bluetooth.enable = false;
        };
      in
      {
        "test: bluetooth detected" = {
          expr = sut.config.hardware.facter.detected.biapy.bluetooth.enable;
          expected = true;
        };

        "test: module off" = {
          expr = sut.config.biapy.facter.bluetooth.enable;
          expected = false;
        };

        "test: bluetooth support off" = {
          expr = sut.config.hardware.bluetooth.enable;
          expected = false;
        };

        "test: defaultPackage doesn't contains bluetui" = {
          expr = containsPackage "bluetui" sut.config.environment.defaultPackages;
          expected = false;
        };

        "test: defaultPackage doesn't contains bluez-tools" = {
          expr = containsPackage "bluez-tools" sut.config.environment.defaultPackages;
          expected = false;
        };
      };

    with-module-enabled =
      let
        sut = nixosWithModule {
          biapy.facter.bluetooth.enable = true;
        };
      in
      {

        "test: bluetooth support enabled" = {
          expr = sut.config.hardware.bluetooth.enable;
          expected = true;
        };

        "test: defaultPackage contains bluetui" = {
          expr = containsPackage "bluetui" sut.config.environment.defaultPackages;
          expected = true;
        };

        "test: defaultPackage contains bluez-tools" = {
          expr = containsPackage "bluez-tools" sut.config.environment.defaultPackages;
          expected = true;
        };
      };
  };
}
