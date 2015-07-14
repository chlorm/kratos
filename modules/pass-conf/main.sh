# This file is part of Kratos.
# Copyright (c) 2014-2015, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

function PasswordConfirmation {

  local PASS1
  local PASS2

  while true ; do
    read -s -p "Password: " PASS1
    echo
    read -s -p "Confirm: " PASS2
    echo
    if [ "${PASS1}" = "${PASS2}" ] ; then
      break
    fi
    echo "WARNING: passwords do not match, try again"
  done

  echo "${PASS1}" > /dev/null 2>&1 && return 0

  return 1

}
