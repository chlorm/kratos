# This file is part of Kratos.
# Copyright (c) 2014-2016, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

Editor::KnownExecutables() {
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
    if Path::Check "${Bin}" ; then
      echo "${Bin}"
      return 0
    fi
  done

  Debug::Message 'error' 'no editors installed'
  return 1
}

Editor::DefaultArgs() {
  local DefaultArgs
  local Editor

  if [ -n "${KRATOS_PREFERRED_EDITOR}" ] ; then
    Editor="${KRATOS_PREFERRED_EDITOR}"
  else
    Editor="$(Editor::KnownExecutables)"
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
}

Editor::Preferred() {
  local PreferredEditor

  for PreferredEditor in "${KRATOS_EDITOR_PREFERENCE[@]}" ; do
    if Path::Check "${PreferredEditor}" ; then
      echo "KRATOS_PREFERRED_EDITOR=\"${PreferredEditor}\"" >> \
        "${HOME}/.local/share/kratos/preferences"
      return 0
    fi
  done

  Debug::Message 'error' 'no preferred editors found'
  return 1
}

Editor::EnvVar() {
  if [[ -z "${KRATOS_PREFERRED_EDITOR}" ]] ; then
    KRATOS_PREFERRED_EDITOR="$(Editor::KnownExecutables)"
  fi

  if [[ -z "${KRATOS_EDITOR_ARGS}" ]] ; then
    KRATOS_EDITOR_ARGS="$(Editor::DefaultArgs)"
  fi

  export EDITOR="${KRATOS_PREFERRED_EDITOR}${KRATOS_EDITOR_ARGS:+ ${KRATOS_EDITOR_ARGS}}"
  export VISUAL="${EDITOR}"
}
