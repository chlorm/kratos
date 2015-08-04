# This file is part of Kratos.
# Copyright (c) 2014-2015, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

# TODO: Don't use $DISPLAY at install time to detect if the environment is graphical
function WindowManagerPreferred {

  local window_manager

  for window_manager in "${WINDOW_MANAGER_PREFERENCE[@]}" ; do
    if PathHasBin "$(window_manager_executable "${window_manager}")" ; then
      echo "PREFERRED_WM=${window_manager}" >> "${HOME}/.local/share/kratos/preferences"
      return 0
    fi
  done

  ErrWarn "no preferred deskenvs found"
  return 1

}

function WindowManagerFindExecutable {

  # If a match isn't found it is assumed that ${1} is the executable name

  case "$1" in
    'cinnamon')
      echo "cinnamon-session" && return 0
      ;;
    'gnome3')
      echo "gnome-session" && return 0
      ;;
    'kde')
      echo "startkde" && return 0
      ;;
    'xfce')
      echo "startxfce4" && return 0
      ;;
    *)
      echo "${1}" && return 0
  esac

  return 1

}

function WindowManagerKnownExecutables {

  # TODO: return first found match for installed WM

  local known_executables

  # Listed in order of preference
  # Stacking WMs should be listed first, assume the user may be unfamiliar with tiling
  known_executables=(
    'gnome-session'
    'cinnamon-session'
    'startkde'
    'startxfce4'
    'xmonad'
    'spectrwm'
    'wingo'
    'i3'
    'awesome'
    'bspwm'
    'dswm'
    'dwm'
    'frankenwm'
    'herbstluftwm'
    'subtle'
    'qtile'
  )

  echo "TODO"

}

function WindowManagerSupportsStacking {

  # TODO: return true if window manager supports stacking

  echo

}
