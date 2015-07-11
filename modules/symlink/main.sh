# This file is part of Kratos.
# Copyright (c) 2014-2015, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

symlink() { # Create a symbolic link $1 -> $2

  mkdir -p "$(dirname "$2")"
  if [ "$(readlink -f "$2")" != "$1" ] ; then
    rm -rf "$2"
    if [ -f "$1" ] || [ -d "$1" ] ; then
      ln -sf "$1" "$2" 2> /dev/null || return 1
    else
      return 1
    fi
  fi

  return 0

}
