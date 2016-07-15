# This file is part of Kratos.
# Copyright (c) 2014-2015, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

KRATOS::Plugins:fbterm.tty() {
  KRATOS::Lib:path.has_bin 'fdterm' || return 0

  if [[ "$(tty | grep -o '/dev/tty')" == '/dev/tty' ]] ; then
    fbterm
    exit
  fi
}