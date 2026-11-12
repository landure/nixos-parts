#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-3.0-or-later
# shellcheck shell=bash
# Name: skrg
# Version: 1.0.0
# License: GPL-3.0-or-later
# Author: Pierre-Yves Landuré (@landure)
# Description: Interactive live grep with skim preview.

set -euo pipefail

version='1.0.0'

script_version="skrg v${version}"
script_name="${0##*/}"

function usage() {
	cat <<EOF
${script_version}

skrg interactive live grep with skim preview.

Usage:

${script_name} [ -h | -? | --help ] [ -V | --version ] [sk args] [--] [rg args]

Options:

* -h | -? | --help : Display this message.
* -V | --version   : Display version.
* sk args          : skim (sk) flag arguments (starting with -).
* rg args          : rg arguments

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

require-commands rg sk batline

case "${1:-}" in
'-h' | '--help' | '-?')
	usage && exit 0
	;;
'-V' | '--version')
	echo "${script_version}" && exit 0
	;;
esac

# Live grep
rg_command=(rg --line-number --no-heading --color='always')

# Parse arguments: everything before -- is for skim, everything after is for rg
sk_args=()

# Parse arguments using while and shift
while [[ ${#} -gt 0 && ${1} =~ ^- && ${1} != '--' ]]; do
	option="${1}"
	shift

	if [[ ${option} != '--' ]]; then
		sk_args+=("${option}")
	fi
done

[[ ${1:-} == '--' ]] && shift

exec sk --ansi --delimiter=':' --interactive --no-height \
	--skip-to-pattern='[^/]*:' \
	--preview='test -e {1} && batline --style=numbers --color=always --auto-range {1..2}' \
	--preview-window='right:60%:nowrap' \
	--cmd-prompt='rg❯ ' \
	--cmd="${rg_command[*]} {q}" \
	--cmd-query="${*}" \
	"${sk_args[@]}"
