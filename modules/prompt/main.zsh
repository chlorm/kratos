# This file is part of Kratos.
# Copyright (c) 2014-2015, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

function prompt_color {

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

function prompt_vcs {

  # Determine if the current directory is a vcs repo

  local VcsIsRepo
  local VcsBranch
  local VcsStatus

  if ${PathHasBinGIT} ; then
    if VcsIsRepo=$(git status 2>&1) ; then
      VcsBranch="$(
        echo "${VcsIsRepo}" |
        grep -m 1 'On branch' |
        awk '{for(i=3;i<=NF;++i)print $i}'
      )"
      VcsStatus="$(
        if [[ -z "$(echo ${VcsIsRepo} |
          grep -m 1 -w -o 'working directory clean')" ]] ; then
          echo "*"
        fi
      )"
      echo -e "$(prompt_color green 0)git$(prompt_color black 1)∫$(prompt_color white 1)${VcsBranch}${VcsStatus}"
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

function prompt_configure {

  local Ncolor

  # Setup Special Colors
  if is_root ; then
    Ncolor="$(prompt_color red 1)"
  else
    Ncolor="$(prompt_color green 0)"
  fi

  # Allow evaluating functions within the prompt
  setopt PROMPT_SUBST

  # Must use single quotes to delay evaluation
  export PROMPT='$(prompt_color green 0)%n$(prompt_color black 1)@$(prompt_color white 1)%M$(prompt_color black 1)[$(prompt_color magenta 0)%~$(prompt_color black 1)]$(prompt_vcs)$(prompt_color cyan 0)〉$(prompt_color reset)'

}
