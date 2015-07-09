# This file is part of Kratos.
# Copyright (c) 2014-2015, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

# http://en.wikipedia.org/wiki/Comparison_of_command_shells

shells_theme() { # Setup the theme for the shell

  [ "$(shell_nov)" = "fish" ] && return 0

  # Colors for LS
  case "$(os_kernel)" in
    'linux'|'cygwin')
      eval "$(dircolors -b)"
      alias ls='ls --color=auto'
      ;;
    'freebsd')
      export CLICOLOR=1
      export LSCOLORS="ExGxFxdxCxDhDxaBadaCeC"
      ;;
  esac

  # 256 Colors in the Terminal
  if [ "$TERM" = "xterm" ] || [ "$TERM" = "rxvt-unicode-256color" ] ; then
    export TERM="xterm-256color"
    unset COLORTERM
  fi

  # Setup Special Colors
  if user_root ; then
    NCOLOR="$(prompt_color cyan 0)"
  else
    NCOLOR="$(prompt_color white 1)"
  fi

  DCOLOR="$(prompt_color yellow 1)"

}
