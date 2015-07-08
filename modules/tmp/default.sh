# This file is part of Kratos.
# Copyright (c) 2014-2015, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

# TODO:
# Rename to tmp_dir
# Add a fallback to use the ~/.cache directory and delete the directory on logout

function dir_tmp { # Get the path to the temporary directory

  local DIR
  local TMPDIR=
  local TMPDIRS=("$ROOT/dev/shm" "$ROOT/run/shm" "$ROOT/tmp" "$ROOT/var/tmp")

  for DIR in "${TMPDIRS[@]}" ; do

    if [ -n "$(mount | grep '\(tmpfs\|ramfs\)' | grep $DIR 2> /dev/null)" ] ; then
      TMPDIR="$DIR/$USER"
      break
    fi

  done

  if [ -z "$TMPDIR" ] ; then
    echo "ERROR: Failed to find a tmp directory"
    return 1
  fi

  if [ ! -d "$TMPDIR" ] ; then
    mkdir "$TMPDIR" || return 1
    chmod 0700 "$TMPDIR" || return 1
  fi

  ln -sf "$TMPDIR" "$HOME/.tmp" || return 1

  if [ ! -d "$TMPDIR/cache" ] ; then
    mkdir "$TMPDIR/cache" || return 1
    ln -sf "$TMPDIR/cache" "$HOME/.cache" || return 1
  fi

  # Create dotfiles session directory
  if [ ! -d "$TMPDIR/dotfiles" ] ; then
    mkdir -p "$TMPDIR/dotfiles" || return 1
  fi

  return 0

}
