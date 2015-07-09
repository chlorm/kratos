# This file is part of Kratos.
# Copyright (c) 2014-2015, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

prompt_color() { # Get colors for the current shell

  if [ "$(shell_nov)" = "zsh" ] ; then
    echo -n '%{'
  else
    echo -n '\['
  fi

  case "$1" in
    'black')
      if [ "$2" -eq "0" ] ; then
        echo -n '\e[0;30m'
      else
        echo -n '\e[1;30m'
      fi
      ;;
    'blue')
      if [ "$2" -eq "0" ] ; then
        echo -n '\e[0;34m'
      else
        echo -n '\e[1;34m'
      fi
      ;;
    'cyan')
      if [ "$2" -eq "0" ] ; then
        echo -n '\e[0;36m'
      else
        echo -n '\e[1;36m'
      fi
      ;;
    'green')
      if [ "$2" -eq "0" ] ; then
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

  if [ "$(shell_nov)" = "zsh" ] ; then
    echo -n '%}'
  else
    echo -n '\]'
  fi

}

prompt_vcs() { # Determine if the current directory is a vcs repo

  if path_hasbin git > /dev/null 2>&1 ; then
    if git status > /dev/null 2>&1 ; then
      echo "git"
      return 0
    fi
  fi

  #if path_hasbin hg > /dev/null 2>&1 ; then
  #  if hg status > /dev/null 2>&1 ; then
  #    echo "hg"
  #    return 0
  #  fi
  #fi

  #if path_hasbin bzr > /dev/null 2>&1 ; then
  #  if bzr root > /dev/null 2>&1 ; then
  #    echo "bzr"
  #    return 0
  #  fi
  #fi

  #if path_hasbin svn > /dev/null 2>&1 ; then
  #  if svn info > /dev/null 2>&1 ; then
  #    echo "svn"
  #    return 0
  #  fi
  #fi

  # I don't use CVS, disabled for performance
  #if path_hasbin cvs > /dev/null 2>&1 ; then
  #  if cvs status > /dev/null 2>&1 ; then
  #    echo "cvs"
  #    return 0
  #  fi
  #fi

  # TODO: add darcs support
  #if path_hasbin darcs > /dev/null 2>&1 ; then
  #  if darcs ??? > /dev/null 2>&1 ; then
  #    echo "darcs"
  #    return 0
  #  fi
  #fi

  return 0

}

prompt_vcs_branch() { # Return current vcs branch

local branch

  case "$(prompt_vcs)" in
    'bzr')
      return 0
      ;;
    'cvs')
      return 0
      ;;
    'darcs')
      return 0
      ;;
    'git')
      branch=$(git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/\1$(prompt_vcs_dirty)/")
      if [ -n "$branch" ] ; then
        echo "$branch"
      fi
      return 0
      ;;
    'hg')
      return 0
      ;;
    'svn')
      return 0
      ;;
  esac

  return 0

}

prompt_vcs_dirty() { # Append '*' if vcs branch is dirty

local vcsstatus=

  case "$(prompt_vcs)" in
    'bzr')
      return 0
      ;;
    'cvs')
      return 0
      ;;
    'darcs')
      return 0
      ;;
    'git')
      vcsstatus="$(git status 2> /dev/null | grep -m 1 -w -o 'working directory clean')"
      if [ "$vcsstatus" != "working directory clean" ] ; then
        echo "*"
      fi
      return 0
      ;;
    'hg')
      return 0
      ;;
    'svn')
      return 0
      ;;
  esac

  return 0

}

prompt_configure() { # Create prompt

  case "$(shell)" in
    'zsh') # Must use single quotes to delay evaluation
      export PROMPT='$(prompt_color green 0)%n$(prompt_color black 1)@$(prompt_color white 1)%M$(prompt_color black 1)[$(prompt_color magenta 0)%~$(prompt_color black 1)]$(prompt_color green 0)$(prompt_vcs)$(prompt_color black 1)$([ -z $(prompt_vcs 2> /dev/null) ] || echo "∫")$(prompt_color white 1)$(prompt_vcs_branch)$(prompt_color cyan 0)〉$(prompt_color reset)'
      ;;
    'bash'|'dash')
      export PS1="$(prompt_color green 0)\u$(prompt_color black 1)@$(prompt_color white 1)\h$(prompt_color black 1)[$(prompt_color magenta 0)\w$(prompt_color black 1)]$(prompt_color green 0)\$(prompt_vcs)$(prompt_color black 1)\$([ -z \$(prompt_vcs 2> /dev/null) ] || echo "∫")$(prompt_color white 1)\$(prompt_vcs_branch)$(prompt_color cyan 0)〉$(prompt_color reset)"
      ;;
  esac

}
