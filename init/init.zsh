# This file is part of Kratos.
# Copyright (c) 2014-2016, Cody Opel <codyopel@gmail.com>.
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

if [[ "$(KRATOS::Lib:shell)" != 'zsh' ]] && type zsh > /dev/null ; then
  exec zsh --interactive
  exit $?
fi

if [[ -z ${KRATOS_SHELL_INIT+x} ]] ; then
  KRATOS::Lib:load.all 'main'
  if [[ ! -f "${HOME}/.cache/KRATOS_START" ]] ; then
    KRATOS::Lib:load.all 'start'
    touch "${HOME}/.cache/KRATOS_START"
  fi
  [[ ${KRATOS_IS_LOGIN_SHELL} ]] && KRATOS::Lib:load.all 'login'
  [[ -o interactive ]] && KRATOS::Lib:load.all 'interactive'

  KRATOS::Lib:path.add "${HOME}/.bin"

  KRATOS_CURRENT_KERNEL="$(KRATOS::Lib:os.kernel)"
  KRATOS_CURRENT_LINUX="$(KRATOS::Lib:os.linux)"
  KRATOS_CURRENT_SHELL="$(KRATOS::Lib:shell)"

  KRATOS_SHELL_INIT=true
fi
