# This file is part of Kratos.
# Copyright (c) 2014-2016, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

Base64::Encode() {
  if [ -z "${@}" ] ; then
    Debug::Message 'error' 'no input'
    return 1
  fi

  echo -n "${@}" | base64
}

Base64::Decode() {
  if [ -z "${@}" ] ; then
    Debug::Message 'error' 'no input'
    return 1
  fi

  echo -n "${@}" | base64 --decode
}
