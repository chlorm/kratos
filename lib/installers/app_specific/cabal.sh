# This file is part of Kratos.
# Copyright (c) 2014-2015, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

app_cabal_installed() {

  path_hasbin "cabal" > /dev/null || return 1

  return 0

}

app_cabal_dirs() {

  exist -dc "$HOME/.cabal/bin" || return 1

  return 0

}

app_cabal_cleanup() {

  exist -dx "$HOME/.cabal"

}

app_cabal_configure() {

  app_cabal_installed || return 2

  app_cabal_dirs || return 1

  app_cabal_paths || return 1

  return 0

}
