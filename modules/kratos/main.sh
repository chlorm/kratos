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
      ErrError "Failed to update the configuration directory"
      return 2
      ;;
    1)
      ACUM=1
      ;;
  esac

  git_sub_init
  case "$?" in
    2)
      ErrError "Failed to initialize configuration submodules"
      return 2
      ;;
    1)
      ACUM=1
      ;;
  esac

  git_sub_pull
  case "$?" in
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

# TODO: Don't use $DISPLAY at install time to detect if the environment is graphical
function KratosPreferredDeskenv {

  for _DESKENV in "${DESKENVS_PREFERENCE[@]}" ; do
    if PathHasBin "$(deskenvs_executable $DESKENV)" ; then
      echo "PREFERRED_DE=$DESKENV" >> "$HOME/.local/share/kratos/preferences"
      return 0
    fi
  done

  ErrWarn "no preferred deskenvs found"

  return 1

  return 0

}

function kratosPreferredEditor {

  for _EDITOR in "${EDITORS_PREFERENCE[@]}" ; do
    if PathHasBin "$_EDITOR" ; then
      echo "PREFERRED_EDITOR=\"$_EDITOR\"" >> "$HOME/.local/share/kratos/preferences"
      return 0
    fi
  done

  ErrWarn "no preferred editors found"

  return 1

}

function KratosPreferredShell {

  for _SHELL in "${SHELLS_PREFERENCE[@]}" ; do
    if PathHasBin "$_SHELL" ; then
      echo "PREFERRED_SHELL=\"$_SHELL\"" >> "$HOME/.local/share/kratos/preferences"
      return 0
    fi
  done

  ErrWarn "no preferred shells found"

  return 1

}

function kratos {

  echo

}
