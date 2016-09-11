# This file is part of Kratos.
# Copyright (c) 2014-2016, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

KRATOS::Plugins:haskell.directories() {
  case "$(OS::Kernel)" in
    'darwin')
      Directory::Create "${HOME}/Library/Haskell/bin"
      ;;
    *)
      Directory::Create "${HOME}/.cabal/bin"
      ;;
  esac
}

KRATOS::Plugins:haskell.bin_path() {
  case "$(OS::Kernel)" in
    'darwin')
      Path::Add "${HOME}/Library/Haskell/bin"
      ;;
    *)
      Path::Add "${HOME}/.cabal/bin"
      ;;
  esac
}
