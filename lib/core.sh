# This file is part of Kratos.
# Copyright (c) 2014-2015, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

dir_tmp() { # Get the path to the temporary directory

  local DIR
  local TMPDIR=
  local TMPDIRS=("$ROOT/dev/shm" "$ROOT/run/shm" "$ROOT/tmp" "$ROOT/var/tmp")

  for DIR in "${TMPDIRS[@]}" ; do

    if [ -n "$(mount | grep '\(tmpfs\|ramfs\)' | grep $DIR 2> /dev/null)" ] ; then
      TMPDIR="$DIR/$USER"
      break
    fi

  done

  if [ -z "$TMPDIR" ] ; then
    echo "ERROR: Failed to find a tmp directory"
    return 1
  fi

  if [ ! -d "$TMPDIR" ] ; then
    mkdir "$TMPDIR" || return 1
    chmod 0700 "$TMPDIR" || return 1
  fi

  ln -sf "$TMPDIR" "$HOME/.tmp" || return 1

  if [ ! -d "$TMPDIR/cache" ] ; then
    mkdir "$TMPDIR/cache" || return 1
    ln -sf "$TMPDIR/cache" "$HOME/.cache" || return 1
  fi

  # Create dotfiles session directory
  if [ ! -d "$TMPDIR/dotfiles" ] ; then
    mkdir -p "$TMPDIR/dotfiles" || return 1
  fi

  return 0

}

password_confirmation() {

  local PASS1
  local PASS2

  while true ; do
    read -s -p "Password: " PASS1
    echo
    read -s -p "Confirm: " PASS2
    echo
    if [ "$PASS1" = "$PASS2" ] ; then
      break
    fi
    echo "WARNING: passwords do not match, try again"
  done

  echo "$PASS1" > /dev/null 2>&1 && return 0

  return 1

}

y_or_n() { # Ask a yes or no question

  local ANSWER
  local DEFAULT=2
  local PROMPT

  case "$2" in
    '')
      DEFAULT=2
      PROMPT="(y/n)"
      ;;
    'y')
      DEFAULT=0
      PROMPT="(Y/n)"
      ;;
    'n')
      DEFAULT=1
      PROMPT="(y/N)"
      ;;
    *)
      DEFAULT=2
      PROMPT="(y/n)"
      ;;
  esac

  while true ; do
    read -p "$1 $PROMPT: " ANSWER

    ANSWER="$(tolower $ANSWER)"

    case "$ANSWER" in
      '')
        if [ ! $DEFAULT -eq 2 ] ; then
          return $DEFAULT
        fi
        ;;
      'y'|'yes')
        break && return 0
        ;;
      'n'|'no')
        break && return 1
        ;;
    esac

    echo "WARNING: Response must be y/n or yes/no, try again"
  done

  return 2

}

dotfile_gen() { # Parses the dotfile for variables before generating file

  cat > "$HOME/.$2" < "$DOTFILES_DIR/$1"

}

dotfile_ln() { # Links the configuration file to its proper dotfile

  if [ "$#" -eq 0 ] ; then
    return 1
  fi

  local dotfile

  for dotfile in "$@" ; do
    symlink "$DOTFILES_DIR/$dotfile" "$HOME/.$dotfile"
  done

}

cpu_architecture() { # Return CPU architecture without endianness or register size

  # Do NOT use `uname -m'. This returns the kernels arch, and on system like
  # Darwin it returns a hard-coded arch string that is invalid.  Only use
  # utilities that return the cpu's actual arch.  Kernel arch is handled
  # by `kernel_architecture'.

  # TODO: use sysctl on Darwin

  local architecture=

  case "$(os_kernel)" in
    'linux')
      architecture="$(lscpu | grep -m 1 -w -o "\(arm\|i686\|x86_64\)")"
      ;;
  esac

  if [ -z "$architecture" ] ; then
    echo "ERROR: failed to detect cpu architecture"
    return 1
  fi

  echo "$architecture" && return 0

  return 1

}

cpu_register_size() { # Find CPU register size (ie. 32bit/64bit)

  local register_size
	
  register_size=$(getconf LONG_BIT | grep -m 1 -w -o "\(8\|16\|32\|64\|\128\)" | grep -op '[0-9]+')

  [ -z "$register_size" ] || {
    echo "ERROR: could not determine cpu register size"
    return 1
  }

  echo "$register_size"

  return 0

}

cpu_sockets() {

  local SOCKETS=

  case "$(os_kernel)" in
    'linux')
      SOCKETS="$(lscpu | grep -m 1 'Socket(s):' | grep -oP "[0-9]+")"
      ;;
  esac

  [ $SOCKETS -ge 1 ] || {
    # Assume a socket exists even if it fails to find any
    SOCKETS=1
  }

  echo "$SOCKETS" && return 0

  return 1

}

cpus_physical() { # Find number of physical cpu cores

  # Assumes all sockets are identical, only some arm platforms won't
  # work with this logic

  local cpucores

  case $(os_kernel) in
    'linux')
      cpucores=$(lscpu | grep -m 1 'Core(s) per socket:' | grep -oP '[0-9]+')
      ;;
    'darwin')
      cpucores=$(sysctl hw | grep -m 1 "hw.physicalcpu:" | grep -oP '[0-9]+')
      ;;
    'cygwin')
      cpucores=$(NUMBER_OF_PROCESSORS | grep -oP '[0-9]+')
      ;;
  esac

  if [ -z "$cpucores" ] ; then
    cpucores="1"
  else
    cpucores=$(($cpucores * $(cpu_sockets)))
  fi

  echo "$cpucores"

  return 0

}

cpus_logical() { # Find number of logical cpu cores

  # Assumes all sockets are identical, only some arm platforms won't
  # work with this logic

  local cputhreads

  case $(os_kernel) in
    'linux'|'freebsd')
      # Finds number of logical threads per physical core
      cputhreads=$(lscpu | grep -m 1 'Thread(s) per core:' | grep -oP '[0-9]+')
      if [ -n "$cputhreads" ] ; then
        # Convert to number of threads per cpu
        cputhreads=$(($cputhreads * $(cpus_physical)))
      fi
      ;;
    'darwin')
      cputhreads=$(sysctl hw | grep -m 1 "hw.logicalcpu:" | grep -oP '[0-9]+')
      ;;
    'cygwin')
      cputhreads=""
      ;;
  esac

  if [ -z "$cputhreads" ] ; then
    cputhreads="$(cpus_physical)"
  else
    cpus_logical=$(($cputhreads * $(cpu_sockets)))
  fi

  echo "$cputhreads"

  return 0

}

download() { # Find download utility on system

  if path_hasbin "curl" ; then
      curl -O "$@" && return 0
  elif path_hasbin "wget" ; then
      wget "$@" && return 0
  elif path_hasbin "fetch" ; then
      fetch "$@" && return 0
  else
    echo "ERROR: no download utility found"
    return 1
  fi

  echo "ERROR: unable to download file"
  return 1

}

exist() { # Check for existence of file or directory

  [ -n "$1" ] || return 1

  case "$1" in
    '-fc') # Make sure the file exists
      shift
      while [ "$1" ] ; do
        # Make sure file is not a symlink
        if test -L "$1" ; then
          unlink "$1" > /dev/null 2>&1
          [ "$?" = 0 ]
        fi
        # Create file
        if [ ! -f "$1" ] ; then
          touch "$1" > /dev/null 2>&1
          [ "$?" = 0 ]
        fi
        shift
      done

      return 0
      ;;
    '-fx') # Make sure file doesn't exist
      shift
      while [ "$1" ] ; do
        # Make sure file is not a symlink
        if test -L "$1" ; then
          unlink "$1" > /dev/null 2>&1
          [ "$?" -eq 0 ]
        fi
        # Remove file
        if [ -f "$1" ] ; then
          rm -f "$1" > /dev/null 2>&1
          [ "$?" -eq 0 ]
        fi
        shift
      done

      return 0
      ;;
    '-dc') # Make sure directory exists
      shift
      while [ "$1" ] ; do
        # Make sure directory is not a symlink
        if test -L "$1" ; then
          unlink "$1" > /dev/null 2>&1
          [ "$?" -eq 0 ]
        fi
        # Create directory
        if [ ! -d "$1" ] ; then
          mkdir -p "$1" > /dev/null 2>&1
          [ "$?" -eq 0 ]
        fi
        shift
      done

      return 0
      ;;
    '-dx') # Make sure directory doesn't exists
      shift
      while [ "$1" ] ; do
        # Make sure directory is not a symlink
        if test -L "$1" ; then
          unlink "$1" > /dev/null 2>&1
          [ "$?" -eq 0 ]
        fi
        # Remove directory
        if [ -d "$1" ] ; then
          rm -rf "$1" > /dev/null 2>&1
          [ "$?" -eq 0 ]
        fi
        shift
      done

      return 0
      ;;
  esac

  return 1

}

tolower() {

  echo "$@" | tr '[A-Z]' '[a-z]'

}

toupper() {

  echo "$@" | tr '[a-z]' '[A-Z]'

}

os_kernel() { # Find host os kernel

  local KERNEL

  KERNEL=$(tolower $(uname -s) |
    grep -m 1 -w -o '\(cygwin\|darwin\|dragonfly\|freebsd\|linux\|netbsd\|openbsd\)')

  if [ -z "$KERNEL" ] ; then
    echo "ERROR: not a supported operating system"
    return 1
  fi

  echo "$KERNEL"

  return 0

}

os_linux() { # Take first result of linux os name match

  os_linux_release() { # Finds linux distro via /etc/*-release

    cat $ROOT/etc/*-release 2> /dev/null

  }

  os_linux_uname() { # Finds linux distro via uname -a

    uname -a 2> /dev/null

  }

  os_linux_lsb() { # Find linux distro via linux standard base

    lsb_release -a 2> /dev/null

  }

  [ "$(os_kernel)" = "linux" ] || return 1

  local LINUX

  LINUX=$(tolower "$(os_linux_release) $(os_linux_uname) $(os_linux_lsb)" |
    grep -m 1 -w -o '\(arch\|centos\|debian\|fedora\|gentoo\|nixos\|opensuse\|red\ hat\|suse\|ubuntu\)')

  if [ -z "$LINUX" ] ; then
    echo "ERROR: not a supported linux operating system"
    return 1
  fi

  echo "$LINUX"

  return 0

}

p_and_q() {

  local STAT

  STAT="$1"
  shift 1
  echo "$@"
  exit $STAT

}

path_add() { # Add direcory to $PATH

  if [ -z "$(echo "$PATH" | grep "$1" 2> /dev/null)" ] ; then
    export PATH="${PATH}:$1"
  fi

}

path_remove()  { # Remove directory from $PATH

  if [ -n "$(echo "$PATH" | grep "$1" 2> /dev/null)" ] ; then
    export PATH=`echo -n $PATH | awk -v RS=: -v ORS=: '$0 != "'$1'"' | sed 's/:$//'`
  fi

}

path_bin() { # Finds the path to the binary

  if [ "$#" -ne 1 ] ; then
    return 2
  fi

  path_hasbin "$1" > /dev/null 2>&1 && type "$1" | awk '{print $3 ; exit}' && return 0

  return 1

}

proc_exists() { # Checks to see if the process is running

  if [ "$#" -ne 1 ] ; then
    return 1
  fi

  kill -0 "$1" > /dev/null 2>&1

}

check_pidfile() { # Checks the pidfile to see if the process is running

  if [ -f "$1" ] ; then
  	proc_exists "$(cat $1 2> /dev/null)"
  fi

}

run_quiet() { # Start an application in the background

  path_hasbin "$1" || return 1

  local pid

  pid="$(pgrep $1)"

  if [ -z "$PID" ] ; then
  	$@ > /dev/null 2>&1
  fi

}

sudo_wrap() { # Wraps the command in sudo if sudo exists and runs it

  if path_hasbin "sudo" ; then
    sudo $@
  else
    $@
  fi

}

symlink() { # Create a symbolic link $1 -> $2

  mkdir -p "$(dirname "$2")"
  if [ "$(readlink -f "$2")" != "$1" ] ; then
    rm -rf "$2"
    if [ -f "$1" ] || [ -d "$1" ] ; then
      ln -sf "$1" "$2" 2> /dev/null || return 1
    else
      return 1
    fi
  fi

  return 0

}

termclr() {

  case "$1" in
    'black')
      if [ "$2" -eq 0 ] ; then
        echo -n '\e[0;30m'
      else
        echo -n '\e[1;30m'
      fi
      ;;
    'blue')
      if [ "$2" -eq 0 ] ; then
        echo -n '\e[0;34m'
      else
        echo -n '\e[1;34m'
      fi
      ;;
    'cyan')
      if [ "$2" -eq 0 ] ; then
        echo -n '\e[0;36m'
      else
        echo -n '\e[1;36m'
      fi
      ;;
    'green')
      if [ "$2" -eq 0 ] ; then
        echo -n '\e[0;32m'
      else
        echo -n '\e[1;32m'
      fi
      ;;
    'magenta')
      if [ "$2" -eq 0 ] ; then
        echo -n '\e[0;35m'
      else
        echo -n '\e[1;35m'
      fi
      ;;
    'red')
      if [ "$2" -eq 0 ] ; then
        echo -n '\e[0;31m'
      else
        echo -n '\e[1;31m'
      fi
      ;;
    'white')
      if [ "$2" -eq 0 ] ; then
        echo -n '\e[0;37m'
      else
        echo -n '\e[1;37m'
      fi
      ;;
    'yellow')
      if [ "$2" -eq 0 ] ; then
        echo -n '\e[0;33m'
      else
        echo -n '\e[1;33m'
      fi
      ;;
    'underline')
      echo -n '\033[0;4m'
      ;;
    'reset')
      echo -n '\e[0m'
      ;;
    *)
      echo -n '\e[0m'
      ;;
  esac

}

user_root() { # Determine if the user is root

  [ "$(id -u)" -eq 0 ] || return 1

  return 0

}

shell() { # Returns the shell executing the current script

  local LSHELL
  local LPROC

  LPROC="$(ps hp $$ | grep "$$")"

  # Workaround for su spawned shells
  if [ -n "$(echo "$LPROC" | grep '\-su')" ] ; then
    LSHELL="$(basename "$(echo "$LPROC" | sed 's/^.*(\([^)]*\)).*$/\1/')")"
  else
    LSHELL="$(basename "$(echo "$LPROC" | sed 's/-//' | awk '{print $5}')")"
  fi

  # Resolve symlinked shells
  basename "$(readlink -f "$(path_abs "$LSHELL")")"

}

shell_nov() { # Returns the shell executing the current script without appended major version

  shell | sed 's/^\([a-z]*\).*/\1/'

}

path_abs() { # Resolves the name of the binary

  local BIN

  BIN="$(whereis -b $1 2> /dev/null | awk '{print $2}')"

  [ -n "$BIN" ] || return 1

  echo "$BIN"

  return 0

}

svar() { # Stores the output of the command into a variable without a subshell

  local VAR
  local TMP
  local RET

  VAR="$1" ; shift
  TMP="$(mktemp 2> /dev/null)" || TMP="$(mktemp -t tmp 2> /dev/null)" || return 128
  "$@" > "$TMP"
  RET="$?"
  read "$VAR" < "$TMP"
  rm "$TMP"

  return "$RET"

}

dotfiles_dir() {

  echo "$DOTFILES_DIR" && return 0

  return 1

}

kratos_dir() {

  echo "$KRATOS_DIR" && return 0

  return 1

}

deskenvs_executable() {

  case "$1" in
    'awesome')
      echo "awesome" && return 0
      ;;
    'cinnamon')
      echo "cinnamon-session" && return 0
      ;;
    'gnome3')
      echo "gnome-session" && return 0
      ;;
    'i3')
      echo "i3" && return 0
      ;;
    'kde')
      echo "startkde" && return 0
      ;;
    'xfce')
      echo "startxfce4" && return 0
      ;;
    'xmonad')
      echo "xmonad" && return 0
      ;;
  esac

  return 1

}

load_one() { # Source Modules

  if [ -n "$(echo "$1" | grep '\(~$\|^#\)')" ] ; then
    return 0
  fi

  . "$1" || {
    echo "Failed to load module $1"
    return 1
  }

  return 0

}

load_all() {

  [ "$#" -ge 1 ] || return 1

  local DIRCONF
  local MODS
  local MOD

  svar DIRCONF kratos_dir || return 1

  MODS=($(find "$KRATOS_DIR/$1" -type f))

  for MOD in "${MODS[@]}" ; do
    load_one "$MOD"
  done

  return 0

}

# Loads the shell specific fixes
. "$KRATOS_DIR/lib/shell_fixes/$(shell_nov).sh" 2> /dev/null || {
  echo "Failed to load the fixes for the current shell" >&2
  exit 1
}
