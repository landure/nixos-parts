/**
  # Biapy Users configurationDirectory

  Load users set in biapy.users.configurationDirectiory.
*/
{
  config,
  lib,
  self,
  ...
}:
let
  inherit (lib.attrsets) attrNames listToAttrs;
  inherit (lib.lists) filter;
  inherit (lib.modules) mkDefault;
  inherit (lib.options) mkOption;
  inherit (lib.strings) hasSuffix removeSuffix;
  inherit (lib.trivial) pathExists;
  inherit (lib.types) path;

  isNixFile = name: hasSuffix ".nix" name;
  removeNixExtension = name: removeSuffix ".nix" name;

  getUserConfigsFromNixFiles =
    dir: nixFiles:
    listToAttrs (
      map (
        file:
        let
          username = removeNixExtension file;
        in
        {
          name = username;
          value = {
            configurationPath = "${dir}/${file}";
          };
        }
      ) nixFiles
    );

  getUserConfigsFromDirectories =
    dir: directories:
    listToAttrs (
      map (
        directory:
        let
          username = directory;
        in
        {
          name = username;
          value = {
            configurationPath = "${dir}/${directory}/default.nix";
          };
        }
      ) directories
    );

  getUsersFromDirectory =
    dir:
    let
      dirContents = builtins.readDir dir;
      entries = attrNames dirContents;

      nixFiles = filter (name: (dirContents.${name} == "regular") && isNixFile name) entries;

      directories = filter (
        name: (dirContents.${name} == "directory") && pathExists "${dir}/${name}/default.nix"
      ) entries;

      usersFromFiles = getUserConfigsFromNixFiles dir nixFiles;
      usersFromDirs = getUserConfigsFromDirectories dir directories;
    in
    usersFromFiles // usersFromDirs;
in
{
  options.biapy.users.configurationsDirectory = mkOption {
    type = path;
    default = "${self}/configurations/users";
    defaultText = "<flake>/configurations/users";
    description = "Path of the users configurations";
  };

  config = {
    biapy.users.users = mkDefault (getUsersFromDirectory config.biapy.users.configurationsDirectory);
  };
}
