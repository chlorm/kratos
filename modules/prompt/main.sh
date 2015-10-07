# This file is part of Kratos.
# Copyright (c) 2014-2015, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

function PromptColor {

  # Get colors for the current shell

  echo -n '%{'

  case "${1}" in
    'black')
      if [ ${2} -eq 0 ] ; then
        echo -n '\e[0;30m'
      else
        echo -n '\e[1;30m'
      fi
      ;;
    'blue')
      if [ ${2} -eq 0 ] ; then
        echo -n '\e[0;34m'
      else
        echo -n '\e[1;34m'
      fi
      ;;
    'cyan')
      if [ ${2} -eq 0 ] ; then
        echo -n '\e[0;36m'
      else
        echo -n '\e[1;36m'
      fi
      ;;
    'green')
      if [ ${2} -eq 0 ] ; then
        echo -n '\e[0;38;5;154m'
      else
        echo -n '\e[1;38;5;154m'
      fi
      ;;
    'magenta')
      if [ "$2" -eq "0" ] ; then
        echo -n '\e[0;38;5;161m'
      else
        echo -n '\e[1;38;5;161m'
      fi
      ;;
    'red')
      if [ "$2" -eq "0" ] ; then
        echo -n '\e[0;31m'
      else
        echo -n '\e[1;31m'
      fi
      ;;
    'white')
      if [ "$2" -eq "0" ] ; then
        echo -n '\e[0;37m'
      else
        echo -n '\e[1;37m'
      fi
      ;;
    'yellow')
      if [ "$2" -eq "0" ] ; then
        echo -n '\e[0;33m'
      else
        echo -n '\e[1;33m'
      fi
      ;;
    'underline')
      echo -n '\e[4m'
      ;;
    'reset')
      echo -n '\e[0m'
      ;;
    *)
      echo -n '\e[0m'
      ;;
  esac

  echo -n '%}'

}

function PromptVcs {

  # Determine if the current directory is a vcs repo

  local vcs_is_repo
  local vcs_branch
  local vcs_status

  if ${PathHasBinGIT} ; then
    if vcs_is_repo=$(git status 2>&1) ; then
      vcs_branch="$(
        echo "${vcs_is_repo}" |
        grep -m 1 'On branch' |
        awk '{for(i=3;i<=NF;++i)print $i}'
      )"
      vcs_status="$(
        if [[ -z "$(echo $vcs_is_repo |
          grep -m 1 -w -o 'working directory clean')" ]] ; then
          echo "*"
        fi
      )"
      echo -e "$(PromptColor green 0)git$(PromptColor black 1)∫$(PromptColor white 1)$vcs_branch$vcs_status"
      return 0
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

  # TODO: add darcs support
  #  if darcs ??? > /dev/null 2>&1 ; then
  #    echo "darcs"
  #    return 0
  #  fi

  # TODO: Add fossil support

  return 0

}

function PromptConfigure {

  local NCOLOR

  # Setup Special Colors
  if IsRoot ; then
    NCOLOR="$(PromptColor red 1)"
  else
    NCOLOR="$(PromptColor green 0)"
  fi

  # Create prompt

  # Must use single quotes to delay evaluation
  export PROMPT='$(PromptColor green 0)%n$(PromptColor black 1)@$(PromptColor white 1)%M$(PromptColor black 1)[$(PromptColor magenta 0)%~$(PromptColor black 1)]$(PromptVcs)$(PromptColor cyan 0)〉$(PromptColor reset)'

}
