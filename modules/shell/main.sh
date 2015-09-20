# This file is part of Kratos.
# Copyright (c) 2014-2015, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

# http://en.wikipedia.org/wiki/Comparison_of_command_shells

function ShellPreferred {

  for _SHELL in "${SHELLS_PREFERENCE[@]}" ; do
    if PathHasBin "${_SHELL}" ; then
      echo "PREFERRED_SHELL=\"${_SHELL}\"" >> "$HOME/.local/share/kratos/preferences"
      return 0
    fi
  done

  ErrWarn 'no preferred shells found'

  return 1

}

# Deprecated 
function ShellTheme {

  # Setup the theme for the shell

  [[ "$(shell)" == 'fish' ]] && return 0

  # Colors for LS
  case "$(OsKernel)" in
    'linux'|'cygwin')
      eval "$(dircolors -b)"
      alias ls='ls --color=auto'
      ;;
    'freebsd')
      export CLICOLOR=1
      export LSCOLORS='ExGxFxdxCxDhDxaBadaCeC'
      ;;
  esac

  # 256 Colors in the Terminal
#  if [ "$TERM" = "xterm" ] || [ "$TERM" = "rxvt-unicode-256color" ] ; then
#    export TERM="xterm-256color"
#    unset COLORTERM
#  fi

  # Setup Special Colors
  if IsRoot ; then
    NCOLOR="$(PromptColor cyan 0)"
  else
    NCOLOR="$(PromptColor white 1)"
  fi

  DCOLOR="$(PromptColor yellow 1)"

}

# Deprecated 
function ShellInit {

  export BLOCKSIZE='K'

  # Prevent GUI password dialog
  unset SSH_ASKPASS

}
