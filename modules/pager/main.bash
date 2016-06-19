# This file is part of Kratos.
# Copyright (c) 2014-2016, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

Pager::KnownExecutables() {
  local Bin
  local -a Bins
  local Pager

  Bins=(
    'less'
    'most'
    'more'
  )

  # find installed pagers
  for Bin in "${Bins[@]}" ; do
    Path::Check "${Bin}" && {
      echo "${Bin}"
      return 0
    }
  done

  Error::Message 'no pagers installed'
  return 1
}

Pager::Preferred() {
  local PreferredPager

  for PreferredPager in "${KRATOS_PAGER_PREFERENCE[@]}" ; do
    if Path::Check "${PreferredPager}" ; then
      echo "KRATOS_PREFERRED_PAGER=\"${PreferredPager}\"" >> \
        "${HOME}/.local/share/kratos/preferences"
      return 0
    fi
  done

  Error::Message 'no preferred pager found'
  return 1
}

Pager::EnvVar() {
  if [[ -z "${KRATOS_PREFERRED_PAGER}" ]] ; then
    KRATOS_PREFERRED_PAGER="$(Pager::KnownExecutables)"
  fi

  case "${KRATOS_PREFERRED_PAGER}" in
    'less')
      export LESS='--RAW-CONTROL-CHARS'
      export LESSCHARSET='utf-8'
      unset LESS_IS_MORE # disabled

      # Blink (& fg color)
      export LESS_TERMCAP_mb="$(
        printf "${KCLR_BLINK}"
        printf "${KRATOS_FG_COLOR_3}"
      )"
      # Bold (& fg color)
      export LESS_TERMCAP_md="$(
        printf "${KCLR_BOLD}"
        printf "${KCLR_FG_7}"
      )"
      # Reset bold, blink, and underline (& fg color)
      export LESS_TERMCAP_me=$(
        printf "${KCLR_RESET_BOLD}"
        printf "${KCLR_RESET_BLINK}"
        printf "${KCLR_RESET_UNDERLINE}"
        printf "${KCLR_FG_RESET}"
      )
      # Standout (& fg color & bg color)
      export LESS_TERMCAP_so=$(
        printf "${KCLR_BOLD}"
        printf "${KCLR_FG_8}"
        printf "${KCLR_BG_2}"
      )
      # Stop standout
      export LESS_TERMCAP_se=$(
        printf "${KCLR_RESET_BOLD}"
        printf "${KCLR_FG_RESET}"
        printf "${KCLR_BG_RESET}"
      )
      # Bold & underline (& fg color)
      export LESS_TERMCAP_us=$(
        printf "${KCLR_BOLD}"
        printf "${KCLR_UNDERLINE}"
        printf "${KCLR_FG_4}"
      )
      # Stop underline
      export LESS_TERMCAP_ue=$(
        printf "${KCLR_RESET_BOLD}"
        printf "${KCLR_RESET_UNDERLINE}"
        printf "${KCLR_FG_RESET}"
      )
      # Invert foreground & background
      export LESS_TERMCAP_mr=$(
        printf "${KCLR_INVERT}"
      )
      # Dim
      export LESS_TERMCAP_mh=$(
        printf "${KCLR_DIM}"
      )

      # some terminals don't understand SGR escape sequences
      export GROFF_NO_SGR=1
      ;;
  esac

  export PAGER="${KRATOS_PREFERRED_PAGER}"
  export MANPAGER="${PAGER}"
}
