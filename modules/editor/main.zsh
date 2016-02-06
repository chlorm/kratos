# This file is part of Kratos.
# Copyright (c) 2014-2016, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

function EditorKnownExecutables {

  local Bin
  local Bins
  local Editor

  Bins=(
    'atom'
    'subl'
    'sublime'
    'vim'
    'mg'
    'emacs'
    'nano'
    'nvim'
    'vi'
    'yi'
  )

  if [[ -n "${PREFERRED_EDITOR}" ]] ; then
    # find installed editors
    for Bin in "${Bins[@]}" ; do
      if PathHasBin "${Bin}" ; then
        echo "${BIN}"
      fi
    done
  fi

  ErrError 'no editors installed'
  return 1

}

function EditorDefaultArgs {

  local DefaultArgs
  local Editor

  if [[ -n "${KRATOS_PREFERRED_EDITOR}" ]] ; then
    Editor="${KRATOS_PREFERRED_EDITOR}"
  else
    Editor="$(EditorKnownExecutables)"
  fi

  if [[ "${Editor}" == 'atom' ]] ; then
    echo '--wait'
  elif [[ "${Editor}" == 'subl' || "${Editor}" == 'sublime' ]] ; then
    echo '-n -w'
  elif [[ "${Editor}" == 'emacs' ]] ; then
    echo '-nw'
  fi

  return 0

}

function EditorPreferred {

  local PreferredEditor

  for PreferredEditor in "${KRATOS_EDITOR_PREFERENCE[@]}" ; do
    if PathHasBin "${PreferredEditor}" ; then
      echo "KRATOS_PREFERRED_EDITOR=\"${PreferredEditor}\"" >> "${HOME}/.local/share/kratos/preferences"
      return 0
    fi
  done

  ErrWarn 'no preferred editors found'
  return 1

}

function EditorEnvVar {

  if [[ -z "${KRATOS_PREFERRED_EDITOR}" ]] ; then
    KRATOS_PREFERRED_EDITOR="$(EditorKnownExecutables)"
  fi

  if [[ -z "${KRATOS_EDITOR_ARGS}" ]] ; then
    KRATOS_EDITOR_ARGS="$(EditorDefaultArgs)"
  fi

  export EDITOR="${KRATOS_PREFERRED_EDITOR}${KRATOS_EDITOR_ARGS:+ ${KRATOS_EDITOR_ARGS}}"

}
