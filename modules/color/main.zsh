# This file is part of Kratos.
# Copyright (c) 2014-2015, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

# Colors for `ls`
KRATOS::Modules:color.ls() {
  case "$(KRATOS::Lib:os.kernel)" in
    'linux'|'cygwin')
      eval "$(dircolors -b)"
      alias ls='ls --color=auto'
      ;;
    'freebsd')
      export CLICOLOR=1
      export LSCOLORS='ExGxFxdxCxDhDxaBadaCeC'
      ;;
  esac

  return 0
}

# TODO: fix this shit
KRATOS::Lib:color.term() {
  if [[ "${TERM}" == 'xterm' || "${TERM}" == 'rxvt-unicode-256color' ]] ; then
    # See if xterm supports 256 color
    if [[ -n "${VTE_VERSION}" ]] ; then
      export TERM='xterm-256color'
    fi
  fi

  return 0
}

KRATOS::Modules:color.set_scheme() {
  local Current
  local i

  for i in {1..16} ; do
    eval Current="\${KRATOS_COLOR_${i}}"
    # Terminal color codes start from zero, kratos starts from 1
    i=$(( ${i} - 1 ))
    printf "\033]4;${i};rgb:${Current}\033\\" || return 1
  done

  return 0
}
