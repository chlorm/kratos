# This file is part of Kratos.
# Copyright (c) 2014-2015, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

array_from_str() { # Creates an array from the name of the variable and values

  ([ "$#" -lt "1" ] || [ "$#" -gt "2" ]) && return 1

  # Read in the array data
  local DATA

  if [ "$#" -eq "1" ] ; then
    DATA="$(cat -)"
  else
    DATA="$2"
  fi

  # Convert the data into an array
  array_new $1
  for I in $DATA ; do
    array_append $1 "$I"
  done

}

array_append() { # Unique array functions with indicies starting at 0

  eval "$1$(array_size $1)=\"$2\"; $1=$(expr $(array_size $1) + 1)"

}

array_new() {

  eval "$1=0"

}

array_at() {

  eval "echo \"\${$1$2}\""

}

array_size() {

  eval "echo \${$1}"

}

path_hasbin() { # Test to see if a binary exists in the path

  [ "$#" -ne "1" ] && return 2
  type $1 > /dev/null 2>&1 || return 1

}
