/**
  # LibreWolf

  A custom version of Firefox, focused on privacy, security and freedom.

  ## 🛠️ Tech Stack

  - [LibreWolf homepage](https://librewolf.net/).

  ## 🙇 Acknowledgements

  - [Firefox @ NixOS Wiki](https://nixos.wiki/wiki/Firefoxnixos.wiki/wiki/Firefox).

  ### 🏠 Home Manager

  - [programs.librewolf @ Home Manager](https://nix-community.github.io/home-manager/options/home-manager/programs/librewolf.html).
  - [programs.librewolf @ NixOS reference](https://search.nixos.org/options?source=home_manager&query=programs.librewolf.).

  ### 🎨 Stylix

  - [Firefox and its derivatives @ Stylix](https://nix-community.github.io/stylix/options/modules/firefox.html).
*/
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.modules) mkDefault mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.biapy.programs.librewolf;
in
{
  options.biapy.programs.librewolf.enable = mkEnableOption "LibreWolf";

  config = mkIf cfg.enable {

    stylix.targets.librewolf.profileNames = mkDefault [ "home" ];

    programs.librewolf = {
      enable = mkDefault true;

      # package = librewolf.override {
      # See nixpkgs' firefox/wrapper.nix to check which options you can use
      # nativeMessagingHosts = [
      # Gnome shell native connector
      # pkgs.gnome-browser-connector
      # Tridactyl native connector
      # pkgs.tridactyl-native
      # ];
      # }

      # deprecated. overide package.
      # enableGnomeExtensions = true;

      languagePacks = mkDefault [
        "en-US"
        "fr"
      ];

      policies = {
        BlockAboutConfig = mkDefault true;
        ExtensionSettings = {
          "uBlock0@raymondhill.net" = mkDefault {
            default_area = "menupanel";
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
            installation_mode = "force_installed";
            private_browsing = true;
          };
          "shaarli@imirhil.fr" = mkDefault {
            default_area = "menupanel";
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/shaarli/latest.xpi";
            installation_mode = "force_installed";
            private_browsing = true;
          };

        }
        //
          builtins.mapAttrs
            (slug: id: {
              "${id}" = mkDefault {
                default_area = "menupanel";
                install_url = "https://addons.mozilla.org/firefox/downloads/latest/${slug}/latest.xpi";
                installation_mode = "force_installed";
                private_browsing = true;
              };
            })
            {
              canvasblocker = "CanvasBlocker@kkapsner.de";
              ghostery = "firefox@ghostery.com";
              cookie-autodelete = "CookieAutoDelete@kennydo.com";
              facebook-container = "@contain-facebook";
              disconnect = "2.0@disconnect.me";
              darkreader = "addon@darkreader.org";
              leechblock-ng = "leechblockng@proginosko.com";
              # tabby-window-tab-manager = "tabby@whatsyouridea.com";
              tab-session-manager = "Tab-Session-Manager@sienori";

              webtoepub-for-baka-tsuki = "WebToEpub@Baka-tsuki.org";
            };

      };
      # "formautofill@mozilla.org"
      # "pictureinpicture@mozilla.org"
      # "screenshots@mozilla.org"
      # "webcompat-reporter@mozilla.org"
      # "webcompat@mozilla.org"
      # "default-theme@mozilla.org"
      # "addons-search-detection@mozilla.com"
      # "profile-switcher-ff@nd.ax"
      # "jid1-BoFifL9Vbdl2zQ@jetpack":"b12bbf89-d6b1-47bf-826d-5feef95213b6",

      profiles."home" = {
        isDefault = mkDefault true;
        name = mkDefault "Home profile";

        # Attribute set of Firefox preferences.
        settings = {
          "browser.startup.homepage" = mkDefault "https://nixos.org";
          "browser.search.region" = mkDefault "FR";
          "browser.search.isUS" = mkDefault false;
          "browser.search.suggest.enabled" = mkDefault false;
          "browser.urlbar.quicksuggest.scenario" = mkDefault "history";
          "browser.urlbar.showSearchSuggestionsFirst" = mkDefault false;
          "browser.urlbar.suggest.recentsearches" = mkDefault false;
          "browser.urlbar.suggest.searches" = mkDefault false;
          "datareporting.healthreport.uploadEnabled" = mkDefault false;
          "datareporting.usage.uploadEnabled" = mkDefault false;
          "dom.security.https_only_mode" = mkDefault true;
          "dom.security.https_only_mode_ever_enabled" = mkDefault true;
          "privacy.donottrackheader.enabled" = mkDefault true;
          "privacy.fingerprintingProtection" = mkDefault true;
          "privacy.globalprivacycontrol.enabled" = mkDefault true;
          "privacy.query_stripping.enabled" = mkDefault true;
          "privacy.query_stripping.enabled.pbmode" = mkDefault true;
          "privacy.trackingprotection.emailtracking.enabled" = mkDefault true;
          "privacy.trackingprotection.enabled" = mkDefault true;
          "privacy.trackingprotection.socialtracking.enabled" = mkDefault true;
          "distribution.searchplugins.defaultLocale" = mkDefault "fr-FR";
          "general.useragent.locale" = mkDefault "fr-FR";
          "browser.bookmarks.showMobileBookmarks" = mkDefault true;
          "browser.translations.neverTranslateLanguages" = mkDefault "en";
          "browser.newtabpage.pinned" = mkDefault [
            {
              title = "NixOS";
              url = "https://nixos.org";
            }
          ];
        };

        # Declarative search engine configuration.
        search = {
          default = mkDefault "ddg";
          privateDefault = mkDefault "ddg";

          # The order the search engines are listed in.
          # Any engines that aren't included in this list will be listed after these in an unspecified order.
          order = mkDefault [
            "ddg"
            "google"
          ];
          engines = {

            nix-packages = {
              name = mkDefault "Nix Packages";
              urls = mkDefault [
                {
                  template = "https://search.nixos.org/packages";
                  params = [
                    {
                      name = "type";
                      value = "packages";
                    }
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];

              icon = mkDefault "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = mkDefault [ "@np" ];
            };

            wiki-nixos = {
              name = mkDefault "Wiki NixOS";
              urls = mkDefault [ { template = "https://wiki.nixos.org/w/index.php?search={searchTerms}"; } ];
              iconMapObj."16" = mkDefault "https://wiki.nixos.org/favicon.ico";
              definedAliases = mkDefault [ "@nw" ];
            };

            bing.metaData.hidden = mkDefault true;
            google.metaData.alias = mkDefault "@g"; # builtin engines only support specifying one additional alias
          };
        };

        extensions = {
          # acknowledge 'extensions.settings' will override all previous extensions
          force = mkDefault true;
          settings = {
            "uBlock0@raymondhill.net".settings = {
              selectedFilterLists = mkDefault [
                "ublock-filters"
                "ublock-badware"
                "ublock-privacy"
                "ublock-unbreak"
                "ublock-quick-fixes"
              ];
            };

            # Example with Stylus' UUID-form extensionID
            "{7a7a4a92-a2a0-41d1-9fd7-1e92480d612d}".settings = {
              dbInChromeStorage = mkDefault true; # required for Stylus
            };
          };
        };

        bookmarks = {
          # acknowledge 'bookmarks.settings' will override all previous bookmarks
          force = mkDefault true;
          settings = mkDefault [
            {
              name = "wikipedia";
              tags = [ "wiki" ];
              keyword = "wiki";
              url = "https://en.wikipedia.org/wiki/Special:Search?search=%s&go=Go";
            }
            "separator"
            {
              name = "Nix sites";
              toolbar = true;
              bookmarks = [
                {
                  name = "homepage";
                  url = "https://nixos.org/";
                }
                {
                  name = "Wiki NixOS";
                  tags = [
                    "wiki"
                    "nix"
                  ];
                  url = "https://wiki.nixos.org/";
                }
                {
                  name = "NixOS Wiki";
                  tags = [
                    "wiki"
                    "nix"
                  ];
                  url = "https://nixos.wiki/";
                }
              ];
            }

          ];
        };

        # See https://support.mozilla.org/en-US/kb/containers
        # colors: "blue", "turquoise", "green", "yellow", "orange", "red", "pink", "purple", "toolbar"
        # icon: "briefcase", "cart", "circle", "dollar", "fence", "fingerprint", "gift", "vacation", "food", "fruit", "pet", "tree", "chill"
        containers = {
          dangerous = {
            color = mkDefault "red";
            icon = mkDefault "fruit";
            id = mkDefault 2;
          };
          shopping = {
            # name = "Shopping";
            color = mkDefault "blue";
            icon = mkDefault "cart";
            id = mkDefault 1;
          };
        };
      };
    };
  };
}
