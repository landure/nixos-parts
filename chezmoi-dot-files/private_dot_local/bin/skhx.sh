#!/usr/bin/env bash
# SPDX-License-Identifier: CC-BY-NC-SA-4.0
# shellcheck shell=bash
# Name: skhx
# Version: 1.0.0
# License: CC-BY-NC-SA-4.0
# Author: Pierre-Yves Landuré (@landure)
# Author: Ignacio Vergara Kausel (@ivergar)
# Description: Open selected file in Helix (hx).
#
# based on Ignacio Vergara Kausel work
# https://ivergara.github.io/Supercharging-shell.html

set -euo pipefail

version='1.0.0'

script_version="skhx v${version}"
script_name="${0-##*/}"

function usage() {
	cat <<EOF
${script_version}

skhx list files in the working directory
and open selected file in Helix (hx).

Usage:

${script_name} [ -h | -? | --help ] [ -V | --version ] [rg args]

Options:

* -h | -? | --help : Display this message.
* -V | --version   : Display version.
* rg args          : ripgrep (rg) arguments.

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

require-commands skf xargs hx

case "${1:-}" in
'-h' | '--help' | '-?')
	usage && exit 0
	;;
'-V' | '--version')
	echo "${script_version}" && exit 0
	;;
esac

skf --no-multi "${@}" |
	exec xargs --no-run-if-empty hx
