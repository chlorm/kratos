# This file is part of Kratos.
# Copyright (c) 2014-2015, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

#if [ -z "KRATOS_EDITOR" ] ; then
#  EDITOR="vi"
#else
#  EDITOR="$KRATOS_EDITOR$KRATOS_EDITOR_ARGS"
#fi

#export EDITOR

function EditorKnownExecutables {

  local Editor

  if [[ -n "${PREFERRED_EDITOR}" ]] ; then
    # find installed editors
    echo
  fi

  echo "${Editor}"

}

function EditorPreferred {

  local PreferredEditor

  for PreferredEditor in "${KRATOS_EDITOR_PREFERENCE[@]}" ; do
    if PathHasBin "${PreferredEditor}" ; then
      echo "KRATOS_PREFERRED_EDITOR=\"${PreferredEditor}\"" >> "${HOME}/.local/share/kratos/preferences"
      return 0
    fi
  done

  ErrWarn "no preferred editors found"
  return 1

}
