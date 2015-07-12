#!/usr/bin/env sh

# This file is part of Kratos.
# Copyright (c) 2014-2015, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

export KRATOS_DIR="$(readlink -f "$(dirname "$(readlink -f "$0")")")/../"
export DOTFILES_DIR="$HOME/.dotfiles"

function load_one { # Source Modules

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

load_all "modules"

# Test for supported shell, if not supported try executing
# any supported shell for installation
# case "$(shell_nov)" in
#   'bash'|'ksh'|'pdksh'|'zsh')
#     echo
#     ;;
#   *)
#     if path_hasbin "bash" ; then
#       exec bash
#     elif path_hasbin "zsh" ; then
#       exec zsh
#     elif path_hasbin "pdksh" ; then
#       exec pdksh
#     elif path_hasbin "ksh" ; then
#       exec ksh
#     else
#       echo "ERROR: Your shell is not supported by Kratos and no"
#       echo "supported shell could not be found on you system"
#       exit 1
#     fi
#     ;;
# esac

# Load settings
. "$KRATOS_DIR/dotfiles.conf" || exit 1
# Load local settings
if [ -f "$KRATOS_DIR/dotfiles.conf.local" ] ; then
  . "$KRATOS_DIR/dotfiles.conf.local"
else
  echo '#!/usr/bin/env sh' > "$KRATOS_DIR/dotfiles.conf.local"
fi

# XDG freedesktop directories

# XDG_CACHE_HOME
exist -dc "$HOME/.cache"
# XDG_CONFIG_HOME
exist -dc "$HOME/.config"
# XDG_DATA_HOME
exist -dc "$HOME/.local/share"
# XDG_DESKTOP_DIR
exist -dc "$HOME/Desktop"
# XDG_DOCUMENTS_DIR
exist -dc "$HOME/Documents"
# XDG_DOWNLOAD_DIR
exist -dc "$HOME/Downloads"
# XDG_MUSIC_DIR
exist -dc "$HOME/Music"
# XDG_PICTURES_DIR
exist -dc "$HOME/Pictures"
# XDG_PUBLICSHARE_DIR
exist -dc "$HOME/Share"
# XDG_TEMPLATES_DIR
exist -dc "$HOME/Templates"
# XDG_VIDEOS_DIR
exist -dc "$HOME/Videos"

# Freedesktop trash directories

# DIR_TRASH_INFO
exist -dc "$HOME/.local/share/trash/info"
# DIR_TRASH_FILES
exist -dc "$HOME/.local/share/trash/files"

# Custom directories

exist -dc "$HOME/Dev"

if [ -z "$KRATOS_DIR" ] ; then
  echo "ERROR: kratos remote repo origin is not set"
  exit 1
fi

#git remote set-url origin "$DOTFILES_REPO"
#git remote set-url --push origin "$DOTFILES_REPO"

#dotfiles_latest

echo "export KRATOS_DIR=\"$KRATOS_DIR\"" > "$HOME/.local/share/dotfiles/dir"

exist -fx "$HOME/.local/share/dotfiles/preferences"

touch "$HOME/.local/share/dotfiles/preferences"

# Preference
kratos.preferred.shell || echo "WARNING: no prefered SHELL found"
kratos.preferred.editor || echo "WARNING: no prefered EDITOR found"
kratos.preferred.deskenv || echo "WARNING: no prefered DESKENV found"

hook.dotfiles

# TODO:
# + Always create directories, never symlink, only symlink files

symlink "$KRATOS_DIR/rc/profile" "$HOME/.profile"

symlink "$KRATOS_DIR/rc/bashrc" "$HOME/.bashrc"
symlink "$KRATOS_DIR/rc/bash_login" "$HOME/.bash_login"
symlink "$KRATOS_DIR/rc/bash_login" "$HOME/.bash_logout"

symlink "$KRATOS_DIR/rc/kshrc" "$HOME/.kshrc"
symlink "$KRATOS_DIR/rc/ksh_login" "$HOME/.ksh_login"

symlink "$KRATOS_DIR/rc/zshrc" "$HOME/.zshrc"
symlink "$KRATOS_DIR/rc/zsh_login" "$HOME/.zsh_login"

symlink "$KRATOS_DIR/rc/xinitrc" "$HOME/.xinitrc"
symlink "$KRATOS_DIR/rc/xprofile" "$HOME/.xprofile"
symlink "$KRATOS_DIR/rc/xsession" "$HOME/.xsession"
