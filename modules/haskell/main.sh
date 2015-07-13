# This file is part of Kratos.
# Copyright (c) 2014-2015, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

function HaskellBin {

  path.hasbin "ghc" || return 0

  if [[ "$(os.kernel)" == 'darwin' ]] ; then
    PathAdd "$HOME/Library/Haskell/bin" || return 1
  else
    PathAdd "$HOME/.cabal/bin" || return 1
  fi

  return 0

}
