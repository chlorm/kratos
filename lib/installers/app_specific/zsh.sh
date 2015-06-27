# This file is part of Kratos.
# Copyright (c) 2014-2015, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

app_zsh_installed() {

  path_hasbin "zsh" || return 1

  return 0

}

app_zsh_dotfiles() {

  exist -fx "$HOME/.zshrc" "$HOME/.zlogout" "$HOME/.zprofile"

  dotfile_ln "zshrc" || return 1

(
cat <<ZLOGOUT
#!/usr/bin/env zsh

ZLOGOUT
) > "$HOME/.zlogout" || return 1

(
cat <<ZPROFILE
#!/usr/bin/env zsh

ZPROFILE
) > "$HOME/.zprofile" || return 1

  return 0

}

app_zsh_cleanup() {

  exist -fx "$HOME/.zshrc" "$HOME/.zlogout" "$HOME/.zprofile"

}

app_zsh_configure() {

  app_zsh_installed || return 2

  app_zsh_dotfiles || return 1

  return 0

}
