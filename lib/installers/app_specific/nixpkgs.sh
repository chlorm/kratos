# This file is part of Kratos.
# Copyright (c) 2014-2015, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

app_nixpkgs_installed() {

  path_hasbin "nix-env" > /dev/null || return 1

  return 0

}

app_nixpkgs_dotfiles() {

  dotfile_ln "nixpkgs" || return 1

  return 0

}

app_nixpkgs_cleanup() {

  exist -dx "$HOME/.nixpkgs"

}

app_nixpkgs_configure() {

  app_nixpkgs_installed || return 2

  app_nixpkgs_dotfiles || return 1

  return 0

}
