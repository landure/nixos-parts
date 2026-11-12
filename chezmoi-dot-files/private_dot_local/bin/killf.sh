#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-3.0-or-later
# shellcheck shell=bash
# Name: killf
# Version: 1.0.0
# License: GPL-3.0-or-later
# Author: Minh Hoang Nguyen (@minhnh94)
# Description: Fuzzy Kill Process
# Homepage: https://www.tsukie.com/en/technologies/use-cli-like-a-modern-tech-bro/

set -euo pipefail

version='1.0.0'

script_version="killf v${version}"
script_name="${0##*/}"

function usage() {
	cat <<EOF
${script_version}

killf is a comfortable UI for selecting a process and killing it

Usage:

${script_name} [ -h | -? | --help ] [ -V | --version ] [kill args] [--] [fzf query]

Options:

* -h | -? | --help : Display this message.
* -V | --version   : Display version.
* kill args        : kill flag arguments (starting with -).
                     Defaut to -SIGTERM if none are given.
* fzf query        : initial fzf filter

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

require-commands ps tail fzf xargs witr

case "${1:-}" in
'-h' | '--help' | '-?')
	usage && exit 0
	;;
'-V' | '--version')
	echo "${script_version}" && exit 0
	;;
esac

kill_args=()

# Parse arguments using while and shift
while [[ ${#} -gt 0 && ${1} =~ ^- && ${1} != '--' ]]; do
	option="${1}"
	shift

	if [[ ${option} != '--' ]]; then
		kill_args+=("${option}")
	fi
done

[[ ${1:-} == '--' ]] && shift

if [[ ${#kill_args[@]} -eq 0 ]]; then
	kill_args=('-SIGTERM')
fi

ps -ef |
	tail --lines +2 |
	fzf --with-nth=2,8.. --accept-nth=2 \
		--no-multi --header='Select process to kill' \
		--height=100% --layout=default --border --info=inline \
		--preview-window='right:40%:wrap' \
		--preview='witr --pid {2}' --query="${*}" |
	xargs kill "${kill_args[@]}"
