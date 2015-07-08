# This file is part of Kratos.
# Copyright (c) 2014-2015, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

function shells_tmp { # Create the temporary history file for the shell

  local TMP

  if TMP="$(dir_tmp)" ; then
    export HISTFILE="$TMP/history.$(shell_nov)"
    export HISTSIZE=10000
    export SAVEHIST=10000
  else
    export HISTFILE="/dev/null"
    export HISTSIZE=0
    export SAVEHIST=0
  fi

  if [[ "$(shell_nov)" == 'bash' || "$(shell_nov)" == 'ksh' ]] ; then
    shopt -s histappend
  elif [[ "$(shell_nov)" == 'zsh' ]] ; then
  	setopt append_history
  fi

}
shells_tmp
alias h='history'

# Not sure what this crap does
function hs {
    history | grep $*
}

alias hsi='hs -i'