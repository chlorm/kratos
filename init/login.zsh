# This file is part of Kratos.
# Copyright (c) 2014-2015, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

# TODO:
# Figure out what should be spawned by login shells
# - Automatic Updater
# - Tmp directory
# - Create a method to determine if login.sh has been run, otherwise run it from
#   init/shell.sh, before executing the contents of shell.sh

# Initalize shell configuration
export KRATOS_DIR="${HOME}/.kratos"
export DOTFILES_DIR="${HOME}/.dotfiles"

if [[ -z ${KRATOS_SHELL_INIT+x} ]] ; then
  source "${KRATOS_DIR}/lib/core.zsh"
  source "${KRATOS_DIR}/lib/DEFAULTS.zsh"
  [[ -f "${HOME}/.local/share/kratos/preferences" ]] && {
    source "${HOME}/.local/share/kratos/preferences"
  }
  [[ -f "${HOME}/.local/share/kratos/is-installed" ]] && {
    source "${HOME}/.local/share/kratos/is-installed"
  }
  [[ -f "${HOME}/.config/kratos/config" ]] && {
    source "${HOME}/.config/kratos/config"
  }
fi

LoadAll 'main'
LoadAll 'login'
