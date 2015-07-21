# This file is part of Kratos.
# Copyright (c) 2014-2015, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

function GoLangDirs {

  EnsureDirExists "${KRATOS_GOPATH}/bin" || return 1
  EnsureDirExists "${KRATOS_GOPATH}/pkg" || return 1
  EnsureDirExists "${KRATOS_GOPATH}/src" || return 1

  return 0

}

function GoLangBinPath {

  if [[ -n "${GOPATH}" && "${GOPATH}" != "${KRATOS_GOPATH}" ]] ; then
    # TODO: sanitize $GOPATH in case it contains multiple PATHs
    # Output paths to an array and iterate throught the array elements
    PathAdd "${GOPATH}/bin" || {
      ErrWarn 'failed to configure $GOPATH'
      return 1
    }
    export GOPATH="${GOPATH}"
  elif [ -d "${KRATOS_GOPATH}/bin" ] ; then
    PathAdd "${KRATOS_GOPATH}/bin" || {
      ErrWarn 'failed to configure $GOPATH'
      return 1
    }
    export GOPATH="${KRATOS_GOPATH}"
  fi

  return 0

}

function GoLangGoPath {

  if [[ -n "${GOPATH}" ]] ; then
    # TODO: add tests to make sure dirs in $GOPATH exist
    export GOPATH="${GOPATH}"
  else
    export GOPATH="${KRATOS_GOPATH}"
  fi

  return 0

}
