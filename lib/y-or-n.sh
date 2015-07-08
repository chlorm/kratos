# This file is part of Kratos.
# Copyright (c) 2014-2015, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

y_or_n() { # Ask a yes or no question

  local ANSWER
  local DEFAULT=2
  local PROMPT

  case "$2" in
    '')
      DEFAULT=2
      PROMPT="(y/n)"
      ;;
    'y')
      DEFAULT=0
      PROMPT="(Y/n)"
      ;;
    'n')
      DEFAULT=1
      PROMPT="(y/N)"
      ;;
    *)
      DEFAULT=2
      PROMPT="(y/n)"
      ;;
  esac

  while true ; do
    read -p "$1 $PROMPT: " ANSWER

    ANSWER="$(tolower $ANSWER)"

    case "$ANSWER" in
      '')
        if [ ! $DEFAULT -eq 2 ] ; then
          return $DEFAULT
        fi
        ;;
      'y'|'yes')
        break && return 0
        ;;
      'n'|'no')
        break && return 1
        ;;
    esac

    echo "WARNING: Response must be y/n or yes/no, try again"
  done

  return 2

}
