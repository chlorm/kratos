# This file is part of Kratos.
# Copyright (c) 2014-2015, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

install_dotfiles() {

  local DIRS
  local DIR
  local FILE
  local SYMD_DIRS
  local DONT_SYM
  local SYMD_EXISTS
  local IGNORE

  DIRS=($(find $DOTFILES_DIR -type d))
  SYMD_DIRS=()

  for DIR in "${DIRS[@]}" ; do
    DONT_SYM=false

    if [ -f "$DIR/.kratos" ] ; then
      if [ -n "$(grep 'dont_sym=./' $DIR/.kratos)" ] ; then
        DONT_SYM=true
      fi
    fi

    FILES=()

    if [ "$DONT_SYM" = true ] ; then
      FILES=($(find $DIR -maxdepth 1 -type f))
      for FILE in "${FILES[@]}" ; do
        if [ "$(basename $FILE)" = ".kratos" ] ; then
          continue
        fi

        IGNORE=false

        if [ -f "$DIR/.kratos" ] ; then
          if [ -n "$(grep "ignore=$(basename $FILE)" $DIR/.kratos)" ] ; then
            IGNORE=true
          fi
        fi

        if [ "$IGNORE" = false ] && [ -z "$(echo "$FILE" | grep ".kratos")" ] ; then
          exist -fx "$HOME/.$(echo "$FILE" | sed -e "s|$FILES_DIR\/||")"
          # Symlink FILE
          symlink "$FILE" "$HOME/.$(echo "$FILE" | sed -e "s|$FILES_DIR\/||")"
        fi
      done
    else
      # TODO: fix this to match files correctly
      if [[ "$(basename $DIR)" =~ ^\. ]] ; then
        SYMD_DIRS+=("$DIR")
        continue
      fi

      SYMD_EXISTS=false
      for SYMD_DIR in "${SYMD_DIRS[@]}" ; do
        # If the current $DIR exists in $SYMD_DIR
        if [ -n "$(echo $DIR | grep "$SYMD_DIR")" ] ; then
          # If the $SYMD_DIR is a subdirectory of $DIR (Needs to remove anything before match to be sure)
          if [ -n "$(echo $SYMD_DIR | sed -e "s|$DIR||")" ] ; then
            SYMD_EXISTS=true
          fi
        fi
      done

      if [ "$SYMD_EXISTS" = false ] ; then
        exist -dx "$HOME/.$(echo "$DIR" | sed -e "s|$DOTFILES_DIR\/||")"
        # Symlink DIR
        symlink "$DIR" "$HOME/.$(echo "$DIR" | sed -e "s|$DOTFILES_DIR\/||")"
        SYMD_DIRS+=("$DIR")
      fi
    fi

  done

  return 0

}
install_dotfiles
