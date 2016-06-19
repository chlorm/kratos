# This file is part of Kratos.
# Copyright (c) 2014-2016, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

# Create the temporary history file for the shell
History::Shell() {
  if [ -d "${HOME}/.cache" ] ; then
    export HISTFILE="${HOME}/.cache/kratos/history.bash"
    export HISTSIZE=10000
    export SAVEHIST=10000
  else
    export HISTFILE="/dev/null"
    export HISTSIZE=0
    export SAVEHIST=0
  fi

  ###setopt append_history
  ###setopt extended_history
  ###setopt hist_expire_dups_first
  # ignore duplication command history list
  ###setopt hist_ignore_dups
  ###setopt hist_ignore_space
  ###setopt hist_verify
  ###setopt inc_append_history
  # share command history data
  ###setopt share_history
}

History::Command() {
  history | grep "$*"
}
