/**
  # flake-file base inputs

  ## 🛠️ Tech Stack

  - [Home Manager homepage](https://home-manager.dev/)
    ([Home Manager @ GitHub](https://github.com/nix-community/home-manager)).
  - [Stylix homepage](https://nix-community.github.io/stylix)
    ([Stylix @ GitHub](https://github.com/nix-community/stylix)).
*/
{ inputs, ... }:
{
  imports = [
    (inputs.stylix.homeModules.stylix or { })
  ];
}
