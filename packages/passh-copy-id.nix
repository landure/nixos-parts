/**
  # passh-copy-id

  ssh-copy-id with public key authentication turned off.

  ## 🙇 Acknowledgements

  - [Temporarily disable ssh public key authentication from client @ serverfault](https://serverfault.com/questions/493213/temporarily-disable-ssh-public-key-authentication-from-client).
*/
{
  lib,
  writeShellApplication,
  gum,
  openssh,
}:
lib.makeOverridable (
  args:
  writeShellApplication {
    name = "passh-copy-id";
    runtimeInputs = [
      gum
      args.openssh
    ];
    bashOptions = [
      "errexit"
      "nounset"
      "pipefail"
    ];
    text = builtins.readFile ../chezmoi-dot-files/private_dot_local/bin/passh-copy-id.sh;
  }
) { inherit openssh; }
