# This file is part of Kratos.
# Copyright (c) 2014-2015, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

app_gnome3_installed() {

  path_hasbin "gnome-session" > /dev/null || return 1

  return 0

}

app_gnome3_cleanup() {

  return 0

}

app_gnome3_configure() {

  app_gnome3_installed || return 1

  return 0

}
