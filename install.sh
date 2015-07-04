#!/usr/bin/env bash

# This file is part of Kratos.
# Copyright (c) 2014-2015, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

# Initalize shell configuration
export KRATOS_DIR="$(readlink -f "$(dirname "$(readlink -f "$0")")")"
export DOTFILES_DIR="$HOME/.dotfiles"

. "$KRATOS_DIR/lib/core.sh" || exit 1

# Load settings
. "$KRATOS_DIR/dotfiles.conf" || exit 1
# Load local settings
if [ -f "$KRATOS_DIR/dotfiles.conf.local" ] ; then
  . "$KRATOS_DIR/dotfiles.conf.local"
else
  echo '#!/usr/bin/env sh' > "$KRATOS_DIR/dotfiles.conf.local"
fi

git_cd() {

  if [ -z "$1" ] ; then
    cd "$KRATOS_DIR"
  else
    cd "$1"
  fi

}

git_cbr() {( # Gets the current git branch

  git_cd $1 || return 1

  git rev-parse --abbrev-ref HEAD 2> /dev/null

)}

git_pull() {( # Updates the root git tree

  # Returns 2 if failed, 1 if updated, 0 if up-to-date

  git_cd $1 || return 2

  git reset --hard > /dev/null 2>&1

  STR="$(git pull origin "$(git_cbr $1)" 2>&1)" || return 2

  [ "$(echo "$STR" | grep 'Already up-to-date.')" != "" ]

)}

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

# Run individual installers
load_all "lib/installers"

exist -dc "$HOME/.local/share/dotfiles"

echo "export KRATOS_DIR=\"$KRATOS_DIR\"" > "$HOME/.local/share/dotfiles/dir"

exist -fx "$HOME/.local/share/dotfiles/preferences"

touch "$HOME/.local/share/dotfiles/preferences"

# Preference
find_shell() {

  local ITTR=0

  array_from_str _SHELLS "$SHELLS_PREFERENCE"

  for _SHELL in "$(array_at _SHELLS $ITTR)" ; do
    if path_hasbin "$_SHELL" ; then
      echo "PREFERED_SHELL=\"$_SHELL\"" >> "$HOME/.local/share/dotfiles/preferences"
      return 0
    fi

    if [ $ITTR -le $(((array_size TMPDIRS - 1))) ] ; then
      ITTR=$(($ITTR + 1))
    else
      break
    fi
  done

  return 1

}
find_shell || echo "WARNING: no prefered SHELL found"

find_editor() {

  local ITTR=0

  array_from_str _EDITORS "$EDITORS_PREFERENCE"

  for _EDITOR in "$(array_at _EDITORS $ITTR)" ; do
    if path_hasbin "$_EDITOR" ; then
      echo "PREFERED_EDITOR=\"$_EDITOR\"" >> "$HOME/.local/share/dotfiles/preferences"
      return 0
    fi

    if [ $ITTR -le $(((array_size TMPDIRS - 1))) ] ; then
      ITTR=$(($ITTR + 1))
    else
      break
    fi
  done

  return 1

}
find_editor || echo "WARNING: no prefered EDITOR found"

find_deskenv() {

  if [ -n "$DISPLAY" ] ; then

    local ITTR=0

    array_from_str DESKENVS "$DESKENVS_PREFERENCE"

    for _DESKENV in "$(array_at _DESKENV $ITTR)" ; do
      if path_hasbin "$(deskenvs_executable $DESKENV)" ; then
        echo "PREFERED_DE=$DESKENV" >> "$HOME/.local/share/dotfiles/preferences"
        return 0
      fi

      if [ $ITTR -le $(((array_size TMPDIRS - 1))) ] ; then
        ITTR=$(($ITTR + 1))
      else
        break
      fi
    done

    return 1
  fi

  return 0

}
find_deskenv || echo "WARNING: no prefered DESKENV found"
