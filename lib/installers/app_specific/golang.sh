# This file is part of Kratos.
# Copyright (c) 2014-2015, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

app_golang_installed() {

  path_hasbin "go" > /dev/null || return 1

  return 0

}

app_golang_dirs() {

  exist -dc "$HOME/.go/bin" "$HOME/.go/src" || return 1

  return 0

}

app_golang_cleanup() {

  exist -dx "$HOME/.go"

}

app_golang_configure() {

  app_golang_installed || return 2

  app_golang_dirs || return 1

  return 0

}
