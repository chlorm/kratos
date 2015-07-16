# This file is part of Kratos.
# Copyright (c) 2014-2015, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

function HaskellDirs {

  case "$(OsKernel)" in
    'darwin')
      EnsureDirExists "${HOME}/Library/Haskell/bin" || return 1
      ;;
    *)
      EnsureDirExists "${HOME}/.cabal/bin" || return 1
      ;;
  esac

  return 0

}

function HaskellBinPath {

  case "$(OsKernel)" in
    'darwin')
      PathAdd "${HOME}/Library/Haskell/bin" || return 1
      ;;
    *)
      PathAdd "${HOME}/.cabal/bin" || return 1
      ;;
  esac

  return 0

}
