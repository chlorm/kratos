# This file is part of Kratos.
# Copyright (c) 2014-2015, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

app_gvim_installed() {

  path_hasbin "gvim" > /dev/null || return 1

  return 0

}

app_gvim_dotfiles() {

  exist -fx "$HOME/,gvimrc"

  dotfile_ln "gvimrc" || return 1

  return 0

}

app_gvim_cleanup() {

  exist -fx "$HOME/.gvimrc"

}

app_gvim_configure() {

  app_gvim_installed || return 2

  app_gvim_dotfiles || return 1

  return 0

}
