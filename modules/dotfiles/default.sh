# This file is part of Kratos.
# Copyright (c) 2014-2015, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

function hook.generate.pre {

  if [[ -f "${1}/.generate-pre" ]] ; then
    . "${1}/.generate-pre" || return 1
  fi

  return 0

}

function hook.generate {

  if [[ -f "${1}/.generate" ]] ; then
    # TODO:
    # Needs to parse file and replace variable, but not shell style variables
    echo
  fi

  return 0

}

function hook.generate.post {

  if [[ -f "${1}/.generate-post" ]] ; then
    . "${1}/.generate-post" || return 1
  fi

  return 0

}

function hook.install.pre {

  if [[ -f "${1}/.install-pre" ]] ; then
    . "${1}/.install-pre" || return 1
  fi

  return 0

}

function hook.install {

  if [[ -f "${1}/.install" ]] ; then
    . "${1}/.install" || return 1
  fi

  return 0

}

function hook.install.post {

  if [[ -f "${1}/.install-post" ]] ; then
    . "${1}/.install-post" || return 1
  fi

  return 0

}

function hook.uninstall.pre {

  if [[ -f "${1}/.uninstall-pre" ]] ; then
    . "${1}/.uninstall-pre" || return 1
  fi

  return 0

}

function hook.uninstall {

  if [[ -f "${1}/.uninstall" ]] ; then
    . "${1}/.uninstall" || return 1
  fi

  return 0

}

function hook.uninstall.post {

  if [[ -f "${1}/.uninstall-post" ]] ; then
    . "${1}/.uninstall-post" || return 1
  fi

  return 0

}

function hook.dotfiles {

  # This function handles the installation of files within the ~/.dotfiles
  #  directory.  It only symlinks files, not directories, this is to work around
  #  some issues when symlinking directories.  This gets a bit messy when
  #  vendoring plugins for something like atom or sublime-text that have a
  #  complex heirarchy of directories and lots of files potentially.  A solution
  #  is needed so that adding support for symlinking directories wouldn't be as
  #  complicated.  The possibilities for handling this include:
  #  + Use install hooks to handle symlinking directories, this involves also
  #     having to add those directories to .kratosignore, and maybe additional
  #     logic may have to be added to .kratosignore.
  #  + Only symlink directories if the directory is a git submodule.  This also
  #     makes since for vendored plugins and such to be git submodules.  also
  #     there are not many cases where symlink directories would be needed
  #     outside of doing it this way and it prevents people from working on
  #     development in side of a dotfiles directory.

  local UNINSTALL=false
  if [[ "${1}" == 'uninstall' ]] ; then
    UNINSTALL=true
  fi

  local DOTFILE
  local DOTFILES=($(find "${DOTFILES_DIR}" -type f))
  local DONT_SYM_ITEM
  local DONT_SYM_LIST=($(cat "${DOTFILES_DIR}/.kratosdontsym"))
  local IGNORE_ITEM
  local IGNORE_LIST=($(cat "${DOTFILES_DIR}/.kratosignore"))

  for DOTFILE in "${DOTFILES[@]}" ; do

    # Ignore hidden files
    [[ "$(basename "${DOTFILE}")" =~ ^\. ]] && continue

    # Run kratos hooks
    # Currently executes all before, but in the future should respect
    #  install-post, and .install should override the install phase.
    case "${DOTFILE##*.}" in
      'install-pre'|'install'|'install-post'|\
      'generate-pre'|'generate-post'|\
      'uninstall-pre'|'uninstall'|'uninstall-post')
        continue
        ;;
    esac

    # Respect .kratosignore
    for IGNORE_ITEM in "${IGNORE_LIST[@]}" ; do
      # Respect ignoring files within ignore directories
      if [[ -n "$(echo "${DOTFILE}" | grep "$IGNORE_ITEM")" ]] ; then
        continue
      fi
    done

    if "${UNINSTALL}" ; then
      hook.uninstall.pre "${DOTFILE}" || return 1
    else
      hook.install.pre "${DOTFILE}" || return 1
    fi

    if "${UNINSTALL}" ; then
      if [[ -f "${DOTFILE}/.uninstall" ]] ; then
        hook.uninstall "${DOTFILE}" || return 1
      else
        echo "uninstall"
      fi
    else
      if [[ -f "{DOTFILE}/.install" ]] ; then
        hook.install "${DOTFILE}" || return 1
      else

        # TODO: add loop for .kratosdontsym

        if [[ "${DOTFILE##*.}" == 'generate' ]] ; then
          hook.generate "${DOTFILE}" || return 1
        else
          exist -fx "${HOME}/.$(echo "${DOTFILE}" | sed -e "s|${DOTFILES_DIR}\/||")" || return 1
          # Symlink DOTFILE
          symlink "${DOTFILE}" "${HOME}/.$(echo "${DOTFILE}" | sed -e "s|${DOTFILES_DIR}\/||")" || return 1
        fi
      fi
    fi

    if "${UNINSTALL}" ; then
      hook.uninstall.post "${DOTFILE}" || return 1
    else
      hook.install.post "${DOTFILE}" || return 1
    fi

  done

}