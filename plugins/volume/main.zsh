# This file is part of Kratos.
# Copyright (c) 2014-2015, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

# TODO:
# + Support additional sound servers, e.g. alsa, jack, etc...
# + Support multiple audio devices
# + Support input devices
# + Maybe rename to alevel/alev, more agnostic of input and output devices
#    or create seperate utility for handling input devices

function vol_usage {

cat <<EOF
vol is a wrapper for pactl/pacmd

Usage: vol [integer/option]"

    [0-150] - set volume percentage"
    up      - increase volume by \`argument'"
    down    - decrease volume by \`argument'"
    mute    - toggle mute on and off"
    --help  - display this message"

EOF

}

function active_sound_card {

  local SoundCard

  SoundCard=$(
    pactl list sinks |
    grep --before-context=1 "State: RUNNING" |
    awk -F'[^0-9]*' '/Sink\ \#/ {print $2 ; exit}'
  )

  # If no active sound card is found fallback to the default
  [ -z "${SoundCard}" ] && {
    SoundCard=$(
      pacmd list-sinks |
      grep -m 1 "* index: " |
      grep -o '[0-9]*'
    )
  }

  [ -z "${SoundCard}" ] && {
    err_error "failed to obtain sound card"
    return 1
  }

  echo "${SoundCard}"

  return 0

}

function vol_current {

  pactl list sinks |
    grep --after-context=9 "Sink #$(active_sound_card)" |
    grep "Volume:" |
    awk '/[^0-9]*\%/ {print $5 ; exit}'

}

function vol {

  # If 'pactl' is not installed, be done now
  ${PathHasBinPACMD} || return 1
  ${PathHasBinPACTL} || return 1

  # Parse Arguments
  case "${1}" in
    '')
      echo "Volume: $(vol_current)"
      ;;
    [U,u]|[U,u][P,p])
      pactl set-sink-volume $(active_sound_card) -- "+5%"
      ;;
    [D,d]|[D,d][O,o][W,w][N,n])
      pactl set-sink-volume $(active_sound_card) -- "-5%"
      ;;
    [M,m]|[M,m][U,u][T,t][E,e])
      pactl set-sink-mute $(active_sound_card) toggle
      ;;
    [L,l]|[L,l][I,i][S,s][T,t])
      pactl list sinks | grep "Sink #\|alsa.mixer_name"
      ;;
    '--help')
      vol_usage
      return 0
      ;;
    *)
      case $1 in
        [0-9]|[1-9][0-9]|1[0-4][0-9]|150)
          pactl set-sink-volume $(active_sound_card) -- "${1}%"
          ;;
        *)
          vol_usage
          err_error 'must be an integer between 0 and 150'
          return 1
          ;;
      esac
      ;;
  esac

}
