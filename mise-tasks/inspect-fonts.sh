#!/usr/bin/env bash
#MISE description="Print the font names provided by the given font package"
set -euo pipefail

package="${1:?Usage: mise run inspect-fonts <package>}"

store_path="$(nix build "nixpkgs#${package}" --no-link --print-out-paths 2>'/dev/null')"

if [[ ! -d "${store_path}/share/fonts" ]]; then
	gum log --structured --level 'error' "Package '${package}' does not have fonts in 'share/fonts'" \
		path "${store_path}/share/fonts"
	exit 1
fi

gum log --level 'info' "Package: ${package}"
gum log --level 'info' "Store path: ${store_path}"

echo "Font names:"
fd --type f '.*\.(ttf|otf|woff|woff2)$' "${store_path}/share/fonts" --exec \
	fc-query --format '%{file}: %{fullname}\n' {} |
	sed -e 's|^[^:]*/||'
