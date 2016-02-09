# This file is part of Kratos.
# Copyright (c) 2014-2015, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

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

if [[ "$(shell)" != 'zsh' ]] ; then
  exec 'zsh' # add interactive flags
  exit $?
fi

if [[ -z ${KRATOS_SHELL_INIT+x} ]] ; then
  load_all 'main'
  load_all 'init'

  path_add "${HOME}/.bin"

  KRATOS_CURRENT_KERNEL="$(os_kernel)"
  KRATOS_CURRENT_LINUX="$(os_linux)"
  KRATOS_CURRENT_SHELL="$(shell)"

  KRATOS_SHELL_INIT=true
fi
