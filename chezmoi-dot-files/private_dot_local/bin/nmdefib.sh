#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-3.0-or-later
# shellcheck shell=bash
# Name: nmdefib
# Version: 2.0.0
# License: GPL-3.0-or-later
# Author: Pierre-Yves Landuré (@landure)
# Description: keep a flaky Wi-Fi connection up by reconnecting when connectivity is lost.

set -euo pipefail

version='2.0.0'

script_version="nmdefib v${version}"
script_name="${0##*/}"

usage() {
	cat <<EOF
${script_version}

nmdefib keeps a flaky Wi-Fi connection up by reconnecting when connectivity is lost.

Usage:
${script_name} [options]

Options:
  --ping-host HOST       ping target IP (default 1.1.1.1)
  --dns-host HOST        DNS server IP (empty disables DNS check)
  --dns-name NAME        name to resolve (default example.com)
  --interval SEC         seconds between healthy checks (default 10)
  --fail-threshold N     consecutive failures before reconnect (default 3)
  --max-backoff SEC      max backoff seconds (default 300)
  --device DEV           target device (default first active Wi-Fi)
  --lock PATH            lock file path
  --log PATH             append log to file (default stderr only)
  --once                 run one cycle then exit
  --dry-run              print actions, do not touch nmcli
  -h, --help             display this message
  -V, --version          display version
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

# ---------- defaults ----------
PING_HOST="${NMDEFIB_PING_HOST:-1.1.1.1}"
DNS_HOST="${NMDEFIB_DNS_HOST:-1.1.1.1}"
DNS_NAME="${NMDEFIB_DNS_NAME:-example.com}"
INTERVAL="${NMDEFIB_INTERVAL:-10}"
FAIL_THRESHOLD="${NMDEFIB_FAIL_THRESHOLD:-3}"
MAX_BACKOFF="${NMDEFIB_MAX_BACKOFF:-300}"
DEVICE="${NMDEFIB_DEVICE:-}"
LOCK="${NMDEFIB_LOCK:-/run/lock/nmdefib.lock}"
LOG_FILE="${NMDEFIB_LOG:-}"
ONCE=0
DRY_RUN=0

parse_args() {
	while [[ $# -gt 0 ]]; do
		case "$1" in
		--ping-host)
			PING_HOST="$2"
			shift 2
			;;
		--dns-host)
			DNS_HOST="$2"
			shift 2
			;;
		--dns-name)
			DNS_NAME="$2"
			shift 2
			;;
		--interval)
			INTERVAL="$2"
			shift 2
			;;
		--fail-threshold)
			FAIL_THRESHOLD="$2"
			shift 2
			;;
		--max-backoff)
			MAX_BACKOFF="$2"
			shift 2
			;;
		--device)
			DEVICE="$2"
			shift 2
			;;
		--lock)
			LOCK="$2"
			shift 2
			;;
		--log)
			LOG_FILE="$2"
			shift 2
			;;
		--once)
			ONCE=1
			shift
			;;
		--dry-run)
			DRY_RUN=1
			shift
			;;
		-h | --help)
			usage
			exit 0
			;;
		-V | --version)
			echo "${script_version}"
			exit 0
			;;
		*) die "unknown option: $1" ;;
		esac
	done
}

log() {
	local msg
	msg="$(date '+%Y-%m-%dT%H:%M:%S') $*"
	if command -v gum >/dev/null 2>&1; then
		gum log --level=info "$msg"
	else
		printf '%s\n' "$msg" >&2
	fi
	if [[ -n $LOG_FILE ]]; then
		printf '%s\n' "$msg" >>"$LOG_FILE"
	fi
}

require-commands nmcli ping flock

FAIL_REASON=""

check_connectivity() {
	FAIL_REASON=""
	if ! ping -c 1 -W 2 "$PING_HOST" >/dev/null 2>&1; then
		FAIL_REASON="ping $PING_HOST failed"
		return 1
	fi
	if [[ -n $DNS_HOST ]]; then
		if ! getent hosts "$DNS_NAME" >/dev/null 2>&1 &&
			! (command -v dig >/dev/null 2>&1 && dig +time=2 +tries=1 "@$DNS_HOST" "$DNS_NAME" >/dev/null 2>&1); then
			FAIL_REASON="DNS resolution of $DNS_NAME failed"
			return 1
		fi
	fi
	return 0
}

resolve_connection() {
	local uuid name ctype dev state
	while IFS=: read -r uuid name ctype dev state; do
		[[ $ctype == *wireless* || $ctype == "wifi" ]] || continue
		if [[ -n $DEVICE && $dev != "$DEVICE" ]]; then
			continue
		fi
		if [[ $state == "activated" || -z $state ]]; then
			printf '%s|%s|%s\n' "$uuid" "$name" "$dev"
			return 0
		fi
	done < <(nmcli -t -f UUID,NAME,TYPE,DEVICE,STATE connection show --active 2>/dev/null || true)
	return 1
}

reconnect() {
	local info uuid name dev attempt
	info="$(resolve_connection)" || {
		log "Warning: no active Wi-Fi connection found"
		return 1
	}
	IFS='|' read -r uuid name dev <<<"$info"
	log "Restarting Wi-Fi connection '$name' ($uuid) on $dev"
	if [[ $DRY_RUN -eq 1 ]]; then
		log "dry-run: would reconnect $uuid"
		return 0
	fi
	for attempt in 1 2 3; do
		nmcli connection down "$uuid" >/dev/null 2>&1 || true
		sleep 2
		if nmcli connection up "$uuid" >/dev/null 2>&1; then
			sleep 2
			if nmcli -t -f GENERAL.STATE device show "$dev" 2>/dev/null | grep -qi 'connected'; then
				log "Reconnect succeeded (attempt $attempt)"
				return 0
			fi
		fi
		log "Reconnect attempt $attempt failed"
		sleep $((attempt * 2))
	done
	return 1
}

main() {
	parse_args "$@"

	exec 9>"$LOCK"
	if ! flock -n 9; then
		log "Another instance is running; exiting"
		exit 0
	fi

	trap 'log "Signal received, exiting"; exit 0' INT TERM HUP

	log "Starting nmdefib: watching connectivity to $PING_HOST (Wi-Fi device: ${DEVICE:-auto})"
	if info="$(resolve_connection 2>/dev/null)"; then
		IFS='|' read -r _uuid conn_name _dev <<<"$info"
		log "Monitoring connection '$conn_name'"
	fi

	local failures=0 backoff=0
	while true; do
		if check_connectivity; then
			if [[ $failures -gt 0 ]]; then
				log "Connectivity restored"
			fi
			failures=0
			backoff=0
			if [[ $ONCE -eq 1 ]]; then
				exit 0
			fi
			sleep "$INTERVAL"
			continue
		fi

		failures=$((failures + 1))
		log "Warning: $FAIL_REASON (failure $failures/$FAIL_THRESHOLD)"
		if [[ $failures -lt $FAIL_THRESHOLD ]]; then
			sleep "$INTERVAL"
			continue
		fi

		if ! reconnect; then
			backoff=$((backoff == 0 ? 10 : backoff * 2))
			if [[ $backoff -gt $MAX_BACKOFF ]]; then
				backoff="$MAX_BACKOFF"
			fi
			log "Reconnect failed; backing off ${backoff}s"
			sleep "$backoff"
			failures=0
			if [[ $ONCE -eq 1 ]]; then
				exit 1
			fi
			continue
		fi

		failures=0
		backoff=0
		if [[ $ONCE -eq 1 ]]; then
			exit 0
		fi
		sleep "$INTERVAL"
	done
}

main "$@"
