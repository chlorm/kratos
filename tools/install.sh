#!/usr/bin/env sh

# This file is part of Kratos.
# Copyright (c) 2014-2015, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

export KRATOS_DIR="$(readlink -f "$(dirname "$(readlink -f "$0")")")/../"
export DOTFILES_DIR="$HOME/.dotfiles"

load_one() { # Source Modules

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

load_all "lib"

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

git_cd() {

  if [ -z "$1" ] ; then
    cd "$KRATOS_DIR"
  else
    cd "$1"
  fi

}

git_cbr() { # Gets the current git branch

  git_cd $1 || return 1

  git rev-parse --abbrev-ref HEAD 2> /dev/null

}

git_pull() { # Updates the root git tree

  # Returns 2 if failed, 1 if updated, 0 if up-to-date

  git_cd $1 || return 2

  git reset --hard > /dev/null 2>&1

  STR="$(git pull origin "$(git_cbr $1)" 2>&1)" || return 2

  [ "$(echo "$STR" | grep 'Already up-to-date.')" != "" ]

}

git_pull_nostat() { # Updates the root git tree and only returns >0 on error

  git_pull $@
  case "$?" in
    2)
      return 1
      ;;
    1)
      echo "Updated"
      ;;
  esac

}

git_sub_init() { # Initialize git submodules

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


git_sub_pull() { # Update the submodules

  # Returns 2 if failed, 1 if updated, 0 if up-to-date

  git_cd $1 || return 2

  STR="$(git submodule -q foreach --recursive "\"$KRATOS_DIR/bin/run\" git_pull_nostat .")" || return 2

  [ "$(echo "$STR" | grep 'Updated')" = "" ]

}

dotfiles_latest() { # Gets the latest version of the dotfiles

  # Returns 2 if failed, 1 if updated, 0 if up-to-date

  local ACUM

  ACUM=0

  git_pull
  case "$?" in
    2)
      echo "Failed to update the configuration directory" >&2
      return 2
      ;;
    1)
      ACUM=1
      ;;
  esac

  git_sub_init
  case "$?" in
    2)
      echo "Failed to initialize configuration submodules" >&2
      return 2
      ;;
    1)
      ACUM=1
      ;;
  esac

  git_sub_pull
  case "$?" in
    2)
      echo "Failed to update configuration submodules" >&2
      return 2
      ;;
    1)
      ACUM=1
      ;;
  esac

  return $ACUM

}

dotfiles_update() { # Updates dotfiles and submodules

  dotfiles_latest
  case "$?" in
    2)
      return 2
      ;;
    1)
      reload_all
      dotfiles_install
      ;;
  esac

}

if [ -z "$KRATOS_DIR" ] ; then
  echo "ERROR: kratos remote repo origin is not set"
  exit 1
fi

#git remote set-url origin "$DOTFILES_REPO"
#git remote set-url --push origin "$DOTFILES_REPO"

#dotfiles_latest

exist -dc "$HOME/.local/share/dotfiles"

echo "export KRATOS_DIR=\"$KRATOS_DIR\"" > "$HOME/.local/share/dotfiles/dir"

exist -fx "$HOME/.local/share/dotfiles/preferences"

touch "$HOME/.local/share/dotfiles/preferences"

# Preference
find_shell() {

  for _SHELL in "${SHELLS_PREFERENCE[@]}" ; do
    if path_hasbin "$_SHELL" ; then
      echo "PREFERED_SHELL=\"$_SHELL\"" >> "$HOME/.local/share/dotfiles/preferences"
      return 0
    fi
  done

  return 1

}
find_shell || echo "WARNING: no prefered SHELL found"

find_editor() {

  for _EDITOR in "${EDITORS_PREFERENCE[@]}" ; do
    if path_hasbin "$_EDITOR" ; then
      echo "PREFERED_EDITOR=\"$_EDITOR\"" >> "$HOME/.local/share/dotfiles/preferences"
      return 0
    fi
  done

  return 1

}
find_editor || echo "WARNING: no prefered EDITOR found"

find_deskenv() {

  if [ -n "$DISPLAY" ] ; then
    for _DESKENV in "${DESKENVS_PREFERENCE[@]}" ; do
      if path_hasbin "$(deskenvs_executable $DESKENV)" ; then
        echo "PREFERED_DE=$DESKENV" >> "$HOME/.local/share/dotfiles/preferences"
        return 0
      fi
    done

    return 1
  fi

  return 0

}
find_deskenv || echo "WARNING: no prefered DESKENV found"

# TODO:
# + Always create directories, never symlink, only symlink files

install_dotfiles() {

  local DIRS
  local DIR
  local FILE
  local SKIP_DIRS=()
  local DONT_SYM
  local SKIP_DIR
  local IGNORE

  DIRS=($(find $DOTFILES_DIR -type d -not -iwholename '*.git*'))
  # TODO: add check for trailing slash or something to make sure it is a dir
  #  before adding it to the array, however it currently only contains dirs
  DONT_SYM_LIST=($(cat "$DOTFILES_DIR/.kratosdontsym"))

  for DIR in "${DIRS[@]}" ; do
    DONT_SYM=false

    for DONT_SYM_ITEM in "${DONT_SYM_LIST[@]}" ; do
      if [[ "$DIR" == "$DOTFILES_DIR/${DONT_SYM_ITEM%/}" ]] ; then
        DONT_SYM=true
        break
      fi
    done

    FILES=()

    if [ "$DONT_SYM" = true ] ; then
      FILES=($(find $DIR -maxdepth 1 -type f))
      for FILE in "${FILES[@]}" ; do
        FILE_IGNORES=($(cat "$DOTFILES_DIR/.kratosignore") '.kratosignore' '.kratosdontsym')
        for FILE_IGNORE in "${FILE_IGNORES[@]}" ; do
          if [ "$(basename "$FILE")" == "$FILE_IGNORE" ] ; then
            continue
          fi
        done


        # Currently executes all before, but in the future should respect
        #  install-port, and .install should override the install phase.
        case "${FILE##*.}" in
          '.install-pre')
            . "$FILE"
            continue
            ;;
          'install')
            . "$FILE"
            continue
            ;;
          'install-post')
            . "$FILE"
            continue
            ;;
        esac


        IGNORE=false

        if [ -f "$DIR/.kratos" ] ; then
          if [ -n "$(grep "ignore=$(basename $FILE)" $DIR/.kratos)" ] ; then
            IGNORE=true
          fi
        fi

        if [[ "$(basename $DIR)" =~ ^\. ]] ; then
          IGNORE=true
        fi

        if [ "$IGNORE" = false ] && [ -z "$(echo "$FILE" | grep ".kratos")" ] ; then
          exist -fx "$HOME/.$(echo "$FILE" | sed -e "s|$DOTFILES_DIR\/||")"
          # Symlink FILE
          symlink "$FILE" "$HOME/.$(echo "$FILE" | sed -e "s|$DOTFILES_DIR\/||")"
        fi
      done
    else
      # TODO: fix this to match files correctly
      if [[ "$(basename "$DIR")" == '.dotfiles' ]] ; then
        continue
      elif [[ "$(basename $DIR)" =~ ^\. ]] ; then
        SKIP_DIRS+=("$DIR")
        continue
      fi

      SKIP_DIR=false
      for SYMD_DIR in "${SKIP_DIRS[@]}" ; do
        # If the current $DIR exists in $SYMD_DIR
        if [[ -n "$(echo $DIR | grep "$SYMD_DIR")" ]] ; then
          # If the $SYMD_DIR is a subdirectory of $DIR (Needs to remove anything before match to be sure)
          if [ -n "$(echo $SYMD_DIR | sed -e "s|$DIR||")" ] ; then
            SKIP_DIR=true
            continue
          fi
        fi
      done

      if [ "$SKIP_DIR" = false ] ; then
        exist -dx "$HOME/.$(echo "$DIR" | sed -e "s|$DOTFILES_DIR\/||")"
        # Symlink DIR
        symlink "$DIR" "$HOME/.$(echo "$DIR" | sed -e "s|$DOTFILES_DIR\/||")"
        SKIP_DIRS+=("$DIR")
      fi
    fi

  done

  return 0

}
install_dotfiles

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
