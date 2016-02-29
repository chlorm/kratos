# This file is part of Kratos.
# Copyright (c) 2014-2016, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

# Wrap ANSI color codes in ZSH %{%} escape sequences
KRATOS::Modules:prompt.color_wrapped() {
  echo -n '%{'
  case "${1}" in
    f1) echo -n "${KCLR_FG_1}" ;;
    f2) echo -n "${KCLR_FG_2}" ;;
    f3) echo -n "${KCLR_FG_3}" ;;
    f4) echo -n "${KCLR_FG_4}" ;;
    f5) echo -n "${KCLR_FG_5}" ;;
    f6) echo -n "${KCLR_FG_6}" ;;
    f7) echo -n "${KCLR_FG_7}" ;;
    f8) echo -n "${KCLR_FG_8}" ;;
    f9) echo -n "${KCLR_FG_9}" ;;
    f10) echo -n "${KCLR_FG_10}" ;;
    f11) echo -n "${KCLR_FG_11}" ;;
    f12) echo -n "${KCLR_FG_12}" ;;
    f13) echo -n "${KCLR_FG_13}" ;;
    f14) echo -n "${KCLR_FG_14}" ;;
    f15) echo -n "${KCLR_FG_15}" ;;
    f16) echo -n "${KCLR_FG_16}" ;;
    b1) echo -n "${KCLR_BG_1}" ;;
    b2) echo -n "${KCLR_BG_2}" ;;
    b3) echo -n "${KCLR_BG_3}" ;;
    b4) echo -n "${KCLR_BG_4}" ;;
    b5) echo -n "${KCLR_BG_5}" ;;
    b6) echo -n "${KCLR_BG_6}" ;;
    b7) echo -n "${KCLR_BG_7}" ;;
    b8) echo -n "${KCLR_BG_8}" ;;
    b9) echo -n "${KCLR_BG_9}" ;;
    b10) echo -n "${KCLR_BG_10}" ;;
    b11) echo -n "${KCLR_BG_11}" ;;
    b12) echo -n "${KCLR_BG_12}" ;;
    b13) echo -n "${KCLR_BG_13}" ;;
    b14) echo -n "${KCLR_BG_14}" ;;
    b15) echo -n "${KCLR_BG_15}" ;;
    b16) echo -n "${KCLR_BG_16}" ;;
    bold) echo -n "${KCLR_BOLD}" ;;
    dim) echo -n "${KCLR_DIM}" ;;
    underline) echo -n "${KCLR_UNDERLINE}" ;;
    blink) echo -n "${KCLR_BLINK}" ;;
    invert) echo -n "${KCLR_INVERT}" ;;
    hidden) echo -n "${KCLR_HIDDEN}" ;;
    reset) echo -n "${KCLR_RESET}" ;;
  esac
  echo -n '%}'
}

KRATOS::Modules:prompt.configure() {
  local Ncolor

  # Setup Special Colors
  if KRATOS::Lib:is_root ; then
    Ncolor="$(KRATOS::Modules:prompt.color_wrapped bold)$(KRATOS::Modules:prompt.color_wrapped f2)"
  else
    Ncolor="$(KRATOS::Modules:prompt.color_wrapped 3)"
  fi

  # Allow evaluating functions within the prompt
  setopt PROMPT_SUBST

  # Must use single quotes to delay evaluation
  eval export PROMPT='${KRATOS_PROMPT_1}'
  eval export PROMPT2='${KRATOS_PROMPT_2}'
  eval export PROMPT3='${KRATOS_PROMPT_3}'
  eval export PROMPT4='${KRATOS_PROMPT_4}'
  eval export RPROMPT='${KRATOS_RPROMPT_1}'
  eval export RPROMPT2='${KRATOS_RPROMPT_2}'
}
