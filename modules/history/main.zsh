# This file is part of Kratos.
# Copyright (c) 2014-2015, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

function history_shell {

  # Create the temporary history file for the shell

  if [[ -d "${HOME}/.cache" ]] ; then
    export HISTFILE="${HOME}/.cache/history.$(shell)"
    export HISTSIZE=10000
    export SAVEHIST=10000
  else
    export HISTFILE="/dev/null"
    export HISTSIZE=0
    export SAVEHIST=0
  fi

  setopt append_history

}

# Show history
case "${HIST_STAMPS}" in
  'mm/dd/yyyy')
    alias history='fc -fl 1'
    ;;
  'dd.mm.yyyy')
    alias history='fc -El 1'
    ;;
  'yyyy-mm-dd')
    alias history='fc -il 1'
    ;;
  *)
    alias history='fc -l 1'
    ;;
esac

setopt append_history
setopt extended_history
setopt hist_expire_dups_first
setopt hist_ignore_dups # ignore duplication command history list
setopt hist_ignore_space
setopt hist_verify
setopt inc_append_history
setopt share_history # share command history data

alias h='history'

# Not sure what this crap does
function hs {
  history | grep "$*"
}

alias hsi='hs -i'
