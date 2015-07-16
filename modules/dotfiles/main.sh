# This file is part of Kratos.
# Copyright (c) 2014-2015, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

function DotfilesPreGenerateHook {

  if [[ -f "${1}/.generate-pre" ]] ; then
    . "${1}/.generate-pre" || {
      ErrError "failed to source \`${1}.generate-pre'"
      return 1
    }
  fi

  return 0

}

function DotfilesGenerateHook {

  if [[ -f "${1}/.generate" ]] ; then
    # TODO:
    # Needs to parse file and replace variable, but not shell style variables
    echo
  fi

  return 0

}

function DotfilesPostGenerateHook {

  if [[ -f "${1}/.generate-post" ]] ; then
    . "${1}/.generate-post" || {
      ErrError "failed to source \`${1}.generate-post'"
      return 1
    }
  fi

  return 0

}

function DotfilesPreInstallHook {

  if [[ -f "${1}/.install-pre" ]] ; then
    . "${1}/.install-pre" || {
      ErrError "failed to source \`${1}.install-pre'"
      return 1
    }
  fi

  return 0

}

function DotfilesInstallHook {

  if [[ -f "${1}/.install" ]] ; then
    . "${1}/.install" || {
      ErrError "failed to source \`${1}.install'"
      return 1
    }
  fi

  return 0

}

function DotfilesPostInstallHook {

  if [[ -f "${1}/.install-post" ]] ; then
    . "${1}/.install-post" || {
      ErrError "failed to source \`${1}.install-post'"
      return 1
    }
  fi

  return 0

}

function DotfilesPreUninstallHook {

  if [[ -f "${1}/.uninstall-pre" ]] ; then
    . "${1}/.uninstall-pre" || {
      ErrError "failed to source \`${1}.uninstall-pre'"
      return 1
    }
  fi

  return 0

}

function DotfilesUninstallHook {

  if [[ -f "${1}/.uninstall" ]] ; then
    . "${1}/.uninstall" || {
      ErrError "failed to source \`${1}.uninstall'"
      return 1
    }
  fi

  return 0

}

function DotfilesPostUninstallHook {

  if [[ -f "${1}/.uninstall-post" ]] ; then
    . "${1}/.uninstall-post" || {
      ErrError "failed to source \`${1}.uninstall-post'"
      return 1
    }
  fi

  return 0

}

function DotfilesSystemdHook {

  # Find type for symlinking

  local TYPE=

  #exist -dc "${HOME}/.config/systemd/user/${TYPE}.target.wants"
  #symlink "${1}" "${HOME}/.config/systemd/user/${TYPE}.target.wants/$(basename "${DOTFILE}")"

  return 0

}

function DotfilesHook {

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
  # Respect filenames with spaces
  local DOTFILES
  while read -rd '' ; do
    DOTFILES+=("${REPLY}")
  done < <(find ${DOTFILES_DIR} -type f -not -iwholename '*.git*' -print0)
  #local DONT_SYM_ITEM
  #local DONT_SYM_LIST=($(cat "${DOTFILES_DIR}/.kratosdontsym"))
  local IGNORE_STATUS
  local IGNORE_ITEM
  #local IGNORE_LIST=($(cat "${DOTFILES_DIR}/.kratosignore"))
  local IGNORE_LIST_STRING="$(cat "${DOTFILES_DIR}/.kratosignore")"
  local IGNORE_LIST
  IGNORE_LIST=(${IGNORE_LIST_STRING})

  # TODO: Add systemd support
  # The systemd directory requires special attention because systemd does not
  #  support symlinked service files.
  # Maybe we should symlink the service files to ~/.config/systemd/user/<type>.target.wants
  #  assuming that they should be activated in not in .kratosignore
  IGNORE_LIST+=("${HOME}/.config/systemd")

  for DOTFILE in "${DOTFILES[@]}" ; do

    # Catch potential errors where array elements are being split in to multiple
    #  elements (such as the issue with spaces in arrays)
    if [[ -n ${DOTFILE} && ! -e ${DOTFILE} ]] ; then
      ErrWarn "invalid file: ${DOTFILE}"
    fi

    # Ignore hidden files
    [[ "$(basename "${DOTFILE}")" =~ "^\." ]] && continue
    # Make sure file exists
    [[ -e "${DOTFILE}" ]] || continue

    # Ignore kratos hooks
    case "${DOTFILE##*.}" in
      'install-pre'|'install'|'install-post'|\
      'generate-pre'|'generate-post'|\
      'uninstall-pre'|'uninstall'|'uninstall-post')
        continue
        ;;
    esac

    # Respect .kratosignore
    IGNORE_STATUS=false
    for IGNORE_ITEM in "${IGNORE_LIST[@]}" ; do
      # Respect ignoring files within ignore directories
      if [[ -n "$(echo "${DOTFILE}" | grep "${IGNORE_ITEM}")" ]] ; then
        IGNORE_STATUS=true
        break
      fi
    done
    if $IGNORE_STATUS ; then
      continue
    fi

    # PRE-(Un)Install
    if ${UNINSTALL} ; then
      DotfilesPreUninstallHook "${DOTFILE}" || return 1
    else
      DotfilesPreInstallHook "${DOTFILE}" || return 1
    fi

    # (Un)Install
    if ${UNINSTALL} ; then
      if [[ -f "${DOTFILE}.uninstall" ]] ; then
        DotfilesUninstallHook "${DOTFILE}" || return 1
      else
        echo "uninstall"
      fi
    else
      if [[ -f "{DOTFILE}.install" ]] ; then
        DotfilesInstallHook "${DOTFILE}" || return 1
      else

        # TODO: add loop for .kratosdontsym

        # TODO: Add DotfilesPreGenerateHook & DotfilesPostGenerateHook

        if [[ "${DOTFILE##*.}" == 'generate' ]] ; then
          DotfilesPreGenerateHook "${DOTFILE}" || return 1
          DotfilesGenerateHook "${DOTFILE}" || return 1
          DotfilesPostGenerateHook "${DOTFILE}" || return 1
        elif [[ -n "$(echo "${DOTFILE}" | grep "config/systemd/user")" ]] ; then
          DotfilesSystemdHook "${DOTFILE}" || return 1
        else
          # TODO: add logic to prevent from following symlinked directory paths, may not be necessary
          EnsureFileDestroy "${HOME}/.$(echo "${DOTFILE}" | sed -e "s|${DOTFILES_DIR}\/||")" || {
            ErrError "failed to remove: ${HOME}/.$(echo "${DOTFILE}" | sed -e "s|${DOTFILES_DIR}\/||")"
            return 1
          }
          # Symlink DOTFILE
          echo "Installing: ${DOTFILE}"
          symlink "${DOTFILE}" "${HOME}/.$(echo "${DOTFILE}" | sed -e "s|${DOTFILES_DIR}\/||")" || {
            ErrError "failed to symlink \`${DOTFILE}' to \`${HOME}/.$(echo "${DOTFILE}" | sed -e "s|${DOTFILES_DIR}\/||")'"
            return 1
          }
        fi
      fi
    fi

    # POST-(Un)Install
    if ${UNINSTALL} ; then
      DotfilesPostUninstallHook "${DOTFILE}" || return 1
    else
      DotfilesPostInstallHook "${DOTFILE}" || return 1
    fi

  done

}
