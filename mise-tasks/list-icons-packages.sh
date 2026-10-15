#!/usr/bin/env bash
#MISE description="List icon theme packages, with their themes names"

set -o errexit
set -o nounset
set -o pipefail

nix search --json nixpkgs '^[^\\.]*-icon-theme$' |
jq --raw-output  'keys | .[]' |
cut --delimiter=. --fields=3- |
grep --invert-match '\.' |
while read -r 'package'; do
    gum format "# ${package}"
    nix build "nixpkgs#${package}" --no-link --print-out-paths 2>'/dev/null' |
    xargs -I{} fd --full-path --type='d' --max-depth=3 --format='{/}' 'share/icons/.*' {} |
    sed -e 's/^/- /' |
    gum format
done
