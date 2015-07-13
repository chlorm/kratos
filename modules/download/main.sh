# This file is part of Kratos.
# Copyright (c) 2014-2015, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

function download { # Find download utility on system

  if PathHasBin "curl" ; then
      curl -sOL "$@" && return 0
  elif PathHasBin "wget" ; then
      wget "$@" && return 0
  elif PathHasBin "fetch" ; then
      fetch "$@" && return 0
  else
    ErrError "no download utility found"
    return 1
  fi

  ErrError "unable to download file"
  return 1

}
