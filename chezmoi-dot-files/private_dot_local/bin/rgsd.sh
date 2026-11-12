#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-3.0-or-later
# shellcheck shell=bash
# Name: rgsd
# Version: 1.0.0
# License: GPL-3.0-or-later
# Author: Pierre-Yves Landuré (@biapy)
# Description: perform search & replace on matching files

set -euo pipefail

version='1.0.0'

script_version="rgsd v${version}"
script_name="${0##*/}"

usage() {
	cat <<EOF
${script_version}

rgsd replace the matching string in matching files.

It uses ripgrep (rg) to match files, and sd to perform the replacement.

Alternative: ambr (https://github.com/dalance/amber)

Usage:

${script_name}  <search> <replace> [path]"

Options:

* -h | -? | --help : Display this message.
* -V | --version   : Display version.
* search           : the string or regular expression to search.
* replace          : the replacement.
* path             : the path where to perform the replacement.

EOF
}

error() {
	if command -v gum >/dev/null 2>&1; then
		gum log --level=error "${*}"
	else
		printf 'Error: %s\n' "${*}" >&2
	fi
}

die() {
	error "${@}"
	exit 1
}

require-commands() {
	for cmd in "${@}"; do
		command -v "${cmd}" >/dev/null 2>&1 ||
			die "missing command: ${cmd}"
	done
}

require-commands bat less tput

case "${1:-}" in
'-h' | '--help' | '-?')
	usage && exit 0
	;;
'-V' | '--version')
	echo "${script_version}" && exit 0
	;;
esac

if [[ ${#} -lt 2 || ${#} -gt 3 ]]; then
	usage && exit 1
fi

search="${1}"
replace="${2}"
path="${3:-.}"

rg --files-with-matches "${search}" "${path}" |
	xargs -I{} sd "${search}" "${replace}" {}
