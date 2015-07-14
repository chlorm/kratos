# This file is part of Kratos.
# Copyright (c) 2014-2015, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

# Currently only works with single wireless card (picks first one found)

# TODO:
# Add multi adapter support
# Add wpa_supplicant support
# Maybe convert wifi -> net (lan,wan,wlan, etc...)

function WirelessInterface { # Find wireless interface name

  nmcli d | awk '/802-11-wireless/ {print $1 ; exit}'

}

function WifiUsage {

cat <<EOF
Wifi is a wrapper for nmcli.

Usage: wifi UTILITY [OPTIONS]

    list           - List available wireless connections
    connections    - List saved connections
    add            - Add a new connection
    connect        - Connect to a saved connection
    disconnect     - Disconnect all active connections
    status         - List active connections
    on             - Turn wireless on
    off            - Turn wireless off
    -h|--help      - print this message

EOF

  return 0

}

function wifi {

  local PASS
  local SSID

  PathHasBinErr 'nmcli' || return 1

  case "${1}" in
    '')
      WifiUsage
      ErrError 'no input provided'
      ;;
    'list') # List saved connections
      nmcli d wifi list
      ;;
    'connections')
      nmcli c
      ;;
    'add') # Add a saved connection
      shift
      PASS="${2}"
      SSID="${1}"
      # If no password is provided, assume one is not needed
      if [ -n "${2}" ]; then
        PASS="password ${2}"
      fi
      # Add connection
      nmcli d wifi connect "${SSID}" ${PASS} iface "$(WirelessInterface)" name "${SSID}" || {
        ErrError "connecting to ${SSID}"
        return 1
      }
      ;;
    'connect') # Connect to a saved connection
      shift
      SSID="${1}"
      nmcli c up id "${SSID}"
      ;;
    'disconnect') # Disconnect from current wireless network
      nmcli d disconnect iface "$(WirelessInterface)"
      ;;
    'remove') # Remove a saved connection
      shift
      SSID="${1}"
      nmcli c delete id "${SSID}"
      ;;
    'status') # List active connections if any
      nmcli g status
      ;;
    'on') # Turn wireless on
      nmcli r wifi on
      ;;
    'off') # Turn wireless off
      nmcli r wifi off
      ;;
    '-h'|'--help'|'help')
      WifiUsage
      ;;
    *)
      WifiUsage
      ErrError "invalid option: $@"
      ;;

  esac

}
