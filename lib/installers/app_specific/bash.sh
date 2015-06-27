# This file is part of Kratos.
# Copyright (c) 2014-2015, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

app_bash_installed() {

  path_hasbin "bash" || return 1

  return 0

}

app_bash_dotfiles() {

  exist -fx "$HOME/.bashrc" "$HOME/.bash_logout" "$HOME/.bash_profile"

  dotfile_ln "bashrc"

  return 0

}

app_bash_cleanup() {

  exist -fx "$HOME/.bashrc" "$HOME/.bash_logout" "$HOME/.bash_profile"

}

app_bash_configure() {

  app_bash_installed || return 1

  app_bash_dotfiles || return 1

  return 0

}
