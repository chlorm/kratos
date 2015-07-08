# This file is part of Kratos.
# Copyright (c) 2014-2015, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

function fbterm_tty {

  path_hasbin "fdterm" || return 0

  if [ "$(tty|grep -o '/dev/tty')" == '/dev/tty' ] ; then
    fbterm || return 1
    exit
  fi

  return 0

}
