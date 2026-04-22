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
  inputs,
  ...
}:
let
  module =
    {
      config,
      lib,
      pkgs,
      
      ...
    }:
    let
      inherit (lib.lists) any length;
      inherit (lib.modules) mkDefault mkIf;
      inherit (lib.options) mkEnableOption;

      cfg = config.biapy.facter.detected.bluetooth;

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
      options.biapy.facter.detected.bluetooth.enable =
        mkEnableOption "Enable the Facter bluetooth module"
        // {
          default = bluetooth_detected;
          defaultText = "hardware dependent";
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
    };

in
{

  flake = {
    biapy.modules.nixos."facter.bluetooth" = module;

  };

  perSystem =
    {
      lib,
      system,
      ...
    }:
    let
      inherit (lib) getName;
      inherit (lib.lists) any;


      evalNixOSModule =
        modules:
        import (inputs.nixpkgs + "/nixos/lib/eval-config.nix") {
          system = system;
          modules = [ module ] ++ modules;
        };

      withFacterReport = hardware: {
        hardware.facter.report.hardware = hardware;
      };

      withoutBluetooth = evalNixOSModule [
        (withFacterReport {
          bluetooth = [ ];
          usb = [ ];
        })
      ];

      bluetoothFromHardware = evalNixOSModule [
        (withFacterReport {
          bluetooth = [ { name = "adapter"; } ];
          usb = [ ];
        })
      ];

      bluetoothFromUsbDriver = evalNixOSModule [
        (withFacterReport {
          bluetooth = [ ];
          usb = [ { driver = "btusb"; } ];
        })
      ];

      bluetoothFromUsbDriverModule = evalNixOSModule [
        (withFacterReport {
          bluetooth = [ ];
          usb = [ { driver_module = "btusb"; } ];
        })
      ];

      bluetoothDisabled = evalNixOSModule [
        (withFacterReport {
          bluetooth = [ { name = "adapter"; } ];
          usb = [ ];
        })
        {
          biapy.facter.detected.bluetooth.enable = false;
        }
      ];

      hasDefaultPackage =
        name: evaluated: any (pkg: getName pkg == name) evaluated.config.environment.defaultPackages;

    in
    {
      nix-unit.tests."biapy.modules.nixos.\"facter.bluetooth\"" = {
        "test: default disabled without detected hardware" = {
          expr = withoutBluetooth.config.biapy.facter.detected.bluetooth.enable;
          expected = false;
        };

        "test: hardware report enables module by default" = {
          expr = bluetoothFromHardware.config.biapy.facter.detected.bluetooth.enable;
          expected = true;
        };

        "test: btusb usb driver enables module by default" = {
          expr = bluetoothFromUsbDriver.config.biapy.facter.detected.bluetooth.enable;
          expected = true;
        };

        "test: btusb usb driver_module enables module by default" = {
          expr = bluetoothFromUsbDriverModule.config.biapy.facter.detected.bluetooth.enable;
          expected = true;
        };

        "test: detected hardware enables packages and bluez" = {
          expr =
            bluetoothFromHardware.config.hardware.bluetooth.enable
            && hasDefaultPackage "bluez-tools" bluetoothFromHardware
            && hasDefaultPackage "bluetui" bluetoothFromHardware;
          expected = true;
        };

        "test: explicit disable skips bluetooth packages" = {
          expr =
            !bluetoothDisabled.config.biapy.facter.detected.bluetooth.enable
            && !hasDefaultPackage "bluez-tools" bluetoothDisabled
            && !hasDefaultPackage "bluetui" bluetoothDisabled;
          expected = true;
        };
      };
    };

}
