# This file is part of Kratos.
# Copyright (c) 2014-2015, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

export BLOCKSIZE='K'

function p_and_q {

  local STAT

  STAT="${1}" ; shift
  echo $@
  exit $STAT

}

function termclr {

  case "$1" in
    'black')
      if [ "$2" -eq 0 ] ; then
        echo -n '\e[0;30m'
      else
        echo -n '\e[1;30m'
      fi
      ;;
    'blue')
      if [ "$2" -eq 0 ] ; then
        echo -n '\e[0;34m'
      else
        echo -n '\e[1;34m'
      fi
      ;;
    'cyan')
      if [ "$2" -eq 0 ] ; then
        echo -n '\e[0;36m'
      else
        echo -n '\e[1;36m'
      fi
      ;;
    'green')
      if [ "$2" -eq 0 ] ; then
        echo -n '\e[0;32m'
      else
        echo -n '\e[1;32m'
      fi
      ;;
    'magenta')
      if [ "$2" -eq 0 ] ; then
        echo -n '\e[0;35m'
      else
        echo -n '\e[1;35m'
      fi
      ;;
    'red')
      if [ "$2" -eq 0 ] ; then
        echo -n '\e[0;31m'
      else
        echo -n '\e[1;31m'
      fi
      ;;
    'white')
      if [ "$2" -eq 0 ] ; then
        echo -n '\e[0;37m'
      else
        echo -n '\e[1;37m'
      fi
      ;;
    'yellow')
      if [ "$2" -eq 0 ] ; then
        echo -n '\e[0;33m'
      else
        echo -n '\e[1;33m'
      fi
      ;;
    'underline')
      echo -n '\033[0;4m'
      ;;
    'reset')
      echo -n '\e[0m'
      ;;
    *)
      echo -n '\e[0m'
      ;;
  esac

}

function dotfiles_dir {

  echo "$DOTFILES_DIR" && return 0

  return 1

}

function kratos_dir {

  echo "$KRATOS_DIR" && return 0

  return 1

}
