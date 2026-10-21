{ lib, ... }:
let
  inherit (lib.modules) evalModules;

  identityModule = ../../../../home/_biapy/user/identity.nix;

  defaultIdentity = {
    firstname = "John";
    lastname = "Doe";
    email = "john@example.com";
    fullname = "John DOE";
    roomNumber = "1";
    workPhone = "2";
    homePhone = "3";
  };

  evalIdentity =
    {
      osIdentity ? defaultIdentity,
      secretsSopsFile ? null,
      secretsFormat ? "yaml",
      username ? "testuser",
      modules ? [ ],
    }:
    let
      osConfig = {
        biapy.users.users.${username} = {
          identity = osIdentity;
          inherit secretsSopsFile secretsFormat;
        };
      };

      stub = {
        options = {
          home.username = lib.mkOption {
            type = lib.types.str;
            default = username;
          };
          home.homeDirectory = lib.mkOption {
            type = lib.types.str;
            default = "/home/${username}";
          };
          programs.git.settings = lib.mkOption {
            type = lib.types.attrsOf (
              lib.types.attrsOf (
                lib.types.oneOf [
                  lib.types.str
                  (lib.types.listOf lib.types.str)
                ]
              )
            );
            default = { };
          };
          sops = lib.mkOption {
            type = lib.types.attrsOf lib.types.anything;
            default = { };
          };
        };
      };
    in
    (evalModules {
      specialArgs = { inherit osConfig; };
      modules = [
        stub
        identityModule
      ]
      ++ modules;
    }).config;
in
{
  flake.tests."home.biapy.user.identity" = {
    "test: identity defaults are read from osConfig" = {
      expr = (evalIdentity { }).biapy.user.identity;
      expected = defaultIdentity;
    };

    "test: fullname is computed from firstname and lastname" = {
      expr =
        (evalIdentity {
          osIdentity = {
            firstname = "John";
            lastname = "Doe";
            email = "john@example.com";
          };
        }).biapy.user.identity.fullname;
      expected = "John DOE";
    };

    "test: homePhone defaults to empty string" = {
      expr =
        (evalIdentity {
          osIdentity = {
            firstname = "John";
            lastname = "Doe";
            email = "john@example.com";
            fullname = "John DOE";
          };
        }).biapy.user.identity.homePhone;
      expected = "";
    };

    "test: git user name is the identity fullname" = {
      expr = (evalIdentity { }).programs.git.settings.user.name;
      expected = "John DOE";
    };

    "test: git user email is the identity email" = {
      expr = (evalIdentity { }).programs.git.settings.user.email;
      expected = "john@example.com";
    };

    "test: secretsSopsFile defaults from osConfig" = {
      expr = (evalIdentity { secretsSopsFile = "/secrets/testuser.yaml"; }).biapy.user.secretsSopsFile;
      expected = "/secrets/testuser.yaml";
    };

    "test: secretsFormat defaults from osConfig" = {
      expr = (evalIdentity { secretsFormat = "json"; }).biapy.user.secretsFormat;
      expected = "json";
    };

    "test: sops is configured when secretsSopsFile is set" = {
      expr = (evalIdentity { secretsSopsFile = "/secrets/testuser.yaml"; }).sops;
      expected = {
        defaultSopsFile = "/secrets/testuser.yaml";
        defaultSopsFormat = "yaml";
        secrets = {
          "ssh/identities/id_ed25519/public_key".path = "/home/testuser/.ssh/id_ed25519.pub";
          "ssh/identities/id_ed25519/private_key".path = "/home/testuser/.ssh/id_ed25519";
        };
      };
    };

    "test: sops is not configured when secretsSopsFile is null" = {
      expr = (evalIdentity { }).sops;
      expected = { };
    };

    "test: sops secrets paths use homeDirectory" = {
      expr =
        (evalIdentity {
          username = "alice";
          secretsSopsFile = "/secrets/alice.yaml";
        }).sops.secrets."ssh/identities/id_ed25519/private_key".path;
      expected = "/home/alice/.ssh/id_ed25519";
    };
  };
}
