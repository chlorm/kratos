# This file is part of Kratos.
# Copyright (c) 2014-2015, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

function PathAdd { # Add direcory to $PATH

  if [[ -z "$(echo "${PATH}" | grep "${1}" 2> /dev/null)" && -d "${1}" ]] ; then
    export PATH="${PATH}:${1}"
  fi

  return 0

}

function PathRemove { # Remove directory from $PATH

  if [ -n "$(echo "$PATH" | grep "$1" 2> /dev/null)" ] ; then
    export PATH=`echo -n $PATH | awk -v RS=: -v ORS=: '$0 != "'$1'"' | sed 's/:$//'`
  fi

  return 0

}

function PathBin { # Finds the path to the binary

  if [ "$#" -ne 1 ] ; then
    return 2
  fi

  path.hasbin "$1" > /dev/null 2>&1 && type "$1" | awk '{print $3 ; exit}' && return 0

  return 1

}

function PathBinAbs { # Resolves the absolute path of the binary

  local BIN

  BIN="$(whereis -b $1 2> /dev/null | awk '{print $2}')"

  [ -n "$BIN" ] || return 1

  echo "$BIN"

  return 0

}

function PathHasBin { # Test to see if a binary exists in the path

  [ "$#" -ne "1" ] && return 2

  case "$(shell)" in
    'bash')
      type "${1}" > /dev/null 2>&1 || return 1
      ;;
    'ksh'|'pdksh'|'zsh')
      whence -p "${1}" > /dev/null 2>&1 || return 1
      ;;
    *)
      err.error "Not reporting a supported shell" "${FUNCNAME[1]}"
      return 1
      ;;
  esac

  return 0

}

function PathHasbinErr {

  path.hasbin "${1}" || {
    err.error "\`${1}' is not installed" "${FUNCNAME[1]}"
    return 1
  }

  return 0

}
