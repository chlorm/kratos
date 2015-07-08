# This file is part of Kratos.
# Copyright (c) 2014-2015, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

# A POSIX-shell compliant array implementation

array() {

  local ARRAY="$1" ; shift

  case "$1" in
  	'at') # Contents of an array at a given point
      shift
      eval echo \"\${$ARRAY$1}\"
      ;;
    'destroy') # Destroy an array
      local ITTR=0
      local ARRAY_SIZE=$(($(array "$ARRAY" size) + 1))

      while [ $ITTR -le $ARRAY_SIZE ] ; do
      	eval unset "$ARRAY$ITTR"
      	eval unset "$ARRAY"
      done
      ;;
  	'empty') # Destroy and recreate new array with the same name
      shift
      array "$ARRAY" 'destroy'
      array "$ARRAY" 'new'
      ;;
    'from-string') # Create an array from a space delimited string
      shift
      ;;
    'new') # Create a new empty array
      shift
      ;;
    'size') # Size of an array
      echo $ARRAY
      ;;
  esac

  return 0

}