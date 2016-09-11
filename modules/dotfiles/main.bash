# This file is part of Kratos.
# Copyright (c) 2014-2016, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

Dotfiles::GenerateHook.pre() {
  if [ -f "${1}.generate-pre" ] ; then
    source "${1}.generate-pre"
  fi
}

Dotfiles::GenerateHook() {
  if [ -f "${1}.generate" ] ; then
    # TODO:
    # Needs to parse file and replace variable, but not shell style variables
    echo
  fi
}

Dotfiles::GenerateHook.post() {
  if [ -f "${1}.generate-post" ] ; then
    source "${1}.generate-post"
  fi
}

Dotfiles::InstallHook.pre() {
  if [ -f "${1}.install-pre" ] ; then
    source "${1}.install-pre"
  fi

  return 0
}

Dotfiles::InstallHook() {
  if [ -f "${1}.install" ] ; then
    source "${1}.install"
  fi

  return 0
}

Dotfiles::InstallHook.post() {
  if [ -f "${1}.install-post" ] ; then
    source "${1}.install-post"
  fi

  return 0
}

Dotfiles::UninstallHook.pre() {
  if [ -f "${1}.uninstall-pre" ] ; then
    source "${1}.uninstall-pre"
  fi

  return 0
}

Dotfiles::UninstallHook() {
  if [ -f "${1}.uninstall" ] ; then
    source "${1}.uninstall"
  fi

  return 0
}

Dotfiles::UninstallHook.post() {
  if [ -f "${1}.uninstall-post" ] ; then
    source "${1}.uninstall-post"
  fi

  return 0
}

Dotfiles::SystemdHook() {
  # Find type for symlinking

  local TYPE

  #exist -dc "${HOME}/.config/systemd/user/${TYPE}.target.wants"
  #symlink "${1}" "${HOME}/.config/systemd/user/${TYPE}.target.wants/$(basename "${DOTFILE}")"

  return 0
}

Dotfiles::Hook() {
  local Dotfile
  local -a Dotfiles
  local Uninstall
  local IgnoreItem
  local -a IgnoreList
  local IgnoreStatus

  Uninstall=false
  if [ "${1}" == 'uninstall' ] ; then
    Uninstall=true
  fi

  Dotfiles=()
  # Respect filenames with spaces
  while read -rd '' ; do
    Dotfiles+=(
      "${REPLY}"
    )
  done < <(find ${DOTFILES_DIR} -type f -not -iwholename '*.git*' -print0)

  IgnoreList=()
  if [[ -f "${DOTFILES_DIR}/.kratosignore" ]] ; then
    IgnoreList+=(
      $(cat "${DOTFILES_DIR}/.kratosignore")
    )
  fi
  # TODO: Add systemd support
  IgnoreList+=(
    "${HOME}/.config/systemd"
  )

  # Respect .kratosignore file
  if [ -f "${DOTFILES_DIR}/.kratosignore" ] ; then
    IgnoreList+=($(
      cat "${DOTFILES_DIR}/.kratosignore"
    ))
  fi

  for Dotfile in "${Dotfiles[@]}" ; do

    # Catch potential errors where paths are split into multiple array elements
    #  caused by spaces in the path.
    if [[ -n ${Dotfile} && ! -e ${Dotfile} ]] ; then
      Log::Message 'error' "invalid file: ${Dotfile}"
    fi

    # Ignore hidden files
    if [[ "$(basename "${Dotfile}")" =~ "^\." ]] ; then
      continue
    fi
    # Make sure file exists
    if [ ! -e "${Dotfile}" ] ; then
      continue
    fi

    # Ignore kratos hooks
    case "${Dotfile##*.}" in
      'install-pre'|\
      'install'|\
      'install-post'|\
      'generate-pre'|\
      'generate-post'|\
      'uninstall-pre'|\
      'uninstall'|\
      'uninstall-post')
        continue
        ;;
    esac

    # Respect .kratosignore
    IgnoreStatus=false
    for IgnoreItem in "${IgnoreList[@]}" ; do
      # Respect ignoring files within ignore directories
      if [[ -n "$(echo "${Dotfile}" | grep "${IgnoreItem}")" ]] ; then
        IgnoreStatus=true
        break
      fi
    done
    if ${IgnoreStatus} ; then
      continue
    fi

    # PRE-(Un)Install
    if ${Uninstall} ; then
      Dotfiles::UninstallHook.pre "${Dotfile}"
    else
      Dotfiles::InstallHook.pre "${Dotfile}"
    fi

    # (Un)Install
    if ${Uninstall} ; then
      if [ -f "${Dotfile}.uninstall" ] ; then
        Dotfiles::UninstallHook "${Dotfile}"
      else
        echo "uninstall"
      fi
    else
      if [ -f "${Dotfile}.install" ] ; then
        Dotfiles::InstallHook "${Dotfile}"
      else

        # TODO: Add DotfilesPreGenerateHook & DotfilesPostGenerateHook

        if [[ "${Dotfile##*.}" == 'generate' ]] ; then
          Dotfiles::GenerateHook.pre "${Dotfile}"
          Dotfiles::GenerateHook "${Dotfile}"
          Dotfiles::GenerateHook.post "${Dotfile}"
        elif [ -n "$(echo "${Dotfile}" | grep "config/systemd/user")" ] ; then
          Dotfiles::SystemdHook "${Dotfile}"
        else
          if [ ! -e "${HOME}/.$(echo "${Dotfile}" | \
                   sed -e "s|${DOTFILES_DIR}\/||")" ] ; then
            printf "Installing: ${Dotfile}"\\n
          fi

          # TODO: add logic to prevent from following symlinked directory paths,
          #       may not be necessary
          File::Remove \
            "${HOME}/.$(
              echo "${Dotfile}" |
                sed -e "s|${DOTFILES_DIR}\/||"
            )"

          # Symlink DOTFILE
          Symlink::Create \
            "${Dotfile}" "${HOME}/.$(
              echo "${Dotfile}" |
                sed -e "s|${DOTFILES_DIR}\/||"
            )"
        fi
      fi
    fi

    # POST-(Un)Install
    if ${Uninstall} ; then
      Dotfiles::UninstallHook.post "${Dotfile}"
    else
      Dotfiles::InstallHook.post "${Dotfile}"
    fi

  done
}
