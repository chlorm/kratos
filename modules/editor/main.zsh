# This file is part of Kratos.
# Copyright (c) 2014-2016, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

KRATOS::Modules:editor.known_executables() {
  local Bin
  local -a Bins
  local Editor

  Bins=(
    'atom'
    'emacs'
    'mg'
    'subl'
    'sublime'
    'nano'
    'nvim'
    'vi'
    'vim'
    'yi'
  )

  # find installed editors
  for Bin in "${Bins[@]}" ; do
    KRATOS::Lib:path.has_bin "${Bin}" && {
      echo "${Bin}"
      return 0
    }
  done

  KRATOS::Lib:err.error 'no editors installed'
  return 1
}

KRATOS::Modules:editor.default_args() {
  local DefaultArgs
  local Editor

  if [[ -n "${KRATOS_PREFERRED_EDITOR}" ]] ; then
    Editor="${KRATOS_PREFERRED_EDITOR}"
  else
    Editor="$(KRATOS::Modules:editor.known_executables)"
  fi

  case "${Editor}" in
    'atom')
      echo '--new-window --wait'
      ;;
    'emacs')
      echo '--no-window-system'
      ;;
    'subl'|'sublime'|'sublime_text'|'sublime-text')
      echo '--new-window --wait'
      ;;
  esac

  return 0
}

KRATOS::Modules:editor.preferred() {
  local PreferredEditor

  for PreferredEditor in "${KRATOS_EDITOR_PREFERENCE[@]}" ; do
    if KRATOS::Lib:path.has_bin "${PreferredEditor}" ; then
      echo "KRATOS_PREFERRED_EDITOR=\"${PreferredEditor}\"" >> \
        "${HOME}/.local/share/kratos/preferences"
      return 0
    fi
  done

  KRATOS::Lib:err.warn 'no preferred editors found'
  return 1
}

KRATOS::Modules:editor.env_var() {
  if [[ -z "${KRATOS_PREFERRED_EDITOR}" ]] ; then
    KRATOS_PREFERRED_EDITOR="$(KRATOS::Modules:editor.known_executables)"
  fi

  if [[ -z "${KRATOS_EDITOR_ARGS}" ]] ; then
    KRATOS_EDITOR_ARGS="$(KRATOS::Modules:editor.default_args)"
  fi

  export EDITOR="${KRATOS_PREFERRED_EDITOR}${KRATOS_EDITOR_ARGS:+ ${KRATOS_EDITOR_ARGS}}"
  export VISUAL="${EDITOR}"
}
