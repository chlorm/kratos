# This file is part of Kratos.
# Copyright (c) 2014-2015, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

function haskell_bin {

  path_hasbin "ghc" || return 0

  if [[ "$(os_kernel)" == 'darwin' && -d "$HOME/Library/Haskell/bin" ]] ; then
    path_add "$HOME/Library/Haskell/bin" || return 1
  else
    path_add "$HOME/.cabal/bin" || return 1
  fi

  return 0

}
haskell_bin
