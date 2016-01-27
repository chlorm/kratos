# This file is part of Kratos.
# Copyright (c) 2014-2015, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

git_cd() {

  if [ -z "$1" ] ; then
    cd "$KRATOS_DIR"
  else
    cd "$1"
  fi

}

git_cbr() {

  # Gets the current git branch

  git_cd $1 || return 1

  git rev-parse --abbrev-ref HEAD 2> /dev/null

}

git_pull() {

  # Updates the root git tree

  # Returns 2 if failed, 1 if updated, 0 if up-to-date

  git_cd $1 || return 2

  git reset --hard > /dev/null 2>&1

  STR="$(git pull origin "$(git_cbr $1)" 2>&1)" || return 2

  [ "$(echo "$STR" | grep 'Already up-to-date.')" != "" ]

}

git_pull_nostat() {

  # Updates the root git tree and only returns >0 on error

  git_pull $@
  case $? in
    2)
      return 1
      ;;
    1)
      echo "Updated"
      ;;
  esac

}

git_sub_init() {

  # Initialize git submodules

  # Returns 2 if failed, 1 if initialized, 0 if up-to-date

  local ACUM

  ACUM=0

  git_cd $1 || return 2

  array_from_str SUBS "$(git submodule status --recursive | grep -ve "([^)]*)" | awk '{print $2}')"

  array_forall SUBS git_sub_init_one || return 2

  return $ACUM

}

git_sub_init_one() {

  git submodule -q update --init --recursive "$1" || return 1

  ACUM=1

}


git_sub_pull() {

  # Update the submodules

  # Returns 2 if failed, 1 if updated, 0 if up-to-date

  git_cd $1 || return 2

  STR="$(git submodule -q foreach --recursive "\"$KRATOS_DIR/bin/run\" git_pull_nostat .")" || return 2

  [ "$(echo "$STR" | grep 'Updated')" = "" ]

}

dotfiles_latest() {

  # Gets the latest version of the dotfiles

  # Returns 2 if failed, 1 if updated, 0 if up-to-date

  local ACUM

  ACUM=0

  git_pull
  case $? in
    2)
      ErrError "Failed to update the configuration directory"
      return 2
      ;;
    1)
      ACUM=1
      ;;
  esac

  git_sub_init
  case $? in
    2)
      ErrError "Failed to initialize configuration submodules"
      return 2
      ;;
    1)
      ACUM=1
      ;;
  esac

  git_sub_pull
  case $? in
    2)
      ErrError "Failed to update configuration submodules"
      return 2
      ;;
    1)
      ACUM=1
      ;;
  esac

  return $ACUM

}

dotfiles_update() {

  # Updates dotfiles and submodules

  dotfiles_latest
  case $? in
    2)
      return 2
      ;;
    1)
      reload_all
      dotfiles_install
      ;;
  esac

}

function KratosLogo {

cat <<'EOF'

  oooo    oooo                        .
  `888   .8P'                       .o8
   888  d8'    oooo d8b  .oooo.   .o888oo  .ooooo.   .oooo.o
   88888[      `888""8P `P  )88b    888   d88' `88b d88(  "8
   888`88b.     888      .oP"888    888   888   888 `"Y88b.
   888  `88b.   888     d8(  888    888 . 888   888 o.  )88b
  o888o  o888o d888b    `Y888""8o   "888" `Y8bod8P' 8""888P'

EOF

}

function kratos {

  local DIR
  local KRATOS_CREATE_DIRS

  KRATOS_CREATE_DIRS=()

  case "${1}" in
    'update')
      KratosLogo

      # Generate the pre-fligt checks files
      echo "Pre-flight checks: "
      source "${KRATOS_DIR}/lib/pre-flight-checks.zsh"

      KRATOS_PROJECT_DIRS=(
        "${HOME}/Projects"
      )

      # Freedesktop trash directories
      KRATOS_TRASH_DIRS=(
        "${HOME}/.local/share/trash/info"
        "${HOME}/.local/share/trash/files"
      )

      # XDG freedesktop directories
      KRATOS_XDG_DIRS=(
        "${HOME}/.cache" # XDG_CACHE_HOME
        "${HOME}/.config" # XDG_CONFIG_HOME
        "${HOME}/.local/share" # XDG_DATA_HOME
        "${HOME}/Desktop" # XDG_DESKTOP_DIR
        "${HOME}/Documents" # XDG_DOCUMENTS_DIR
        "${HOME}/Downloads" # XDG_DOWNLOAD_DIR
        "${HOME}/Music" # XDG_MUSIC_DIR
        "${HOME}/Pictures" # XDG_PICTURES_DIR
        "${HOME}/Share" # XDG_PUBLICSHARE_DIR
        "${HOME}/Templates" # XDG_TEMPLATES_DIR
        "${HOME}/Videos" # XDG_VIDEOS_DIR
      )

      if [[ ${#KRATOS_CREATE_CUSTOM_DIRECTOIES[@]} -ge 1 ]] ; then
        KRATOS_CREATE_DIRS+=( ${KRATOS_CREATE_CUSTOM_DIRECTOIES[@]} )
      fi

      if ${KRATOS_CREATE_PROJECT_DIRECTORIES} ; then
        KRATOS_CREATE_DIRS+=( ${KRATOS_PROJECT_DIRS[@]} )
      fi

      if ${KRATOS_CREATE_TRASH_DIRECTORIES} ; then
        KRATOS_CREATE_DIRS+=( ${KRATOS_TRASH_DIRS[@]} )
      fi

      if ${KRATOS_CREATE_XDG_DIRECTORIES} ; then
        KRATOS_CREATE_DIRS+=( ${KRATOS_XDG_DIRS[@]} )
      fi

      KRATOS_CREATE_DIRS+=( "${HOME}/.local/share/kratos" )

      echo -ne "Updating directories: "
      for DIR in ${KRATOS_CREATE_DIRS[@]} ; do
        if [[ ! -d "${DIR}" ]] ; then
          echo -ne "Creating directory: ${DIR}"\\r
        fi
        EnsureDirExists "${DIR}" || {
          ErrError "failed to create directory: ${DIR}"
          return 1
        }
      done
      echo "Success"

      #git remote set-url origin "$DOTFILES_REPO"
      #git remote set-url --push origin "$DOTFILES_REPO"
      #dotfiles_latest

      echo "export KRATOS_DIR=\"${KRATOS_DIR}\"" > "${HOME}/.local/share/kratos/dir"

      # Install dotfiles
      # TODO: Only run if module is enabled
      echo -n "Updating dotfiles: "
      echo
      DotfilesHook || exit 1
      echo -ne ''\\r
      echo "Success"

      # Load settings
      if [[ -f "${HOME}/.config/kratos/config" ]] ; then
        . "${HOME}/.config/kratos/config"
        # Preference
        EnsureFileDestroy "${HOME}/.local/share/kratos/preferences"
        EnsureFileExists "${HOME}/.local/share/kratos/preferences"
        EditorPreferred
      fi

      symlink "${KRATOS_DIR}/rc/profile" "${HOME}/.profile"

      symlink "${KRATOS_DIR}/rc/bashrc" "${HOME}/.bashrc"
      symlink "${KRATOS_DIR}/rc/bash_profile" "${HOME}/.bash_profile"
      symlink "${KRATOS_DIR}/rc/bash_logout" "${HOME}/.bash_logout"

      symlink "${KRATOS_DIR}/rc/kshrc" "${HOME}/.kshrc"

      symlink "${KRATOS_DIR}/rc/zshrc" "${HOME}/.zshrc"
      symlink "${KRATOS_DIR}/rc/zprofile" "${HOME}/.zprofile"
      symlink "${KRATOS_DIR}/rc/zlogout" "${HOME}/.zlogout"

      symlink "${KRATOS_DIR}/rc/xinitrc" "${HOME}/.xinitrc"
      symlink "${KRATOS_DIR}/rc/xprofile" "${HOME}/.xprofile"
      symlink "${KRATOS_DIR}/rc/xsession" "${HOME}/.xsession"
      ;;
    'upgrade')
      ;;
    #'uninstall'
  esac

}
