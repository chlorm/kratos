# This file is part of Kratos.
# Copyright (c) 2014-2015, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

install_dotfiles() {

  local DOTFILE_DIRS
  local DOTFILE_DIR
  local DOTFILE
  local SYMD_DIRS
  local ITTR_DOTFILE_DIRS=0
  local ITTR_SYMD_DIRS
  local DONT_SYM
  local SYMD_EXISTS
  local IGNORE

  array_from_str DOTFILE_DIRS "$(find $DOTFILES_DIR -type d)"
  array_new SYMD_DIRS

  for DOTFILE_DIR in "$(array_at DOTFILE_DIRS $ITTR_DOTFILE_DIRS)" ; do

    DONT_SYM=false

    if [ -f "$DOTFILE_DIR/.kratos" ] ; then
      if [ -n "$(grep -m 1 "dont_sym=./")" ] ; then
        DONT_SYM=true
      fi
    fi

    if [ "$DONT_SYM" = true ] ; then
      for DOTFILE in "$(find $DOTFILE_DIR -type f -maxdepth 1)" ; do

        IGNORE=false

        if [ -f "$DOTFILE_DIR/.kratos" ] ; then
          if [ -n "$(grep "ignore=$(basename $DOTFILE)" $DOTFILE_DIR/.kratos)" ] ; then
            IGNORE=true
          fi
        fi

        if [ "$IGNORE" = false ] ; then
          symlink "$DOTFILE" "$HOME/.$(echo "$DOTFILES_DIR" | sed -e 's/$DOTFILES_DIR\///')"
        fi

      done
    else

      ITTR_SYMD_DIRS=0

      for SYMD_DIR in "$(array_at SYMD_DIRS $ITTR_SYMD_DIRS)" ; do
        SYMD_EXISTS=false
        if [ "$DOTFILE_DIR" = "$SYMD_DIR/*" ] ; then # needs to match path/* anything, as long as is dir and after the dir in array
          SYMD_EXISTS=true
        fi

        if [ "$ITTR_SYMD_DIRS" -le "$(((array_size SYMD_DIRS - 1)))" ] ; then
          ITTR_SYMD_DIRS=(($ITTR_SYMD_DIRS + 1))
        else
          break
        fi
      done

      if [ "$SYMD_EXISTS" = false ] ; then
        symlink "$DOTFILE_DIR" "$HOME/.$(echo "$DOTFILE_DIR" | sed -e 's/$DOTFILES_DIR\///')"
      fi

    fi

    if [ "$ITTR_DOTFILE_DIRS" -le "$(((array_size DOTFILE_DIRS - 1)))" ] ; then
      ITTR_DOTFILE_DIRS=(($ITTR_DOTFILE_DIRS + 1))
    else
      break
    fi

  done

  return 0

}
install_dotfiles
