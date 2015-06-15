# This file is part of https://github.com/codyopel/dotfiles

# This file is licensed under the terms of the BSD-3 license

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
        if [ $DEFAULT != 2 ] ; then
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

  if [ "$#" -eq "0" ] ; then
    return 1
  fi

  local dotfile

  for dotfile in "$@" ; do
    symlink "$DOTFILES_DIR/dotfiles/$dotfile" "$HOME/.$dotfile"
  done

}

cpu_architecture() { # Find CPU architecture without endianness

  # http://en.wikipedia.org/wiki/Uname

  # Switch to using Darwin:sysctl Linux:/proc/cpuinfo, uname is part of the kernel and kernel does not guarentee arch

  # rewite to use /proc/cpuinfo and equvilents, uname -m is not a reliable method

  local architecture

  architecture=$(uname -m | grep -m 1 -w -o "\(\
    arm\|armeb\|armel\|armv5te\|armv6\|armv6l\|armv6t2\|armv7l\|armv8\|\
    i386\|i486\|i686\|i686-AT386\|i86pc\|x86\|x86_32\|i686-64\|x86pc\|x86_64\|amd64\|k1om\|\
    mips\|mips64\|\
    Power Macintosh\|powerpc\|ppc\|ppc64\|\
    sun4u\|sparc\|sparc64\)")

  [ -z "$architecture" ] && { echo "ERROR: failed to detect cpu architecture" ; return 1 ; }

  case "$architecture" in
    'arm'|'armeb'|'armel'|'armv5te'|'armv6'|'armv6l'|'armv6t2'|'armv7l'|'armv8')
      echo "arm"
      ;;
    'mips'|'mips64')
      echo "mips"
      ;;
    'powerpc'|'ppc'|'ppc64')
      echo "ppc"
      ;;
    'sun4u'|'sparc'|'sparc64')
      echo "sparc"
      ;;
    'i386'|'i486'|'i586'|'i686'|'x86'|'x86_32'|'amd64'|'x86_64'|'i686-AT386'|'i86pc'|'i686-64'|'x86pc'|'k1om')
      echo "x86"
      ;;
    *)
      echo "ERROR: invalid cpu architecture '$architecture'"
      return 1
      ;;
  esac

  return 0

}

cpu_endianness() { # Find CPU endianness (ie. 32bit/64bit)

  local endianness

  # Change name to register size & add actuall endianness function
	
  endianness=$(getconf LONG_BIT | grep -m 1 -w -o "\(8\|16\|32\|64\|\128\)" | grep -o '[0-9]*')

  [ -z "$endianness" ] && { echo "ERROR: could not determine cpu endianness" ; return 1 ; }

  echo "$endianness"

  return 0

}

cpu_cores() { # Find number of physical cpu cores

  # Does not work with multiple sockets
  # Add function 'cpu_sockets' & and assume both sockets are identical
  # Only some arm platforms wouldn't work with this logic

  local cpucores

  case $(os_kernel) in
    'linux'|'freebsd')
      cpucores=$(awk '/^cpu\ cores/ { print $4 ; exit }' /proc/cpuinfo | grep -o '[0-9]*')
      ;;
    'darwin')
      cpucores=$(sysctl hw | grep -m 1 "hw.physicalcpu:" | grep -o '[0-9]*')
      ;;
    'cygwin')
      cpucores=$(NUMBER_OF_PROCESSORS | grep -o '[0-9]*')
      ;;
  esac

  [ -z "$cpucores" ] && cpucores="1"

  echo "$cpucores"

  return 0

}

cpu_threads() { # Find number of logical cpu cores

  local cputhreads

  case $(os_kernel) in
    'linux'|'freebsd')
      cputhreads=$(grep -c ^processor /proc/cpuinfo | grep -o '[0-9]*')
      ;;
    'darwin')
      cputhreads=$(sysctl hw | grep -m 1 "hw.logicalcpu:" | grep -o '[0-9]*')
      ;;
    'cygwin')
      cputhreads=""
      ;;
  esac

  [ -z "$cputhreads" ] && cputhreads="$(cpu_cores)"

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
  fi

  echo "ERROR: unable to download file"
  return 1

}

exist() { # Check for existence of file or directory

  [ ! -z "$1" ] || return 1

  case "$1" in
    '-fc') # Make sure the file exists
      shift
      while [ "$1" ] ; do
        # Make sure file is not a symlink
        if test -L "$1" ; then
          unlink "$1" > /dev/null 2>&1
          [ "$?" == "0" ]
        fi
        # Create file
        if [ ! -f "$1" ] ; then
          touch "$1" > /dev/null 2>&1
          [ "$?" == "0" ]
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
          [ "$?" == "0" ]
        fi
        # Remove file
        if [ -f "$1" ] ; then
          rm -f "$1" > /dev/null 2>&1
          [ "$?" == "0" ]
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
          [ "$?" == "0" ]
        fi
        # Create directory
        if [ ! -d "$1" ] ; then
          mkdir -p "$1" > /dev/null 2>&1
          [ "$?" == "0" ]
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
          [ "$?" == "0" ]
        fi
        # Remove directory
        if [ -d "$1" ] ; then
          rm -rf "$1" > /dev/null 2>&1
          [ "$?" == "0" ]
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

  KERNEL=$(tolower $(uname -s) | \
    grep -m 1 -w -o '\(cygwin\|darwin\|dragonfly\|freebsd\|linux\|netbsd\|openbsd\)' | \
    head -n 1)

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

  os_linux_lsb() { # Find linux distro vix linux standard base

    lsb_release -a 2> /dev/null

  }

  [ "$(os_kernel)" = "linux" ] || return 1

  local LINUX

  LINUX=$(tolower "$(os_linux_release) $(os_linux_uname) $(os_linux_lsb)" | \
    grep -m 1 -w -o '\(arch\|centos\|debian\|fedora\|gentoo\|nixos\|opensuse\|red\ hat\|suse\|ubuntu\)' | \
    head -n 1)

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

  [ "$(echo "$PATH" | grep "$1" 2> /dev/null)" = '' ] && {
    export PATH="${PATH}:$1"
  }

}

path_remove()  { # Remove directory from $PATH

  [ "$(echo "$PATH" | grep "$1" 2> /dev/null)" = '' ] || {
    export PATH=`echo -n $PATH | awk -v RS=: -v ORS=: '$0 != "'$1'"' | sed 's/:$//'`
  }

}

path_bin() { # Finds the path to the binary

  [ "$#" -ne "1" ] && return 2

  path_hasbin "$1" > /dev/null 2>&1 && type "$1" | awk '{print $3}' && return 0

  return 1

}

proc_exists() { # Checks to see if the process is running

  [ ! "$#" -ne "1" ] || return 1

  kill -0 $1 > /dev/null 2>&1

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
  	"$@" > /dev/null 2>&1
  fi

}

sudo_wrap() { # Wraps the command in sudo if sudo exists and runs it

  if path_hasbin "sudo" ; then
    sudo $@
  else
    $@
  fi

}

symlink() { # Make sure the symbolic link points to the correct location $2 -> $1

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
      [ "$2" -eq "0" ] && echo -n '\e[0;30m' || echo -n '\e[1;30m'
      ;;
    'blue')
      [ "$2" -eq "0" ] && echo -n '\e[0;34m' || echo -n '\e[1;34m'
      ;;
    'cyan')
      [ "$2" -eq "0" ] && echo -n '\e[0;36m' || echo -n '\e[1;36m'
      ;;
    'green')
      [ "$2" -eq "0" ] && echo -n '\e[0;32m' || echo -n '\e[1;32m'
      ;;
    'magenta')
      [ "$2" -eq "0" ] && echo -n '\e[0;35m' || echo -n '\e[1;35m'
      ;;
    'red')
      [ "$2" -eq "0" ] && echo -n '\e[0;31m' || echo -n '\e[1;31m'
      ;;
    'white')
      [ "$2" -eq "0" ] && echo -n '\e[0;37m' || echo -n '\e[1;37m'
      ;;
    'yellow')
      [ "$2" -eq "0" ] && echo -n '\e[0;33m' || echo -n '\e[1;33m'
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

  [ "$(id -u)" -eq 0 ]

}

array_empty() { # Extra array functions for accessor simplicity

  [ "$(array_size $1)" -eq "0" ]

}

array_forall() {

  [ "$(array_size $1)" -gt "0" ] || return 0

  for I in $(seq 0 $(expr $(array_size $1) - 1)) ; do
    eval "$2 \"$(array_at $1 $I)\"" || return 1
  done

}

array_for() {

  [ "$(array_size $1)" -gt "0" ] || return 0

  for I in $(seq 0 $(expr $(array_size $1) - 1)) ; do
    array_at "$1" "$I" || return 1
  done

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

  [ -z "$BIN" ] && return 1
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

  [ "$(echo "$1" | grep '\(~$\|^#\)')" != "" ] && return 0
  . "$1" || { echo "Failed to load module $1" ; return 1 ; }

}

load_all() {

  [ "$#" -ge "1" ] || return 1

  local DIRCONF
  local MODS

  svar DIRCONF dotfiles_dir || return 1

  array_from_str MODS "$(find "$DOTFILES_DIR/$1" -type f)"
  array_forall MODS load_one

}

# Loads the shell specific fixes
. "$DOTFILES_DIR/lib/shell_fixes/$(shell_nov).sh" 2> /dev/null || {
  echo "Failed to load the fixes for the current shell" >&2
  exit 1
}
