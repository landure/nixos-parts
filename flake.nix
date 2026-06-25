# DO-NOT-EDIT. This file was auto-generated using github:vic/flake-file.
# Use `nix run .#write-flake` to regenerate it.
{
  description = "Dendritic NixOS and Home Manager modules for flake-file and flake-parts.";

  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./modules);

  inputs = {
    devshell.url = "github:numtide/devshell";
    flake-file.url = "github:vic/flake-file";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    import-tree.url = "github:vic/import-tree";
    nix-auto-follow = {
      url = "github:fzakaria/nix-auto-follow";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-unit = {
      url = "github:nix-community/nix-unit";
      inputs = {
        flake-parts.follows = "flake-parts";
        nixpkgs.follows = "nixpkgs";
      };
    };
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-lib.follows = "nixpkgs";
  };
}
