# This file is part of Kratos.
# Copyright (c) 2014-2016, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

# Currently only works with single wireless card (picks first one found)

# TODO:
# Add multi adapter support
# Add wpa_supplicant support
# Maybe convert wifi -> net (lan,wan,wlan, etc...)

# Find wireless interface name
Wifi::Interface() {
  nmcli d | awk '/wifi/ {print $1 ; exit}'
}

Wifi::Usage() {
cat <<'EOF'
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

Wifi::Command() {
  local Pass
  local Ssid

  ${PathHasBinNMCLI}

  case "${1}" in
    '')
      Wifi::Usage
      Debug::Message 'error' 'no input provided'
      return 1
      ;;
    'list') # List saved connections
      nmcli d wifi list
      ;;
    'connections')
      nmcli c
      ;;
    'add') # Add a saved connection
      shift
      Pass="${2}"
      Ssid="${1}"
      # If no password is provided, assume one is not needed
      if [ -n "${2}" ] ; then
        Pass="password ${2}"
      fi
      # Add connection
      nmcli \
        d wifi \
        connect "${Ssid}" ${Pass} \
        ifname "$(Wifi::Interface)" \
        name "${Ssid}" || {
          Debug::Message 'error' "connecting to ${Ssid}"
          return 1
        }
      ;;
    'connect') # Connect to a saved connection
      shift
      Ssid="${1}"
      nmcli c up id "${Ssid}"
      ;;
    'disconnect') # Disconnect from current wireless network
      nmcli d disconnect iface "$(Wifi::Interface)"
      ;;
    'remove') # Remove a saved connection
      shift
      Ssid="${1}"
      nmcli c delete id "${Ssid}"
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
      Wifi::Usage
      ;;
    *)
      Wifi::Usage
      Debug::Message 'error' "invalid option: $@"
      ;;
  esac
}
