# This file is part of Kratos.
# Copyright (c) 2014-2015, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

function encode64 {

  [[ -n ${1+x} ]] || {
    ErrError 'no input'
    return 1
  }

  echo -n ${1} | base64

}

function decode64 {

  [[ -n ${1+x} ]] || {
    ErrError 'no input'
    return 1
  }

  echo -n ${1} | base64 --decode

}
