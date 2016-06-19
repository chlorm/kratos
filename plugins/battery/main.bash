# This file is part of Kratos.
# Copyright (c) 2014-2016, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

Battery::Acpi() {
  # Use acpi if possible

  acpi -b 2> /dev/null || Battery::Sys
}

# Gets the string representing the state of the batteries
Battery::Sys() {
  local Bat
  local Bats

  [ -d "${ROOT}/sys/class/power_supply" ]

  Bats=($(
    ls "${ROOT}/sys/class/power_supply" |
      grep "^BAT"
  ))

  for Bat in "${Bats[@]}" ; do
    Battery::One "${Bat}"
  done
}

Battery::One() {
  local BatDir
  local BatStatus
  local Now
  local Full

  BatDir="${ROOT}/sys/class/power_supply/$1"
  BatStatus="$(cat "${BatDir}/status" 2> /dev/null)"

  echo -n "${1}: "

  case "${BatStatus}" in
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

  Now="$(
    cat "${BatDir}"/charge_now 2> /dev/null || \
    cat "${BatDir}"/energy_now 2> /dev/null || \
    echo -1
  )"
  Full="$(
    cat "${BatDir}"/charge_full 2> /dev/null || \
    cat "${BatDir}"/energy_full 2> /dev/null || \
    echo 1
  )"
  echo "$(expr ${Now} \* 100 / $Full)%"
}
