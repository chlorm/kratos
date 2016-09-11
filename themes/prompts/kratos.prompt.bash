# This file is part of Kratos.
# Copyright (c) 2016, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

# Determine if the current directory is a vcs repo
Prompts::Kratos.vcs() {
  local VcsIsRepo
  local VcsBranch
  local VcsStatus
  local VcsCheckout

  if ${PathHasBinGIT} ; then
    if VcsIsRepo=$(git status 2>&1) ; then
      VcsCheckoutBranch="$(
        echo "${VcsIsRepo}" | awk '/On branch/ {for(i=3;i<=NF;++i)print $i}'
      )"
      VcsCheckoutCommit="$(
        echo "${VcsIsRepo}" | awk '/HEAD detached at/ {print $4 ; exit}'
      )"
      VcsStatus="$(
        if [ -z "$(echo ${VcsIsRepo} |
          grep -m 1 -w -o 'working directory clean')" ] ; then
          echo "*"
        fi
      )"
      if [ -n "${VcsCheckoutCommit}" ] ; then
        VcsCheckout="$(kprmt underline)${VcsCheckoutCommit}$(kprmt reset)"
      else
        VcsCheckout="${VcsCheckoutBranch}"
      fi
      echo -e "${KCLR_FG_11}git$(kprmt bold)$(kprmt f1)∫$(kprmt f16)${VcsCheckout}${VcsStatus}$(kprmt reset)"
    fi
  fi

  #  if hg status > /dev/null 2>&1 ; then
  #    echo "hg"
  #    return 0
  #  fi

  #  if bzr root > /dev/null 2>&1 ; then
  #    echo "bzr"
  #    return 0
  #  fi

  #  if svn info > /dev/null 2>&1 ; then
  #    echo "svn"
  #    return 0
  #  fi

  #  if cvs status > /dev/null 2>&1 ; then
  #    echo "cvs"
  #    return 0
  #  fi

  return 0
}

KRATOS_PROMPT_1='$(kprmt f11)\\u$(kprmt bold)$(kprmt f1)@$(kprmt bold)$(kprmt ${SSH_CLIENT:+f10}${SSH_CLIENT:-f16})\\H$(kprmt f1)[$(kprmt reset)$(kprmt f2)\\w$(kprmt bold)$(kprmt f1)]\\$(Prompts::Kratos.vcs)$(kprmt f7)〉$(kprmt reset)'
KRATOS_PROMPT_2=''
KRATOS_PROMPT_3=''
KRATOS_PROMPT_4=''
KRATOS_RPROMPT_1=''
KRATOS_RPROMPT_2=''
