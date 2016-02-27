# This file is part of Kratos.
# Copyright (c) 2014-2016, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

# KRATOS_UPDATER_AUTO
# KRATOS_UPDATER_DOTFILES
# TODO: Add a github snapshot tarball option

git_cd() {
  if [ -z "$1" ] ; then
    cd "$KRATOS_DIR"
  else
    cd "$1"
  fi
}

# Gets the current git branch
KRATOS::Modules:updater.git_current_branch() {
  git_cd $1 || return 1

  git rev-parse --abbrev-ref HEAD 2> /dev/null
}

# Updates the root git tree
KRATOS::Modules:updater.git_pull() {
  # Returns 2 if failed, 1 if updated, 0 if up-to-date

  local CurrentBranch

  git_cd $1 || return 2

  CurrentBranch="$(KRATOS::Modules:updater.git_current_branch $1)" || return 2

  git reset --hard > /dev/null 2>&1

  STR="$(git pull origin "${CurrentBranch}" 2>&1)" || return 2

  [ "$(echo "$STR" | grep 'Already up-to-date.')" != "" ]
}

# Updates the root git tree and only returns >0 on error
KRATOS::Modules:updater.git_pull_nostat() {
  KRATOS::Modules:updater.git_pull $@
  case $? in
    2)
      return 1
      ;;
    1)
      echo "Updated"
      ;;
  esac
}

# Initialize git submodules
KRATOS::Modules:updater.git_sub_init() {
  # Returns 2 if failed, 1 if initialized, 0 if up-to-date

  local ACUM

  ACUM=0

  git_cd $1 || return 2

  array_from_str SUBS "$(git submodule status --recursive | grep -ve "([^)]*)" | awk '{print $2}')"

  array_forall SUBS git_sub_init_one || return 2

  return $ACUM
}

KRATOS::Modules:updater.git_sub_init_one() {
  git submodule -q update --init --recursive "$1" || return 1

  ACUM=1
}

# Update the submodules
KRATOS::Modules:updater.git_sub_pull() {
  # Returns 2 if failed, 1 if updated, 0 if up-to-date

  git_cd $1 || return 2

  STR="$(git submodule -q foreach --recursive "\"$KRATOS_DIR/bin/run\" git_pull_nostat .")" || return 2

  [ "$(echo "$STR" | grep 'Updated')" = "" ]
}

# Gets the latest version of the dotfiles
KRATOS::Modules:updater.dotfiles_latest() {
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

# Updates dotfiles and submodules
KRATOS::Modules:updater.dotfiles_update() {
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