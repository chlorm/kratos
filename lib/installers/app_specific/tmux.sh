# This file is part of Kratos.
# Copyright (c) 2014-2015, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

app_tmux_installed() {

  path_hasbin "tmux" > /dev/null || return 1

  return 0

}

app_tmux_dotfiles() {

  exist -fx "$HOME/tmux.conf"

  dotfile_ln "tmux.conf" || return 1

  return 0

}

app_tmux_cleanup() {

  exist -fx "$HOME/tmux.conf"

}

app_tmux_configure() {

  app_tmux_installed || return 2

  app_tmux_dotfiles || return 1

  return 0

}
