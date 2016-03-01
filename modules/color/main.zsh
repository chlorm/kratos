# This file is part of Kratos.
# Copyright (c) 2014-2016, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

# Define variable for each terminal color/style code
KRATOS::Modules:color.define_colors() {
  KCLR_FG_1='\e[30m' # Black
  KCLR_FG_2='\e[31m' # Red
  KCLR_FG_3='\e[32m' # Green
  KCLR_FG_4='\e[33m' # Yellow
  KCLR_FG_5='\e[34m' # Blue
  KCLR_FG_6='\e[35m' # Magenta
  KCLR_FG_7='\e[36m' # Cyan
  KCLR_FG_8='\e[37m' # Light gray
  KCLR_FG_9='\e[90m' # Dark gray
  KCLR_FG_10='\e[91m' # Light red
  KCLR_FG_11='\e[92m' # Light green
  KCLR_FG_12='\e[93m' # Light yellow
  KCLR_FG_13='\e[94m' # Light blue
  KCLR_FG_14='\e[95m' # Light magenta
  KCLR_FG_15='\e[96m' # Light cyan
  KCLR_FG_16='\e[97m' # White
  KCLR_FG_RESET='\e[39m' # Reset foreground

  KCLR_BG_1='\e[40m' # Black
  KCLR_BG_2='\e[41m' # Red
  KCLR_BG_3='\e[42m' # Green
  KCLR_BG_4='\e[44m' # Yellow
  KCLR_BG_5='\e[44m' # Blue
  KCLR_BG_6='\e[45m' # Magenta
  KCLR_BG_7='\e[46m' # Cyan
  KCLR_BG_8='\e[47m' # Light gray
  KCLR_BG_9='\e[100m' # Dark gray
  KCLR_BG_10='\e[101m' # Light red
  KCLR_BG_11='\e[102m' # Light green
  KCLR_BG_12='\e[103m' # Light yellow
  KCLR_BG_13='\e[104m' # Light blue
  KCLR_BG_14='\e[105m' # Light magenta
  KCLR_BG_15='\e[106m' # Light cyan
  KCLR_BG_16='\e[107m' # White
  KCLR_BG_RESET='\e[49m' # Reset background

  KCLR_BOLD='\e[1m'
  KCLR_DIM='\e[2m'
  KCLR_UNDERLINE='\e[4m'
  KCLR_BLINK='\e[5m'
  KCLR_INVERT='\e[7m'
  KCLR_HIDDEN='\e[8m'

  KCLR_RESET='\e[0m'
  KCLR_RESET_BOLD='\e[21m'
  KCLR_RESET_DIM='\e[22m'
  KCLR_RESET_UNDERLINE='\e[24m'
  KCLR_RESET_BLINK='\e[25m'
  KCLR_RESET_INVERT='\e[27m'
  KCLR_RESET_HIDDEN='\e[28m'
}

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
KRATOS::Modules:color.term() {
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
