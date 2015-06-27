# This file is part of Kratos.
# Copyright (c) 2014-2015, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

app_emacs_installed() {

  path_hasbin "emacs" > /dev/null  || return 1

  return 0

}

app_emacs_dotfiles() {

  dotfile_ln "emacs.d" || return 1

  return 0

}

app_emacs_cleanup() {

  exist -dx "$HOME/.emacs.d"

}

app_emacs_configure() {

  app_emacs_installed || return 2

  app_emacs_dotfiles || return 1

  return 0

}
