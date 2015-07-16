# This file is part of Kratos.
# Copyright (c) 2014-2015, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

# Initalize shell configuration
export KRATOS_DIR="${HOME}/.kratos"
export DOTFILES_DIR="${HOME}/.dotfiles"
. "${HOME}/.local/share/kratos/preferences"

. "${KRATOS_DIR}/lib/core.sh"

if [[ -z ${KRATOS_SHELL_INIT+x} ]] ; then
  . "${KRATOS_DIR}/lib/core.sh"
fi

if [[ "${PREFERRED_SHELL}" != "$(shell)" && -n "${PREFERRED_SHELL}" ]] ; then
  exec "${PREFERRED_SHELL}"
  exit $?
fi

if [[ -z ${KRATOS_SHELL_INIT+x} ]] ; then
  LoadAll 'modules'
  LoadAll 'inits'

  PathAdd "${HOME}/.bin"

  ShellTmp
  ShellTheme
  ShellInit
  PromptConfigure

  KRATOS_SHELL_INIT=true
fi
