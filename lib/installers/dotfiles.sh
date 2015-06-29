# This file is part of Kratos.
# Copyright (c) 2014-2015, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

is_exclude() {

  local ITTR_EXCLUDES=0

  array_from_str EXCLUDES "LICENSE README.md"

  for EXCLUDE in "$(array_at EXCLUDES $ITTR)" ; do
    if [ "$1" = "$EXCLUDE" ] ; then
      return 1
    fi
  done

  return 0

}

install_dotfiles() {

  local DOTFILE

  for DOTFILE in "$(ls $HOME/.dotfiles)" ; do
    if [ -f "$HOME/.$DOTFILE" ] ; then
      is_exclude "$DOTFILE" || continue
      dotfile_ln "$HOME/$DOTFILE"
    elif [ -d "$HOME/.$DOTFILE" ] ; then
      if [ "$DOTFILE" = "config" ] ; then
        exist -dc "$HOME/.config"
        local CONFIG_DIR

        for CONFIG_DIR in "$(ls $HOME/.dotfiles/config)" ; do
          dotfile_ln "$HOME/.dotfiles/config/$CONFIG_DIR"
        done

        continue
      elif [ "$DOTFILE" = "local" ] ; then
        exist -dc "$HOME/.local/share"
        local LOCAL_SHARE_DIR

        for LOCAL_SHARE_DIR in "$(ls $HOME/.dotfiles/local/share)" ; do
          dotfile_ln "$HOME/.dotfiles/config/$LOCAL_SHARE_DIR"
        done

        continue
      elif [ "$DOTFILE" = "ssh" ] ; then
        exist -dc "$HOME/.ssh"
        dotfile_ln "$HOME/$DOTFILE/config"
      else
        dotfile_ln "$HOME/$DOTFILE"
      fi
    else
      echo "probably an error"
    fi
  done

  return 0

}
