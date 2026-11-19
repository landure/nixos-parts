#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-3.0-or-later
# shellcheck shell=bash
# Name: passh
# Version: 1.0.0
# License: GPL-3.0-or-later
# Author: Pierre-Yves Landuré (@landure)
# Description: ssh with public key authentication turned off.
# Homepage: https://serverfault.com/questions/493213/temporarily-disable-ssh-public-key-authentication-from-client

set -euo pipefail

version='1.0.0'

script_version="passh v${version}"
script_name="${0##*/}"

function usage() {
	cat <<EOF
${script_version}

passh runs ssh with public key authentication turned off.

Usage:

${script_name} [ -h | -? | --help ] [ -V | --version ] [ssh args] <ssh target>

Options:

* -h | -? | --help : Display this message.
* -V | --version   : Display version.
* ssh args         : ssh flag arguments (starting with -).
* ssh target       : ssh target (user@host).

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

case "${1:-}" in
'-h' | '--help' | '-?')
	usage && exit 0
	;;
'-V' | '--version')
	echo "${script_version}" && exit 0
	;;
esac

require-commands ssh

exec ssh \
	-o 'PasswordAuthentication=yes' \
	-o 'PreferredAuthentications=keyboard-interactive,password' \
	-o 'PubkeyAuthentication=no' \
	"${@}"
