# This file is part of Kratos.
# Copyright (c) 2014-2015, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

function exist { # Check for existence of file or directory

  [ -n "${1}" ] || return 1

  case "${1}" in
    '-fc') # Make sure the file exists
      shift
      while [ "${1}" ] ; do
        # Make sure file is not a symlink
        if test -L "${1}" ; then
          unlink "${1}" > /dev/null 2>&1
          [ $? = 0 ]
        fi
        # Create file
        if [ ! -f "${1}" ] ; then
          touch "${1}" > /dev/null 2>&1
          [ $? = 0 ]
        fi
        shift
      done

      return 0
      ;;
    '-fx') # Make sure file doesn't exist
      shift
      while [ "${1}" ] ; do
        # Make sure file is not a symlink
        if test -L "${1}" ; then
          unlink "${1}" > /dev/null 2>&1
          [ $? -eq 0 ]
        fi
        # Remove file
        if [ -f "$1" ] ; then
          rm -f "$1" > /dev/null 2>&1
          [ $? -eq 0 ]
        fi
        shift
      done

      return 0
      ;;
    '-dc') # Make sure directory exists
      shift
      while [ "$1" ] ; do
        # Make sure directory is not a symlink
        if test -L "$1" ; then
          unlink "$1" > /dev/null 2>&1
          [ "$?" -eq 0 ]
        fi
        # Create directory
        if [ ! -d "$1" ] ; then
          mkdir -p "$1" > /dev/null 2>&1
          [ "$?" -eq 0 ]
        fi
        shift
      done

      return 0
      ;;
    '-dx') # Make sure directory doesn't exists
      shift
      while [ "$1" ] ; do
        # Make sure directory is not a symlink
        if test -L "$1" ; then
          unlink "$1" > /dev/null 2>&1
          [ "$?" -eq 0 ]
        fi
        # Remove directory
        if [ -d "$1" ] ; then
          rm -rf "$1" > /dev/null 2>&1
          [ "$?" -eq 0 ]
        fi
        shift
      done

      return 0
      ;;
  esac

  return 1

}

function tolower {

  echo "$@" | tr '[A-Z]' '[a-z]'

}

function toupper {

  echo $@ | tr '[a-z]' '[A-Z]'

}

function p_and_q {

  local STAT

  STAT="${1}"
  shift
  echo $@
  exit $STAT

}

function ProcExists { # Checks to see if the process is running

  if [ $# -ne 1 ] ; then
    return 1
  fi

  kill -0 "$1" > /dev/null 2>&1

}

function CheckPidfile { # Checks the pidfile to see if the process is running

  if [ -f "$1" ] ; then
  	ProcExists "$(cat $1 2> /dev/null)"
  fi

}

function RunQuiet { # Start an application in the background

  PathHasBin "$1" || return 1

  local pid

  pid="$(pgrep $1)"

  if [ -z "$PID" ] ; then
  	$@ > /dev/null 2>&1
  fi

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

function svar { # Stores the output of the command into a variable without a subshell

  local VAR
  local TMP
  local RET

  VAR="$1" ; shift
  TMP="$(mktemp 2> /dev/null)" || TMP="$(mktemp -t tmp 2> /dev/null)" || return 128
  "$@" > "$TMP"
  RET="$?"
  read "$VAR" < "$TMP"
  rm "$TMP"

  return "$RET"

}

function dotfiles_dir {

  echo "$DOTFILES_DIR" && return 0

  return 1

}

function kratos_dir {

  echo "$KRATOS_DIR" && return 0

  return 1

}

function deskenvs_executable {

  case "$1" in
    'awesome')
      echo "awesome" && return 0
      ;;
    'cinnamon')
      echo "cinnamon-session" && return 0
      ;;
    'gnome3')
      echo "gnome-session" && return 0
      ;;
    'i3')
      echo "i3" && return 0
      ;;
    'kde')
      echo "startkde" && return 0
      ;;
    'xfce')
      echo "startxfce4" && return 0
      ;;
    'xmonad')
      echo "xmonad" && return 0
      ;;
  esac

  return 1

}
