# This file is part of Kratos.
# Copyright (c) 2014-2016, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

Golang::Directories() {
  Directory::Create "${KRATOS_GOPATH}/bin"
  Directory::Create "${KRATOS_GOPATH}/pkg"
  Directory::Create "${KRATOS_GOPATH}/src"
}

Golang::BinPath() {
  # Add Go bin/ directory to $PATH

  if [[ -n "${GOPATH}" && "${GOPATH}" != "${KRATOS_GOPATH}" ]] ; then
    # TODO: sanitize $GOPATH in case it contains multiple PATHs
    # Output paths to an array and iterate throught the array elements
    Path::Add "${GOPATH}/bin" || {
      Log::Message 'error' 'failed to configure $GOPATH'
      return 1
    }
    export GOPATH="${GOPATH}"
  elif [ -d "${KRATOS_GOPATH}/bin" ] ; then
    Path::Add "${KRATOS_GOPATH}/bin" || {
      Log::Message 'error' 'failed to configure $GOPATH'
      return 1
    }
    export GOPATH="${KRATOS_GOPATH}"
  fi
}

Golang::GoPath() {
  if [ -n "${GOPATH}" ] ; then
    # TODO: add tests to make sure dirs in $GOPATH exist
    export GOPATH="${GOPATH}"
  else
    export GOPATH="${KRATOS_GOPATH}"
  fi
}
