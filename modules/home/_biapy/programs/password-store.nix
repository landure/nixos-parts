/**
  # Password Store

  ## 🛠️ Tech Stack

  - [pass homepage](https://www.passwordstore.org/)
    is the standard Unix password manager — a GPG-encrypted
    store of password files organised by name.
  - [gopass homepage](https://www.gopass.pw/)
    ([gopass @ GitHub](https://github.com/gopasspw/gopass))
    is a drop-in replacement for `pass`, the standard UNIX password manager.
  - [browserpass @ GitHub](https://github.com/browserpass/browserpass-extension)
    is a browser extension for zx2c4's `pass`,
    a UNIX based password store manager.
    It allows you to auto-fill or copy to clipboard credentials
    for the current domain, protecting you from phishing attacks.
  - [Tomb @ homepage](https://dyne.org/tomb/)
    ([Tomb @ GitHub](https://github.com/dyne/tomb))
    is a wrapper around `cryptsetup`/`LUKS` for steganographic
    file encryption on GNU/Linux.

  ### 🧩 Pass extensions

  - [pass-audit @ GitHub](https://github.com/roddhjav/pass-audit)
    is a pass extension that audits the password repository
    against `haveibeenpwned` and reports duplicates / weak entries.
  - [pass-import @ GitHub](https://github.com/roddhjav/pass-import)
    imports credentials from existing password managers
    (LastPass, 1Password, KeePass, Bitwarden, …).
  - [pass-otp @ GitHub](https://github.com/tadfisher/pass-otp)
    manages one-time-password (OTP) tokens.
  - [pass-update @ GitHub](https://github.com/roddhjav/pass-update)
    provides an easy flow for updating passwords in bulk.
  - [pass-file @ GitHub](https://github.com/dvogt23/pass-file)
    allows attaching files to the password-store.
  - [pass-tomb @ GitHub](https://github.com/roddhjav/pass-tomb)
    keeps the password-store encrypted inside a `tomb(1)`
    and only opens it on demand.
  - [pass-genphrase @ GitHub](https://github.com/congma/pass-genphrase)
    generates memorable passwords.

  ## 📝 Documentation

  ### 🏠 Home Manager

  - [programs.browserpass @ Home Manager](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.browserpass.enable).
  - [programs.browserpass @ NixOS reference](https://search.nixos.org/options?source=home_manager&query=programs.browserpass.).
  - [programs.password-store @ Home Manager](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.password-store.enable).
  - [programs.password-store @ NixOS reference](https://search.nixos.org/options?source=home_manager&query=programs.password-store.).
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

  cfg = config.biapy.programs.password-store;
in
{
  options.biapy.programs.password-store.enable = mkEnableOption "pass & browserpass";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      tomb
    ];

    programs = {
      # `pass` — the standard Unix password manager.
      # The package is built with all the extensions listed
      # above so that `pass <extension>` is on `$PATH`.
      password-store = {
        enable = mkDefault true;
        package = mkDefault (
          pkgs.pass.withExtensions (
            exts: with exts; [
              pass-audit
              pass-file
              pass-genphrase
              pass-import
              pass-otp
              pass-tomb
              pass-update
            ]
          )
        );
      };

      # browserpass — native messaging host for the
      # `pass(1)` browser extension.
      browserpass.enable = mkDefault true;
    };
  };
}
