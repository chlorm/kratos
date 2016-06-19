# This file is part of Kratos.
# Copyright (c) 2014-2016, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

export BLOCKSIZE='K'

KRATOS::Modules:misc.p_and_q() {
  local STAT

  STAT="${1}" ; shift
  echo $@
  exit $STAT
}
