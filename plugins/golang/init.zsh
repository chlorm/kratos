# This file is part of Kratos.
# Copyright (c) 2014-2015, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

if ${PathHasBinGO} ; then

  golang_dirs

  # Add Go bin/ directory to $PATH
  golang_bin_path

  golang_gopath

fi
