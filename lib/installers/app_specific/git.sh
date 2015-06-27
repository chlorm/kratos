# This file is part of Kratos.
# Copyright (c) 2014-2015, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

app_git_installed() {

  path_hasbin "git" > /dev/null || return 1

  return 0

}

app_git_dotfiles() {

  exist -fx "$HOME/.gitconfig"

(cat <<GITCONFIG
[user]
    email = $GIT_EMAIL
    name = $GIT_NAME
[push]
    default = simple

GITCONFIG
) > "$HOME/.gitconfig" || return 1

  return 0

}

app_git_configure() {

  app_git_installed || return 2

  app_git_dotfiles || return 1

  return 0

}
