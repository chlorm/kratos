# This file is part of Kratos.
# Copyright (c) 2014-2015, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

app_sublime_installed() {

  path_hasbin "sublime" > /dev/null || return 1

  return 0

}

app_sublimetext_cleanup() {

  return 0

}

app_sublimetext_configure() {

  app_sublime_installed || return 2

  dotfile_ln "config/sublime-text-3" || return 1

  return 0

}
