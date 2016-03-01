# This file is part of Kratos.
# Copyright (c) 2014-2016, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

KRATOS::Modules:dotfiles.pre_generate_hook() {
  if [[ -f "${1}.generate-pre" ]] ; then
    source "${1}.generate-pre" || {
      KRATOS::Lib:err.error "failed to source \`${1}.generate-pre'"
      return 1
    }
  fi

  return 0
}

KRATOS::Modules:dotfiles.generate_hook() {
  if [[ -f "${1}.generate" ]] ; then
    # TODO:
    # Needs to parse file and replace variable, but not shell style variables
    echo
  fi

  return 0
}

KRATOS::Modules:dotfiles.post_generate_hook() {
  if [[ -f "${1}.generate-post" ]] ; then
    source "${1}.generate-post" || {
      KRATOS::Lib:err.error "failed to source \`${1}.generate-post'"
      return 1
    }
  fi

  return 0
}

KRATOS::Modules:dotfiles.pre_install_hook() {
  if [[ -f "${1}.install-pre" ]] ; then
    source "${1}.install-pre" || {
      KRATOS::Lib:err.error "failed to source \`${1}.install-pre'"
      return 1
    }
  fi

  return 0
}

KRATOS::Modules:dotfiles.install_hook() {
  if [[ -f "${1}.install" ]] ; then
    source "${1}.install" || {
      KRATOS::Lib:err.error "failed to source \`${1}.install'"
      return 1
    }
  fi

  return 0
}

KRATOS::Modules:dotfiles.post_install_hook() {
  if [[ -f "${1}.install-post" ]] ; then
    source "${1}.install-post" || {
      KRATOS::Lib:err.error "failed to source \`${1}.install-post'"
      return 1
    }
  fi

  return 0
}

KRATOS::Modules:dotfiles.pre_uninstall_hook() {
  if [[ -f "${1}.uninstall-pre" ]] ; then
    source "${1}.uninstall-pre" || {
      KRATOS::Lib:err.error "failed to source \`${1}.uninstall-pre'"
      return 1
    }
  fi

  return 0
}

KRATOS::Modules:dotfiles.uninstall_hook() {
  if [[ -f "${1}.uninstall" ]] ; then
    source "${1}.uninstall" || {
      KRATOS::Lib:err.error "failed to source \`${1}.uninstall'"
      return 1
    }
  fi

  return 0
}

KRATOS::Modules:dotfiles.post_uninstall_hook() {
  if [[ -f "${1}.uninstall-post" ]] ; then
    source "${1}.uninstall-post" || {
      KRATOS::Lib:err.error "failed to source \`${1}.uninstall-post'"
      return 1
    }
  fi

  return 0
}

KRATOS::Modules:dotfiles.systemd_hook() {
  # Find type for symlinking

  local TYPE

  #exist -dc "${HOME}/.config/systemd/user/${TYPE}.target.wants"
  #symlink "${1}" "${HOME}/.config/systemd/user/${TYPE}.target.wants/$(basename "${DOTFILE}")"

  return 0
}

KRATOS::Modules:dotfiles.hook() {
  local Dotfile
  local -a Dotfiles
  local Uninstall
  #local DONT_SYM_ITEM
  local IgnoreItem
  local -a IgnoreList
  local IgnoreStatus

  Uninstall=false
  if [[ "${1}" == 'uninstall' ]] ; then
    Uninstall=true
  fi

  #local DONT_SYM_LIST=($(cat "${DOTFILES_DIR}/.kratosdontsym"))

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

  for Dotfile in "${Dotfiles[@]}" ; do

    # Catch potential errors where paths are split into multiple array elements
    #  caused by spaces in the path.
    if [[ -n ${Dotfile} && ! -e ${Dotfile} ]] ; then
      KRATOS::Lib:err.warn "invalid file: ${Dotfile}"
    fi

    # Ignore hidden files
    [[ "$(basename "${Dotfile}")" =~ "^\." ]] && continue
    # Make sure file exists
    [[ -e "${Dotfile}" ]] || continue

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
      KRATOS::Modules:dotfiles.pre_uninstall_hook "${Dotfile}" || return 1
    else
      KRATOS::Modules:dotfiles.install_hook "${Dotfile}" || return 1
    fi

    # (Un)Install
    if ${Uninstall} ; then
      if [[ -f "${Dotfile}.uninstall" ]] ; then
        KRATOS::Modules:dotfiles.uninstall_hook "${Dotfile}" || return 1
      else
        echo "uninstall"
      fi
    else
      if [[ -f "{Dotfile}.install" ]] ; then
        KRATOS::Modules:dotfiles.install_hook "${Dotfile}" || return 1
      else

        # TODO: add loop for .kratosdontsym

        # TODO: Add DotfilesPreGenerateHook & DotfilesPostGenerateHook

        if [[ "${Dotfile##*.}" == 'generate' ]] ; then
          KRATOS::Modules:dotfiles.pre_generate_hook "${Dotfile}" || return 1
          KRATOS::Modules:dotfiles.generate_hook "${Dotfile}" || return 1
          KRATOS::Modules:dotfiles.post_generate_hook "${Dotfile}" || return 1
        elif [[ -n "$(echo "${Dotfile}" | grep "config/systemd/user")" ]] ; then
          KRATOS::Modules:dotfiles.systemd_hook "${Dotfile}" || return 1
        else
          if [[ -e "${HOME}/.$(echo "${Dotfile}" | \
                   sed -e "s|${DOTFILES_DIR}\/||")" ]] ; then
            echo -ne "Updating: ${Dotfile}"\\r
          else
            echo -ne "Installing: ${Dotfile}"\\r
          fi

          # TODO: add logic to prevent from following symlinked directory paths,
          #       may not be necessary
          KRATOS::Lib:ensure.file_destroy \
            "${HOME}/.$(
              echo "${Dotfile}" |
                sed -e "s|${DOTFILES_DIR}\/||"
            )" || {
            KRATOS::Lib:err.error \
              "failed to remove: ${HOME}/.$(
                echo "${Dotfile}" |
                  sed -e "s|${DOTFILES_DIR}\/||"
              )"
            return 1
          }

          # Symlink DOTFILE
          KRATOS::Lib:symlink \
            "${Dotfile}" "${HOME}/.$(
              echo "${Dotfile}" |
                sed -e "s|${DOTFILES_DIR}\/||"
            )" || {
            KRATOS::Lib:err.error \
              "failed to symlink \`${Dotfile}' to \`${HOME}/.$(
                echo "${Dotfile}" |
                  sed -e "s|${DOTFILES_DIR}\/||"
              )'"
            return 1
          }
        fi
      fi
    fi

    # POST-(Un)Install
    if ${Uninstall} ; then
      KRATOS::Modules:dotfiles.post_uninstall_hook "${Dotfile}" || return 1
    else
      KRATOS::Modules:dotfiles.post_install_hook "${Dotfile}" || return 1
    fi

  done
}
