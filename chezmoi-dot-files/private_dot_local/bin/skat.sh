#!/usr/bin/env bash
# SPDX-License-Identifier: CC-BY-NC-SA-4.0
# shellcheck shell=bash
# Name: skat
# Version: 1.0.0
# License: CC-BY-NC-SA-4.0
# Author: Pierre-Yves Landuré (@landure)
# Author: Ignacio Vergara Kausel (@ivergar)
# Description: Open selected file in Helix (bat).
#
# based on Ignacio Vergara Kausel work
# https://ivergara.github.io/Supercharging-shell.html

set -euo pipefail

version='1.0.0'

script_version="skat v${version}"
script_name="${0-##*/}"

function usage() {
	cat <<EOF
${script_version}

skat list files in the working directory
and open selected file in bat.

Usage:

${script_name} [ -h | -? | --help ] [ -V | --version ] [bat args] [--] [sk args]

Options:

* -h | -? | --help : Display this message.
* -V | --version   : Display version.
* bat args         : bat flag arguments (starting with -).
* sk args          : skim (sk) arguments.

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

require-commands skf xargs bat

case "${1:-}" in
'-h' | '--help' | '-?')
	usage && exit 0
	;;
'-V' | '--version')
	echo "${script_version}" && exit 0
	;;
esac

# Parse arguments: everything before -- is for bat, everything after is for skim
bat_args=()

# Parse arguments using while and shift
while [[ ${#} -gt 0 && ${1} =~ ^- && ${1} != '--' ]]; do
	option="${1}"
	shift

	if [[ ${option} != '--' ]]; then
		bat_args+=("${option}")
	fi
done

[[ ${1:-} == '--' ]] && shift

skf --no-multi "${@}" |
	exec xargs --no-run-if-empty bat "${bat_args[@]}"
