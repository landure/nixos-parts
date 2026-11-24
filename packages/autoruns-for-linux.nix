/**
  # autoruns-for-linux

  Rust command-line implementation of Sysinternals Autoruns for Linux.
  Inventories programs, modules, scripts, services, extensions and other
  integrations configured to activate at Linux system, user, browser, device,
  mount, network and application events.

  The scanner is purely static: it never executes a discovered command, starts
  a unit, synthesizes a device event or mounts media.

  ## 🛠️ Tech Stack

  - [Autoruns for Linux @ GitHub](https://github.com/microsoft/Autoruns-for-Linux).
*/
{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage {
  pname = "autoruns-for-linux";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "Autoruns-for-Linux";
    rev = "5e1afe3e9efca7f53ff655c6af6ab149f5e9acd0";
    hash = "sha256-xKYXiW6RXJJz2KcaDBojd8klZohplFhfwFa8xWpu/kE=";
  };

  cargoHash = "sha256-4CVsiaYY7/b4D2MMwRyLCGnF3oiALeaDOKd4OU9bPRI=";

  meta = {
    description = "Sysinternals Autoruns for Linux: inventory programs configured to run at system boot or user logon";
    homepage = "https://github.com/microsoft/Autoruns-for-Linux";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "autoruns";
  };
}
