# This file is part of Kratos.
# Copyright (c) 2014-2015, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

# Initalize shell configuration
export KRATOS_DIR="$HOME/.kratos"
export DOTFILES_DIR="$HOME/.dotfiles"
. "$HOME/.local/share/dotfiles/preferences"

load_one() { # Source Modules

  if [ -n "$(echo "$1" | grep '\(~$\|^#\)')" ] ; then
    return 0
  fi

  . "$1" || {
    echo "Failed to load module $1"
    return 1
  }

  return 0

}

load_all() {

  [ "$#" -ge 1 ] || return 1

  local MODS
  local MOD

  MODS=($(find "$KRATOS_DIR/$1" -type f))

  for MOD in "${MODS[@]}" ; do
    load_one "$MOD"
  done

  return 0

}

load_all "lib"
load_all "modules"

shells_tmp
shells_theme
shells_init
prompt_configure

if [[ "$PREFERED_SHELL" != "$(shell)" && -n "$PREFERED_SHELL" ]] ; then
  exec "$PREFERED_SHELL"
  exit $?
fi
