# This file is part of Kratos.
# Copyright (c) 2014-2015, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

# TODO:
# + Set the TERM environment variable to allow color support if terminal
#    supports color
# + Make sure the terminal module is executed before color-conv

# dumb, screen, xterm, vt100, color, ansi, cygwin, linux

# if isTTY, then try fbterm else false

if [ "$TERM" == 'xterm' ] ; then
  # See if xterm supports 256 color
  if [ -n "$VTE_VERSION" ] ; then
    export "xterm-256color"
  fi
fi
