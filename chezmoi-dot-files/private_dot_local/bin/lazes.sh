#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-3.0-or-later
# shellcheck shell=bash
# Name: lazes
# Version: 1.0.0
# License: GPL-3.0-or-later
# Author: Pierre-Yves (biapy)
# Description: ls compatibility wrapper for eza.

set -euo pipefail

version='1.0.0'

script_version="lazes v${version}"
script_name="${0##*/}"

usage() {
	cat <<EOF
${script_version}

lazes is a ls compatibility wrapper for eza.

Usage:
${script_name} [ls arguments]

EOF
}

error() {
	if command -v gum >/dev/null 2>&1; then
		gum log --level=error "${*}"
	else
		printf 'Error: %s\n' "${*}" >&2
	fi
}

require-commands() {
	for cmd in "${@}"; do
		command -v "${cmd}" >/dev/null 2>&1 ||
			error "missing command: ${cmd}"
	done
}

require-commands eza

case "${1:-}" in
'-h' | '--help' | '-?')
	usage && exit 0
	;;
'-V' | '--version')
	echo "${script_version}" && exit 0
	;;
esac

# Translate ls arguments into their eza equivalents.
args=()
while [ "${#}" -gt 0 ]; do
	arg="${1}"
	shift
	case "${arg}" in
	--)
		args+=("${arg}")
		break
		;;
	--directory)
		args+=('--list-dirs')
		;; # Replace --directory with --list-dirs
	--numeric-uid-gid)
		args+=('--numeric')
		;; # Replace --numeric-uid-gid with --numeric
	--block-size | --author | --escape | --dired | --full-time | --kibibytes | --literal | --quoting-style | --size | --time-style | --width)
		if [ "${#}" -gt 0 ] && [ "${1#-}" = "${1}" ]; then
			shift
		fi
		;;
	--sort | --sort=* | --time | --time=* | --indicator-style | --indicator-style=* | --color | --color=* | --hyperlink | --hyperlink=*)
		if [ "${arg#*=}" != "${arg}" ]; then
			args+=("${arg}")
		else
			if [ "${#}" -gt 0 ] && [ "${1#-}" = "${1}" ]; then
				args+=("${arg}" "${1}")
				shift
			else
				args+=("${arg}")
			fi
		fi
		;;
	--*)
		args+=("${arg}")
		;;
	-*)
		arg="${arg#-}"
		while [ -n "${arg}" ]; do
			char="${arg%"${arg#?}"}"
			case "${char}" in
			t)
				args+=('--sort=modified')
				;; # Suppress -t
			r)
				args+=('--reverse')
				;; # Suppress -r
			S)
				args+=('--sort=size')
				;; # Supress -S
			s)
				;; # Supress -s (no equivalent in eza)
			c)
				args+=('--sort=changed')
				;; # Supress -c
			u)
				args+=('--sort=accessed')
				;; # Supress -u
			1)
				args+=('--oneline')
				;; # Supress -1
			g)
				args+=('--group')
				;; # Supress -g
			d)
				args+=('--list-dirs')
				;; # Supress -d
			p)
				args+=('--indicator-style=slash')
				;; # Supress -p
			*)
				args+=("-${char}")
				;;
			esac
			arg="${arg#?}"
		done
		;;
	*)
		args+=("${arg}")
		;;
	esac
done

args+=("${@}")

# Execute eza with the processed arguments
exec eza "${args[@]}"
