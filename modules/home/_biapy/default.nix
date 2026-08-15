{ inputs, ... }:
{
  imports = [
    (inputs.home-manager.flakeModules.home-manager or { })
    (inputs.stylix.homeModules.stylix or { })
  ];
}
