# This file is part of Kratos.
# Copyright (c) 2014-2016, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

Kratos::Logo() {
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

Kratos::Command() {
  local Dir
  local -a KratosCreateDirs
  local -a KratosProjectDirs
  local -a KratosTrashDirs
  local -a KratosXdgDirs

  KratosCreateDirs=()

  case "${1}" in
    'update')
      # Generate the pre-fligt checks files
      source "${KRATOS_DIR}/lib/pre-flight-checks.bash"

      KratosProjectDirs=(
        "${HOME}/Projects"
      )

      # Freedesktop trash directories
      KratosTrashDirs=(
        "${HOME}/.local/share/trash/info"
        "${HOME}/.local/share/trash/files"
      )

      # XDG freedesktop directories
      KratosXdgDirs=(
        # Handled by the cache module
        #"${HOME}/.cache" # XDG_CACHE_HOME
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
        KratosCreateDirs+=( ${KRATOS_CREATE_CUSTOM_DIRECTOIES[@]} )
      fi

      if ${KRATOS_CREATE_PROJECT_DIRECTORIES} ; then
        KratosCreateDirs+=( ${KratosProjectDirs[@]} )
      fi

      if ${KRATOS_CREATE_TRASH_DIRECTORIES} ; then
        KratosCreateDirs+=( ${KratosTrashDirs[@]} )
      fi

      if ${KRATOS_CREATE_XDG_DIRECTORIES} ; then
        KratosCreateDirs+=( ${KratosXdgDirs[@]} )
      fi

      KratosCreateDirs+=( "${HOME}/.local/share/kratos" )

      for Dir in ${KratosCreateDirs[@]} ; do
        Directory::Create "${Dir}"
      done

      #git remote set-url origin "$DOTFILES_REPO"
      #git remote set-url --push origin "$DOTFILES_REPO"
      #dotfiles_latest

      echo "export KRATOS_DIR=\"${KRATOS_DIR}\"" > "${HOME}/.local/share/kratos/dir"

      # Install dotfiles
      # TODO: Only run if module is enabled
      Dotfiles::Hook

      # Load settings
      if [ -f "${HOME}/.config/kratos/config" ] ; then
        source "${HOME}/.config/kratos/config"
        # Preference
        File::Remove "${HOME}/.local/share/kratos/preferences"
        File::Create "${HOME}/.local/share/kratos/preferences"
        Editor::Preferred
      fi

      Symlink::Create "${KRATOS_DIR}/rc/profile" "${HOME}/.profile"

      Symlink::Create "${KRATOS_DIR}/rc/bashrc" "${HOME}/.bashrc"
      Symlink::Create "${KRATOS_DIR}/rc/bash_profile" "${HOME}/.bash_profile"

      Symlink::Create "${KRATOS_DIR}/rc/kshrc" "${HOME}/.kshrc"

      Symlink::Create "${KRATOS_DIR}/rc/zshrc" "${HOME}/.zshrc"
      Symlink::Create "${KRATOS_DIR}/rc/zprofile" "${HOME}/.zprofile"
      Symlink::Create "${KRATOS_DIR}/rc/zlogout" "${HOME}/.zlogout"
      ;;
    'upgrade')
      ;;
    #'uninstall'
  esac
}