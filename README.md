# nixos-parts

Reusable dendritic `flake-parts` NixOS and Home Manager modules.

## Scope

This repository currently exposes:

- `nixosModules.biapy`
- `nixosModules.default`
- `homeModules.biapy`
- `homeModules.default`
- `devShells.x86_64-linux.default`
- `checks.x86_64-linux.check-flake-file`
- `checks.x86_64-linux.nix-unit`

The `biapy` modules are placeholders at the moment.
The flake also wires in `flake-file`, `nix-auto-follow`, `devshell`,
and `nix-unit`.

## Use

Inspect outputs:

```sh
nix flake show
```

Format Nix files:

```sh
nix fmt
```

Run checks:

```sh
nix flake check
```

Enter the development shell:

```sh
nix develop
```

Regenerate `flake.nix` after editing module definitions:

```sh
nix run .#write-flake
```

## Development notes

- `flake.nix` is generated. Do not edit it manually.
- Formatting is provided by `nixfmt` and `nixfmt-tree`.
- Tests are defined through `nix-unit`.

## 🛠️ Tech Stack

- [NixOS](https://nixos.org/).
- [flake-parts homepage](https://flake.parts/)
  ([flake-parts @ GitHub](https://github.com/hercules-ci/flake-parts)).
- [nix-auto-follow @ GitHub](https://github.com/fzakaria/nix-auto-follow).

### ❄️ Dendritic Nix

- [flake-file homepage](https://flake-file.oeiuwq.com/)
  ([flake-file @ GitHub](https://github.com/vic/flake-file)).
- [import-tree homepage](https://import-tree.oeiuwq.com/)
  ([import-tree @ GitHub](https://github.com/vic/import-tree)).

### Development tools

- [nixfmt @ GitHub](https://github.com/NixOS/nixfmt).
- [nix-unit homepage](https://nix-community.github.io/nix-unit/)
  ([nix-unit @ GitHub](https://github.com/nix-community/nix-unit)).
- [devshell homepage](https://numtide.github.io/devshell/)
  ([devshell @ GitHub](https://github.com/numtide/devshell)).

## 📝 Documentation

- [Dendrix](https://dendrix.oeiuwq.com/index.html).

## 🙇 Acknowledgements

- [Elevate Your Nix Config With Dendritic Pattern @ Vimjoyer's YouTube](https://www.youtube.com/watch?v=-TRbzkw6Hjs).