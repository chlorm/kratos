# This file is part of Kratos.
# Copyright (c) 2014-2015, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

function CpuArchitecture { # Return CPU architecture without endianness or register size

  # Do NOT use `uname -m' to achieve this functionality.

  # TODO: use sysctl on Darwin

  local architecture

  case "$(OSKernel)" in
    'linux')
      architecture="$(lscpu | grep -m 1 -w -o "\(arm\|i686\|x86_64\)")"
      ;;
  esac

  if [[ -z "${architecture}" ]] ; then
    ErrError 'failed to detect cpu architecture'
    return 1
  fi

  echo "${architecture}" && return 0

  return 1

}

function CpuRegisterSize { # Find CPU register size (ie. 32bit/64bit)

  local register_size

  register_size=$(getconf LONG_BIT | grep -m 1 -w -o "\(8\|16\|32\|64\|\128\)" | grep -op '[0-9]+')

  [ -z "${register_size}" ] || {
    ErrError 'could not determine cpu register size'
    return 1
  }

  echo "${register_size}"

  return 0

}

function CpuSockets {

  local SOCKETS=

  case "$(OSKernel)" in
    'linux')
      SOCKETS="$(lscpu | grep -m 1 'Socket(s):' | grep -oP "[0-9]+")"
      ;;
  esac

  [ ${SOCKETS} -ge 1 ] || {
    # Assume a socket exists even if it fails to find any
    SOCKETS=1
  }

  echo "${SOCKETS}" && return 0

  return 1

}

function CpuPhysical { # Find number of physical cpu cores

  # Assumes all sockets are identical, only some arm platforms won't
  # work with this logic

  local cpucores

  case "$(OSKernel)" in
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

  if [ -z "${cpucores}" ] ; then
    cpucores=1
  else
    cpucores=$(($cpucores * $(CpuSockets)))
  fi

  echo "$cpucores"

  return 0

}

function CpuLogical { # Find number of logical cpu cores

  # Assumes all sockets are identical, only some arm platforms won't
  # work with this logic

  local cputhreads

  case $(OSKernel) in
    'linux'|'freebsd')
      # Finds number of logical threads per physical core
      cputhreads=$(lscpu | grep -m 1 'Thread(s) per core:' | grep -oP '[0-9]+')
      if [ -n "${cputhreads}" ] ; then
        # Convert to number of threads per cpu
        cputhreads=$((${cputhreads} * $(CpuPhysical)))
      fi
      ;;
    'darwin')
      cputhreads=$(sysctl hw | grep -m 1 "hw.logicalcpu:" | grep -oP '[0-9]+')
      ;;
    'cygwin')
      cputhreads=''
      ;;
  esac

  if [ -z "${cputhreads}" ] ; then
    cputhreads="$(CpuPhysical)"
  else
    cputhreads=$((${cputhreads} * $(CpuSockets)))
  fi

  echo "${cputhreads}"

  return 0

}

function download { # Find download utility on system

  if PathHasBin 'curl' ; then
      curl -sOL $@ && return 0
  elif PathHasBin 'wget' ; then
      wget $@ && return 0
  elif PathHasBin 'fetch' ; then
      fetch $@ && return 0
  else
    ErrError 'no download utility found'
    return 1
  fi

  ErrError 'unable to download file'
  return 1

}

function EnsureDirDestroy {

  while [ "${1}" ] ; do
    # Make sure directory is not a symlink
    if test -L "${1}" ; then
      unlink "${1}" > /dev/null 2>&1 || return 1
    fi
    # Remove directory
    if [ -d "${1}" ] ; then
      rm -rf "${1}" > /dev/null 2>&1 || return 1
    fi
    shift
  done

}

function EnsureDirExists {

  while [ "${1}" ] ; do
    # Make sure directory is not a symlink
    if test -L "${1}" ; then
      unlink "${1}" > /dev/null 2>&1 || return 1
    fi
    # Create directory
    if [ ! -d "${1}" ] ; then
      mkdir -p "${1}" > /dev/null 2>&1 || return 1
    fi
    shift
  done

}

function EnsureFileDestroy {

  while [ "${1}" ] ; do
    # Make sure file is not a symlink
    if test -L "${1}" ; then
      unlink "${1}" > /dev/null 2>&1 || return 1
    fi
    # Remove file
    if [ -f "${1}" ] ; then
      rm -f "${1}" > /dev/null 2>&1 || return 1
    fi
    shift
  done

}

function EnsureFileExists {

  while [ "${1}" ] ; do
    # Make sure file is not a symlink
    if test -L "${1}" ; then
      unlink "${1}" > /dev/null 2>&1 || return 1
    fi
    # Create file
    if [[ ! -f "${1}" ]] ; then
      touch "${1}" > /dev/null 2>&1 || return 1
    fi
    shift
  done

}

function ErrCallStack {

  if [[ "$(shell)" == 'bash' ]] ; then
    echo "${FUNCNAME[2]}"
  elif [[ "$( shell)" == 'zsh' ]] ; then
    echo "${funcstack[3]}"
  else
    echo '???'
  fi

}

function ErrError {

  if [[ -n "${2}" ]] ; then
    echo "Kratos: ERROR in \`${2}': ${1}"
  else
    echo "Kratos: ERROR in \`$(ErrCallStack)': ${1}"
  fi

  return 0

}

function ErrWarn {

  if [[ -n "${2}" ]] ; then
    echo "Kratos: WARNING in \`${2}': ${1}"
  else
    echo "Kratos: WARNING in \`$(ErrCallStack)': ${1}"
  fi

  return 0

}

function IsRoot { # Determine if the user is root

  [ $(id -u) -eq 0 ] || return 1

  return 0

}

#function LoadCompletion
#function LoadInit
function LoadModule { # Source Modules

  if [ -n "$(echo "$1" | grep '\(~$\|^#\)')" ] ; then
    return 0
  fi

  . "${1}" || {
    ErrError "Failed to load module ${1}"
    return 1
  }

  return 0

}
#function LoadTest
#function LoadTheme

function LoadAll {

  local ITEM
  local ITEMS

  case "${1}" in
    'inits')
      ITEMS=($(find "${KRATOS_DIR}/modules" -type f -name 'init.sh'))
      for ITEM in "${ITEMS[@]}" ; do
        LoadInit "${ITEM}"
      done
      return 0
      ;;
    'modules')
      ITEMS=($(find "${KRATOS_DIR}/modules" -type f -name 'main.sh'))
      for ITEM in "${ITEMS[@]}" ; do
        LoadModule "${ITEM}"
      done
      return 0
      ;;
    'tests')
      ITEMS=($(find "${KRATOS_DIR}/modules" -type f -name 'test.sh'))
      for ITEM in "${ITEMS[@]}" ; do
        LoadTest "${ITEM}"
      done
      return 0
      ;;
    #'themes')
    #  ITEMS=($(find "${KRATOS_DIR}/themes" -type f -name *.theme))
    #  for ITEM in "${ITEMS[@]}" ; do
    #    LoadInit "${ITEM}"
    #  done
    #  return 0
    #  ;;
    *)
      ErrError "unknown loader: \`${1}'"
      return 1
      ;;
  esac

  return 1

}

function OSKernel { # Find host os kernel

  local KERNEL=$(ToLower $(uname -s) $(echo ${OSTYPE}) |
    grep -m 1 -w -o '\(cygwin\|darwin\|dragonfly\|freebsd\|linux\|netbsd\|openbsd\)')

  if [ -z "${KERNEL}" ] ; then
    ErrError 'not a supported operating system'
    return 1
  fi

  echo "${KERNEL}"

  return 0

}

function OSLinux { # Take first result of linux os name match

  function OSLinuxRelease { # Finds linux distro via /etc/*-release

    cat $ROOT/etc/*-release 2> /dev/null

  }

  function OSLinuxUname { # Finds linux distro via uname -a

    uname -a 2> /dev/null

  }

  function OSLinuxLsb { # Find linux distro via linux standard base

    lsb_release -a 2> /dev/null

  }

  [ "$(OSKernel)" = 'linux' ] || return 1

  local LINUX

  LINUX="$(ToLower "$(OSLinuxRelease) $(OSLinuxUname) $(OSLinuxLsb)" |
    grep -m 1 -w -o '\(arch\|centos\|debian\|fedora\|gentoo\|nixos\|opensuse\|red\ hat\|suse\|ubuntu\)')"

  if [ -z "${LINUX}" ] ; then
    ErrError 'not a supported linux operating system'
    return 1
  fi

  echo "${LINUX}"

  return 0

}

function PasswordConfirmation {

  local PASS1
  local PASS2

  while true ; do
    read -s -p "Password: " PASS1
    echo
    read -s -p "Confirm: " PASS2
    echo
    if [ "${PASS1}" = "${PASS2}" ] ; then
      break
    fi
    echo "WARNING: passwords do not match, try again"
  done

  echo "${PASS1}" > /dev/null 2>&1 && return 0

  return 1

}

function PathAdd { # Add direcory to $PATH

  if [[ -z "$(echo "${PATH}" | grep "${1}" 2> /dev/null)" && -d "${1}" ]] ; then
    export PATH="${PATH}:${1}"
  fi

  return 0

}

function PathRemove { # Remove directory from $PATH

  if [ -n "$(echo "${PATH}" | grep "$1" 2> /dev/null)" ] ; then
    export PATH=`echo -n $PATH | awk -v RS=: -v ORS=: '$0 != "'$1'"' | sed 's/:$//'`
  fi

  return 0

}

function PathBin { # Finds the path to the binary

  if [ $# -ne 1 ] ; then
    return 2
  fi

  PathHasBin "${1}" > /dev/null 2>&1 || return 1

  case "$(shell)" in
    'bash')
      type "${1}" | awk '{print $3 ; exit}'
      return 0
      ;;
    'ksh'|'pdksh'|'zsh')
      whence -p "${1}" | awk '{print $3 ; exit}'
      return 0
      ;;
  esac

  return 1

}

function PathBinAbs { # Resolves the absolute path of the binary

  local BIN

  BIN="$(whereis -b ${1} 2> /dev/null | awk '{print $2 ; exit}')"

  [ -n "${BIN}" ] || return 1

  echo "${BIN}"

  return 0

}

function PathHasBin { # Test to see if a binary exists in the path

  [ $# -ne 1 ] && return 2

  case "$(shell)" in
    'bash')
      type "${1}" > /dev/null 2>&1 || return 1
      ;;
    'ksh'|'pdksh'|'zsh')
      whence -p "${1}" > /dev/null 2>&1 || return 1
      ;;
    *)
      ErrError 'Not reporting a supported shell' "$(ErrCallStack)"
      return 1
      ;;
  esac

  return 0

}

function PathHasBinErr {

  PathHasBin "${1}" || {
    ErrError "\`${1}' is not installed" "$(ErrCallStack)"
    return 1
  }

  return 0

}

function ProcExists { # Checks to see if the process is running

  if [ $# -ne 1 ] ; then
    return 1
  fi

  kill -0 "$1" > /dev/null 2>&1

}

function ProcPidFile { # Checks the pidfile to see if the process is running

  if [ -f "${1}" ] ; then
  	ProcExists "$(cat ${1} 2> /dev/null)"
  fi

}

function RunQuiet { # Start an application in the background

  PathHasBin "${1}" || return 1

  local PID

  PID="$(pgrep ${1})"

  if [ -z "${PID}" ] ; then
  	$@ > /dev/null 2>&1 || return 1
  fi

  return 0

}

# Returns the shell executing the current script
function shell {

  local LSHELL=
  local LPROC="$(ps hp $$ | grep "$$")"

  # Workaround for su spawned shells
  if [ -n "$(echo "${LPROC}" | grep '\-su')" ] ; then
    LSHELL="$(basename "$(echo "${LPROC}" | sed 's/^.*(\([^)]*\)).*$/\1/')")"
  else
    LSHELL="$(basename "$(echo "${LPROC}" | sed 's/-//' | awk '{print $5 ; exit}')")"
  fi

  # Resolve symlinked shells
  LSHELL="$(basename "$(readlink -f "$(PathBinAbs "${LSHELL}")")")"

  # Remove appended major version
  LSHELL="$(echo "${LSHELL}" | sed 's/^\([a-z]*\).*/\1/')"

  LSHELL="$(ToLower "${LSHELL}")"

  echo "${LSHELL}"

}

function SudoWrap { # Wraps the command in sudo if sudo exists and runs it

  if PathHasBin 'sudo' ; then
    sudo $@
  else
    $@
  fi

  return 0

}

function StoreAsVar { # Stores the output of the command into a variable without a subshell

  local VAR
  local TMP
  local RET

  VAR="${1}" ; shift
  TMP="$(mktemp 2> /dev/null)" || TMP="$(mktemp -t tmp 2> /dev/null)" || return 128
  $@ > "${TMP}"
  RET=$?
  read "${VAR}" < "${TMP}"
  rm "${TMP}"

  return ${RET}

}

function symlink { # Create a symbolic link $1 -> $2

  EnsureDirExists "$(dirname "${2}")"
  if [ "$(readlink -f "${2}")" != "${1}" ] ; then
    rm -rf "${2}"
    if [ -f "${1}" ] || [ -d "${1}" ] ; then
      ln -sf "${1}" "${2}" 2> /dev/null || return 1
    else
      return 1
    fi
  fi

  return 0

}

function ToLower {

  echo $@ | tr '[A-Z]' '[a-z]'

}

function ToUpper {

  echo $@ | tr '[a-z]' '[A-Z]'

}

function YorN { # Ask a yes or no question

  local ANSWER
  local DEFAULT=2
  local PROMPT

  case "${2}" in
    '')
      DEFAULT=2
      PROMPT='(y/n)'
      ;;
    'y')
      DEFAULT=0
      PROMPT='(Y/n)'
      ;;
    'n')
      DEFAULT=1
      PROMPT='(y/N)'
      ;;
    *)
      DEFAULT=2
      PROMPT='(y/n)'
      ;;
  esac

  while true ; do
    read -p "${1} ${PROMPT}: " ANSWER

    ANSWER="$(ToLower ${ANSWER})"

    case "${ANSWER}" in
      '')
        if [ ! ${DEFAULT} -eq 2 ] ; then
          return ${DEFAULT}
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
