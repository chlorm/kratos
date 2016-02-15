# This file is part of Kratos.
# Copyright (c) 2014-2016, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

if ${PathHasBinGHC} ; then

  KRATOS::Plugins:haskell.directories

  # Add haskell bin/ directory to $PATH
  KRATOS::Plugins:haskell.bin_path

fi
