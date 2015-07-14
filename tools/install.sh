#!/usr/bin/env bash

# This file is part of Kratos.
# Copyright (c) 2014-2015, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

export KRATOS_DIR="$(readlink -f "$(dirname "$(readlink -f "${0}")")")/.."
export DOTFILES_DIR="${HOME}/.dotfiles"

if [ -z "$KRATOS_DIR" ] ; then
  echo "ERROR: kratos remote repo origin is not set"
  exit 1
fi

function LoadModule { # Source Modules

  if [ -n "$(echo "$1" | grep '\(~$\|^#\)')" ] ; then
    return 0
  fi

  . "${1}" || {
    echo "Failed to load module ${1}"
    return 1
  }

  return 0

}

function LoadModuleDir {

  [ "$#" -ge 1 ] || return 1

  local MODS
  local MOD

  MODS=($(find "${KRATOS_DIR}/${1}" -type f))

  for MOD in "${MODS[@]}" ; do
    LoadModule "${MOD}"
  done

  return 0

}

LoadModuleDir 'modules'

# XDG freedesktop directories

# XDG_CACHE_HOME
exist -dc "${HOME}/.cache"
# XDG_CONFIG_HOME
exist -dc "${HOME}/.config"
# XDG_DATA_HOME
exist -dc "${HOME}/.local/share"
# XDG_DESKTOP_DIR
exist -dc "${HOME}/Desktop"
# XDG_DOCUMENTS_DIR
exist -dc "${HOME}/Documents"
# XDG_DOWNLOAD_DIR
exist -dc "${HOME}/Downloads"
# XDG_MUSIC_DIR
exist -dc "${HOME}/Music"
# XDG_PICTURES_DIR
exist -dc "${HOME}/Pictures"
# XDG_PUBLICSHARE_DIR
exist -dc "${HOME}/Share"
# XDG_TEMPLATES_DIR
exist -dc "${HOME}/Templates"
# XDG_VIDEOS_DIR
exist -dc "${HOME}/Videos"

# Freedesktop trash directories

# DIR_TRASH_INFO
exist -dc "${HOME}/.local/share/trash/info"
# DIR_TRASH_FILES
exist -dc "${HOME}/.local/share/trash/files"

# Custom directories

exist -dc "${HOME}/Dev"

#git remote set-url origin "$DOTFILES_REPO"
#git remote set-url --push origin "$DOTFILES_REPO"

#dotfiles_latest

mkdir -p "${HOME}/.local/share/kratos"
echo "export KRATOS_DIR=\"${KRATOS_DIR}\"" > "${HOME}/.local/share/kratos/dir"

# Install dotfiles
DotfilesHook || {
  ErrError 'Dotfiles install failed'
  exit 1
}

# Load settings
if [ -f "${HOME}/.config/kratos/config" ] ; then
  . "${HOME}/.config/kratos/config"
  # Preference
  exist -fx "${HOME}/.local/share/kratos/preferences"
  touch "${HOME}/.local/share/kratos/preferences"
  KratosPreferredShell
  KratosPreferredEditor
  KratosPreferredDeskenv
fi


# TODO:
# + Always create directories, never symlink, only symlink files

symlink "${KRATOS_DIR}/rc/profile" "${HOME}/.profile"

symlink "${KRATOS_DIR}/rc/bashrc" "${HOME}/.bashrc"
symlink "${KRATOS_DIR}/rc/bash_login" "${HOME}/.bash_login"
symlink "${KRATOS_DIR}/rc/bash_login" "${HOME}/.bash_logout"

symlink "${KRATOS_DIR}/rc/kshrc" "${HOME}/.kshrc"
symlink "${KRATOS_DIR}/rc/ksh_login" "${HOME}/.ksh_login"

symlink "${KRATOS_DIR}/rc/zshrc" "${HOME}/.zshrc"
symlink "${KRATOS_DIR}/rc/zsh_login" "${HOME}/.zsh_login"

symlink "${KRATOS_DIR}/rc/xinitrc" "${HOME}/.xinitrc"
symlink "${KRATOS_DIR}/rc/xprofile" "${HOME}/.xprofile"
symlink "${KRATOS_DIR}/rc/xsession" "${HOME}/.xsession"

#symlink "${KRATOS_DIR}/systemd/kratos-init.service" "${HOME}/.config/systemd/user/kratos-init.service"
