#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-3.0-or-later
# shellcheck shell=bash
# Name: nmdefib
# Version: 1.0.0
# License: GPL-3.0-or-later
# Author: Pierre-Yves Landuré (@landure)
# Description: defibrillate blocked NetworkManager connection by disconnecting and reconnecting

trap ctrl_c INT

ctrl_c() {
	echo "Ctrl + C detected, exiting"
	exit 0
}

# public_ip_address=$(curl --silent 'https://ifconfig.me/ip' || echo 'google.com')
healthcheck_ip="140.82.121.4"
active_connection="$(nmcli connection show --active | grep wifi)"
active_connection_name="$(echo "${active_connection}" | awk '{ print $1 }')"
active_connection_id="$(echo "${active_connection}" | awk '{ print $2 }')"
active_connection_type="$(echo "${active_connection}" | awk '{ print $3 }')"

echo "Keeping ${active_connection_type} connection '${active_connection_name}' alive by checking '${healthcheck_ip}'." >&2

while true; do
	if ping -c 1 -w 1 "${healthcheck_ip}" >'/dev/null'; then
		continue
	fi
	echo "$(date): Warning: Internet is down, restarting ${active_connection_type} connection '${active_connection_name}'." >&2
	nmcli connection down "${active_connection_id}" || true
	nmcli connection up "${active_connection_id}"

	sleep 60
done
