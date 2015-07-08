# This file is part of Kratos.
# Copyright (c) 2014-2015, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

path_add() { # Add direcory to $PATH

  if [ -z "$(echo "$PATH" | grep "$1" 2> /dev/null)" ] ; then
    export PATH="${PATH}:$1"
  fi

}

path_remove()  { # Remove directory from $PATH

  if [ -n "$(echo "$PATH" | grep "$1" 2> /dev/null)" ] ; then
    export PATH=`echo -n $PATH | awk -v RS=: -v ORS=: '$0 != "'$1'"' | sed 's/:$//'`
  fi

}
