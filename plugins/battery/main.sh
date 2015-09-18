# This file is part of Kratos.
# Copyright (c) 2014-2015, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

function bat {

  # Use acpi if possible

  acpi -b 2> /dev/null || BatSys

}

function BatSys {

  # Gets the string representing the state of the batteries

  local BAT
  local BATS

  [ -d "${ROOT}/sys/class/power_supply" ] || return 1

  BATS=($(ls "${ROOT}/sys/class/power_supply" | grep "^BAT"))

  for BAT in "${BATS[@]}" ; do
    BatOne "${BAT}"
  done

}

function BatOne {

  local BAT_DIR
  local B
  local NOW
  local FULL

  BAT_DIR="${ROOT}/sys/class/power_supply/$1"
  B=="$(cat "${BAT_DIR}/status" 2> /dev/null)"

  echo -n "${1}: "

  case "${B}" in
    Charging)
      echo -n "↑"
      ;;
    Discharging)
      echo -n "↓"
      ;;
    *)
      echo -n "⚡"
      ;;
  esac

  NOW="$(cat "${BAT_DIR}"/charge_now 2> /dev/null || cat "${BAT_DIR}"/energy_now 2> /dev/null || echo -1)"
  FULL="$(cat "${BAT_DIR}"/charge_full 2> /dev/null || cat "${BAT_DIR}"/energy_full 2> /dev/null || echo 1)"
  echo "$(expr ${NOW} \* 100 / $FULL)%"

}
