# This file is part of Kratos.
# Copyright (c) 2014-2015, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

function haskell_dirs {

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

function haskell_bin_path {

  case "$(os_kernel)" in
    'darwin')
      path_add "${HOME}/Library/Haskell/bin" || return 1
      ;;
    *)
      path_add "${HOME}/.cabal/bin" || return 1
      ;;
  esac

  return 0

}
