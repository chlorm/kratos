# This file is part of Kratos.
# Copyright (c) 2014-2015, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

user_root() { # Determine if the user is root

  [ "$(id -u)" -eq 0 ] || return 1

  return 0

}
