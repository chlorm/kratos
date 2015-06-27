# This file is part of Kratos.
# Copyright (c) 2014-2015, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

app_sh_installed() {

  path_hasbin "sh" || {
  	path_hasbin "dash" || return 1
  } || return 1

  return 0

}

app_sh_dotfiles() {

  exist -fx "$HOME/.profile"

  dotfile_ln "profile"

  return 0

}

app_sh_cleanup() {

  exist -fx "$HOME/.profile"

}

app_sh_configure() {

  app_sh_installed || return 1

  app_sh_dotfiles || return 1

  return 0

}
