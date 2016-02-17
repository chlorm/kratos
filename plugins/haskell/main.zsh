# This file is part of Kratos.
# Copyright (c) 2014-2016, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

KRATOS::Plugins:haskell.directories() {
  case "$(KRATOS::Lib:os.kernel)" in
    'darwin')
      EnsureDirExists "${HOME}/Library/Haskell/bin" || return 1
      ;;
    *)
      EnsureDirExists "${HOME}/.cabal/bin" || return 1
      ;;
  esac

  return 0
}

KRATOS::Plugins:haskell.bin_path() {
  case "$(KRATOS::Lib:os.kernel)" in
    'darwin')
      path_add "${HOME}/Library/Haskell/bin" || return 1
      ;;
    *)
      path_add "${HOME}/.cabal/bin" || return 1
      ;;
  esac

  return 0
}
