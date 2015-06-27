# This file is part of Kratos.
# Copyright (c) 2014-2015, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

app_neovim_installed() {

  path_hasbin "nvim" > /dev/null || return 1

  return 0

}

app_neovim_dotfiles() {

  dotfile_ln "nvim" || return 1
  dotfile_ln "nvimrc" || return 1

  return 0

}

app_neovim_cleanup() {

  exist -dx "$HOME/.nvim"
  exist -fx "$HOME/.nvimrc"

}

app_neovim_configure() {

  app_neovim_installed || return 2

  exist -dx "$HOME/.nviminfo" || return 1

  app_neovim_dotfiles || return 1

  return 0

}
