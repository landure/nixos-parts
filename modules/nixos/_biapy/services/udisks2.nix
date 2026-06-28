/**
  # USB Storage

  Add support for USB Storage mounting by users.

  ## 🛠️ Tech Stack

  - [UDisks @ GitHub](https://github.com/storaged-project/udisks).
  - [bashmount @ GitHub](https://github.com/jamielinux/bashmount).
  - [usermount @ GitHub](https://github.com/tom5760/usermount).

  ## 📝 Documentation

  - [UDisks Reference Manual](https://storaged.org/doc/udisks2-api/latest/).

  ### ❄️ NixOS

  - [services.udisks2 @ NixOS reference](https://search.nixos.org/options?query=services.udisks2.).

  ## 🙇 Acknowledgements

  - [USB storage devices @ Official NixOS Wiki](https://wiki.nixos.org/wiki/USB_storage_devices).
  - [udisks @ ArchLinux Wiki](https://wiki.archlinux.org/title/Udisks).
  - [Monter les périphériques (externes ou non) facilement @ Debian Facile 🇫🇷](https://debian-facile.org/utilisateurs:captnfab:tutos:pmount-udisks).
*/
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkDefault mkIf;
  inherit (lib.meta) getExe';

  cfg = config.biapy.services.udisks2;

  udisksctl_exe = getExe' pkgs.udisks "udisksctl";

  fmount = pkgs.writeShellScriptBin "fmount" ''
    usage()
    {
      echo "Utilisation :
      ''${0} [-u] [[/dev/]device | [/dev/disk/by-uuid/]uuid | [/dev/mapper/]uuid]
     
    Monte un système de fichier dans un sous-répertoire de /media via udisks ou
    udisks2.
    Si aucun périphérique n'est donné, fmount tente de deviner le dernier périphérique inséré.
     
    Option de l'application :
      -u Démonte le système de fichier
      -h Affiche ce message d'aide"
    }
     
    finddev()
    {
      local DEV="''${1}"
     
      if (echo "''${DEV}" | grep -q '^/dev/') && [ -e "''${DEV}" ]
      then
        echo "''${DEV}"
      fi
     
      if [ -e "/dev/disk/by-uuid/''${DEV}" ]
      then
        echo "/dev/disk/by-uuid/"''$(echo "''${DEV}" | sed 's/.*/\L&/')
      fi
     
      if [ -e "/dev/''${DEV}" ]
      then
        echo "/dev/''${DEV}"
      fi
     
      if [ -e "/dev/mapper/''${DEV}" ]
      then
        echo "/dev/mapper/''${DEV}"
      fi
    }
     
    wrapper()
    {
      local ACTION
      local DEVICE

      ACTION="''${1}"
      DEVICE="''${2}"
     
      case "''${ACTION}" in
        "mount")
            ${udisksctl_exe} mount -b "''${DEVICE}"
          return ''${?}
          ;;
        "umount")
            ${udisksctl_exe} unmount -b "''${DEVICE}"
          return ''${?}
          ;;
        *)
          echo "Action invalide"
          return 1
          ;;
      esac
    }
     
    guesslast()
    {
      local LOG
      local PARTS

      LOG=$(dmesg | tail -n 50 | grep 'Attached scsi generic' -A 11 | tail -n 12)
      PARTS=$(echo "''${LOG}" | grep "sd.: sd.")
      if [ "''${PARTS}" = "" ]
      then
        DEV=$(echo "''${LOG}" | sed '/\[sd/s/.*\[\(sd[^\]]*\)\].*/\1/')
      else
        DEV=$(echo "''${PARTS}" | sed '/sd.:/s/.*sd.: \(sd[^ ]*\).*/\1/')
      fi
      echo "''${DEV}"
    }
     
    ACTION="mount"
     
    if [[ $# -ne 0 && "''${1}" = "-u" ]]; then
      ACTION="umount"
      shift
    fi
     
    if [[ $# -ne 0 && "''${1}" = "-h" ]]; then
      usage
      exit 0
    fi
     
    if [ ''${#} -ne 1 ]
    then
      DEV="$(guesslast)"
    else
      DEV="''${1}"
    fi
     
    DEV="$(finddev "''${DEV}")"
     
    if [ -z "''${DEV}" ]
    then
      echo "Impossible de trouver le périphérique ''${DEV}."
      exit 1
    fi
     
    wrapper "''${ACTION}" "''${DEV}"
    exit ''${?}
  '';
in
{
  options = {
    biapy.services.udisks2 = {
      enable = mkEnableOption "USB storage automount";
    };
  };

  config = mkIf cfg.enable {
    services.udisks2 = {
      enable = mkDefault true;

      settings."udisks2.conf".defaults = {
        # prevents excessive access time writes on flash devices.
        defaults = mkDefault "noatime";
        btrfs_defaults = mkDefault "compress=zstd";
      };
    };

    environment.defaultPackages = with pkgs; [
      bashmount
      usermount
      fmount
    ];
  };
}
