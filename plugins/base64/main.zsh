# This file is part of Kratos.
# Copyright (c) 2014-2016, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

KRATOS::Plugins:base64.encode() {

  [[ -n ${1+x} ]] || {
    KRATOS::Lib:err.error 'no input'
    return 1
  }

  echo -n ${1} | base64

}

KRATOS::Plugins:base64.decode() {

  [[ -n ${1+x} ]] || {
    KRATOS::Lib:err.error 'no input'
    return 1
  }

  echo -n ${1} | base64 --decode

}
