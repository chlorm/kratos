# This file is part of Kratos.
# Copyright (c) 2014-2015, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

app_vim_installed() {

  path_hasbin "vim" > /dev/null || return 1

  return 0

}

app_vim_dotfiles() {

  dotfile_ln "vim" || return 1
  dotfile_ln "vimrc" || return 1

  return 0

}

app_vim_cleanup() {

  exist -dx "$HOME/.vim"
  exist -fx "$HOME/.vimrc"

}

app_vim_configure() {

  app_vim_installed || return 2

  exist -dx "$HOME/.viminfo" || return 1

  app_vim_dotfiles || return 1

  return 0

}
