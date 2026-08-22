/**
  # Command-line API clients

  ## 🛠️ Tech Stack

  - [Curlie homepage](https://rs.github.io/curlie/)
    ([Curlie @ GitHub](https://github.com/rs/curlie)).
  - [HTTPie homepage](https://httpie.io/).
    ([HTTPie @ GitHub](https://github.com/httpie)).
  - [Posting homepage](https://posting.sh/)
    ([Posting @ GitHub](https://github.com/darrenburns/posting)).
  - [xh @ GitHub](https://github.com/ducaale/xh).
*/
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.biapy.dev.tui-api-clients;
in
{
  options = {
    biapy.dev.tui-api-clients = {
      enable = mkEnableOption "command-line API clients";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      curl
      curlie
      httpie
      posting
      xh
    ];
  };
}
