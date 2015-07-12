# This file is part of Kratos.
# Copyright (c) 2014-2015, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

download() { # Find download utility on system

  if path.hasbin "curl" ; then
      curl -sOL "$@" && return 0
  elif path.hasbin "wget" ; then
      wget "$@" && return 0
  elif path.hasbin "fetch" ; then
      fetch "$@" && return 0
  else
    err.error "no download utility found"
    return 1
  fi

  err.error "unable to download file"
  return 1

}
