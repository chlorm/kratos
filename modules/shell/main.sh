# This file is part of Kratos.
# Copyright (c) 2014-2015, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

# Returns the shell executing the current script
function shell {

  local LSHELL=
  local LPROC="$(ps hp $$ | grep "$$")"

  # Workaround for su spawned shells
  if [ -n "$(echo "$LPROC" | grep '\-su')" ] ; then
    LSHELL="$(basename "$(echo "$LPROC" | sed 's/^.*(\([^)]*\)).*$/\1/')")"
  else
    LSHELL="$(basename "$(echo "$LPROC" | sed 's/-//' | awk '{print $5}')")"
  fi

  # Resolve symlinked shells
  LSHELL="$(basename "$(readlink -f "$(PathBinAbs "$LSHELL")")")"

  # Remove appended major version
  LSHELL="$(echo "$LSHELL" | sed 's/^\([a-z]*\).*/\1/')"

  LSHELL="$(tolower "$LSHELL")"

  echo "$LSHELL"

}

# http://en.wikipedia.org/wiki/Comparison_of_command_shells

function ShellTheme { # Setup the theme for the shell

  [ "$(shell)" = "fish" ] && return 0

  # Colors for LS
  case "$(OSKernel)" in
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
#  if [ "$TERM" = "xterm" ] || [ "$TERM" = "rxvt-unicode-256color" ] ; then
#    export TERM="xterm-256color"
#    unset COLORTERM
#  fi

  # Setup Special Colors
  if UserRoot ; then
    NCOLOR="$(PromptColor cyan 0)"
  else
    NCOLOR="$(PromptColor white 1)"
  fi

  DCOLOR="$(PromptColor yellow 1)"

}

ShellInit() { # Initializes useful functions

  alias root="sudo_wrap su -"
  alias sprunge="curl -F 'sprunge=<-' http://sprunge.us"
  alias nixpaste="curl -F 'text=<-' http://nixpaste.noip.me"
  #alias t='laptop_bat ; date'
  alias sha1="openssl sha1"
  alias sha256="openssl sha256"
  alias sha512="openssl sha512"
  alias youtube="youtube-dl --max-quality --no-check-certificate --prefer-insecure --console-title"
  alias music="ncmpcpp"
  alias tarxz="tar cjvf"
  alias emacs="emacs -nw"
  # Btrfs
  alias defragmentroot="sudo btrfs filesystem defragment -r -v /"
  alias defragmenthome="sudo btrfs filesystem defragment -r -v /home"
  # Gentoo
  if [ "$(OSLinux)" = "gentoo" ] ; then
    alias inst="sudo emerge --ask"
    alias search="emerge --search"
    alias uses="equery uses"
    alias layup="sudo layman -S"
  fi

  # Environment Variables

  if [ "$PREFERED_EDITOR" = "emacs" ] ; then
    export EDITOR="emacs -nw"
  else
    export EDITOR="$PREFERED_EDITOR"
  fi
  export PAGER="less -r"
  export BLOCKSIZE="K"
  # Locale/UTF-8
  export LANG=en_US.UTF-8
  export LANGUAGE=en_US.UTF-8
  export LC_ALL=en_US.UTF-8
  export LESSCHARSET=utf-8
  export PERL_UTF8_LOCALE=1
  export PERL_UNICODE=AS
  # Prevent GUI password dialog
  unset SSH_ASKPASS

}
