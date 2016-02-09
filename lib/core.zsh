# This file is part of Kratos.
# Copyright (c) 2014-2015, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

function cpu_architecture {

  # Return CPU architecture without endianness or address space size

  # Do NOT use `uname -m' to achieve this functionality.

  local Architecture

  case "$(os_kernel)" in
    'cygwin')
      case "${PROCESSOR_ARCHITECTURE}" in
        'AMD64')
          Architecture='x86_64'
          ;;
        'x86')
          Architecture='i686'
          ;;
      esac
      ;;
    'darwin')
      # TODO: use sysctl on Darwin
      Architecture='x86_64'
      ;;
    'linux')
      Architecture="$(
        lscpu |
        grep --max-count 1 --word-regexp --only-matching "\(arm\|i686\|x86_64\)"
      )"
      ;;
  esac

  if [[ -z "${Architecture}" ]] ; then
    err_error 'failed to detect cpu architecture'
    return 1
  fi

  echo "${Architecture}"

  return 0

}

function cpu_address_space {

  # Find CPU adress space size (ie. 32bit/64bit)

  local AddressSpace

  AddressSpace=$(
    getconf LONG_BIT |
    grep --max-count 1 --word-regexp --only-matching "\(8\|16\|32\|64\|\128\)" |
    grep --only-matching -p '[0-9]+'
  ) || return 1

  [[ -z "${AddressSpace}" ]] || {
    err_error 'could not determine cpu address space size'
    return 1
  }

  echo "${AddressSpace}"

  return 0

}

function cpu_sockets {

  local Sockets

  case "$(os_kernel)" in
    'darwin')
      Sockets=1
      ;;
    'linux')
      Sockets="$(
        lscpu |
        grep --max-count 1 'Socket(s):' |
        grep --only-matching --perl-regexp "[0-9]+"
      )" || return 1
      ;;
  esac

  if [[ ! ${Sockets} -ge 1 ]] ; then
    # Assume a socket exists even if it fails to find any
    Sockets=1
  fi

  echo "${Sockets}"

  return 0

}

function cpu_physical {

  # Find number of physical cpu cores

  # Assumes all sockets are identical, only some arm platforms won't
  # work with this logic.

  local CpuCores

  case "$(os_kernel)" in
    'linux')
      CpuCores=$(
        lscpu |
        grep --max-count 1 'Core(s) per socket:' |
        grep --only-matching --perl-regexp '[0-9]+'
      ) || return 1
      ;;
    'darwin')
      CpuCores=$(
        sysctl hw |
        grep --max-count 1 "hw.physicalcpu:" |
        grep --only-matching --perl-regexp '[0-9]+'
      ) || return 1
      ;;
    'cygwin')
      CpuCores=$(
        NUMBER_OF_PROCESSORS |
        grep --only-matching --perl-regexp '[0-9]+'
      ) || return 1
      ;;
  esac

  if [[ -z "${CpuCores}" ]] ; then
    CpuCores=1
  else
    CpuCores=$(( ${CpuCores} * $(cpu_sockets) ))
  fi

  echo "${CpuCores}"

  return 0

}

function cpu_logical {

  # Find number of logical cpu cores

  # Assumes all sockets are identical, only some arm platforms won't
  # work with this logic

  local CpuThreads

  case $(os_kernel) in
    'linux'|'freebsd')
      # Finds number of logical threads per physical core
      CpuThreads=$(
        lscpu |
        grep --max-count 1 'Thread(s) per core:' |
        grep --only-matching --perl-regexp '[0-9]+'
      ) || return 1
      if [[ -n "${CpuThreads}" ]] ; then
        # Convert to number of threads per cpu
        CpuThreads=$(( ${CpuThreads} * $(cpu_physical) ))
      fi
      ;;
    'darwin')
      CpuThreads=$(
        sysctl hw |
        grep --max-count 1 "hw.logicalcpu:" |
        grep --only-matching --perl-regexp '[0-9]+'
      ) || return 1
      ;;
  esac

  if [[ -z "${CpuThreads}" ]] ; then
    CpuThreads=$(cpu_physical)
  else
    CpuThreads=$(( ${CpuThreads} * $(cpu_sockets) ))
  fi

  echo "${CpuThreads}"

  return 0

}

function download {

  # Find download utility on system

  if path_has_bin 'curl' ; then
      curl -sOL $@ && return 0
  elif path_has_bin 'wget' ; then
      wget $@ && return 0
  elif path_has_bin 'fetch' ; then
      fetch $@ && return 0
  else
    err_error 'no download utility found'
    return 1
  fi

  err_error 'unable to download file'
  return 1

}

function ensure_dir_destroy {

  while [ "${1}" ] ; do
    # Make sure directory is not a symlink
    if [[ -L "${1}" ]] ; then
      unlink "${1}" > /dev/null 2>&1 || return 1
    fi
    # Remove directory
    if [[ -d "${1}" ]] ; then
      rm -rf "${1}" > /dev/null 2>&1 || return 1
    fi
    shift
  done

}

function ensure_dir_exists {

  while [ "${1}" ] ; do
    # Make sure directory is not a symlink
    if [[ -L "${1}" ]] ; then
      unlink "${1}" > /dev/null 2>&1 || return 1
    fi
    # Create directory
    if [[ ! -d "${1}" ]] ; then
      mkdir -p "${1}" > /dev/null 2>&1 || return 1
    fi
    shift
  done

}

function ensure_file_destroy {

  while [ "${1}" ] ; do
    # Make sure file is not a symlink
    if [[ -L "${1}" ]] ; then
      unlink "${1}" > /dev/null 2>&1 || return 1
    fi
    # Remove file
    if [[ -f "${1}" ]] ; then
      rm -f "${1}" > /dev/null 2>&1 || return 1
    fi
    shift
  done

}

function ensure_file_exists {

  while [ "${1}" ] ; do
    # Make sure file is not a symlink
    if [[ -L "${1}" ]] ; then
      unlink "${1}" > /dev/null 2>&1 || return 1
    fi
    # Create file
    if [[ ! -f "${1}" ]] ; then
      touch "${1}" > /dev/null 2>&1 || return 1
    fi
    shift
  done

}

function err_call_stack {

  echo "${funcstack[3]}"

  return 0

}

function err_error {

  if [[ -n "${2}" ]] ; then
    echo "Kratos: ERROR in \`${2}': ${1}" > /dev/stderr
  else
    echo "Kratos: ERROR in \`$(err_call_stack)': ${1}" > /dev/stderr
  fi

  return 0

}

function err_warn {

  if [[ -n "${2}" ]] ; then
    echo "Kratos: WARNING in \`${2}': ${1}" > /dev/stderr
  else
    echo "Kratos: WARNING in \`$(err_call_stack)': ${1}" > /dev/stderr
  fi

  return 0

}

function is_root {

  # Determine if the user is root

  [[ $(id -u) -eq 0 ]] || return 1

  return 0

}

function load_one {

  # Source specified init file

  if [[ -n "$(echo "${1}" | grep '\(~$\|^#\)')" ]] ; then
    return 0
  fi

  source "${1}" || {
    err_error "Failed to load: ${1}"
    return 1
  }

  return 0

}

function load_all {

  # Load all of specified init type

  local Init
  local Inits
  local Plugin
  local PluginLoaderExists

  Inits=(
    # Modules
    $(find "${KRATOS_DIR}/modules" -type f -name "${1}.zsh")
    # Active plugins
    $(for Plugin in "${KRATOS_PLUGINS[@]}" ; do
      PluginLoaderExists="$(
        find ${KRATOS_DIR}/plugins \
          -type f -name "${1}.zsh" -iwholename "*${Plugin}*"
      )"
      if [[ -f "${PluginLoaderExists}" ]] ; then
        echo "${PluginLoaderExists}"
      fi
    done)
  )

  for Init in "${Inits[@]}" ; do
    load_one "${Init}"
  done

  return 0

}

function os_kernel {

  # Find host os kernel

  function os_kernel_ostype {

    echo "${OSTYPE}" > /dev/null 2>&1

  }

  function os_kernel_uname {

    uname -s 2> /dev/null

  }

  local Kernel

  Kernel=$(
    to_lower "$(os_kernel_ostype) $(os_kernel_uname)" |
    grep --max-count 1 --word-regexp --only-matching \
      '\(cygwin\|darwin\|freebsd\|linux\)'
  )

  if [[ -z "${Kernel}" ]] ; then
    err_error 'not a supported operating system'
    return 1
  fi

  echo "${Kernel}"

  return 0

}

function os_linux {

  # Take first result of linux os name match

  function os_linux_release {

    # Finds linux distro via /etc/*-release

    cat ${ROOT}/etc/*-release 2> /dev/null

  }

  function os_linux_uname {

    # Finds linux distro via uname -a

    uname -a 2> /dev/null

  }

  function os_linux_lsb {

    # Find linux distro via linux standard base

    lsb_release -a 2> /dev/null

  }

  [[ "$(os_kernel)" == 'linux' ]] || return 1

  local Linux

  Linux="$(
    to_lower "$(os_linux_release) $(os_linux_uname) $(os_linux_lsb)" |
    grep --max-count 1 --word-regexp --only-matching \
      '\(arch\|centos\|debian\|fedora\|gentoo\|opensuse\|red\ hat\|suse\|triton\|ubuntu\)'
  )"

  if [[ -z "${Linux}" ]] ; then
    err_error "not a supported linux operating system: ${Linux}"
    return 1
  fi

  echo "${Linux}"

  return 0

}

function password_confirmation {

  local Pass1
  local Pass2

  while true ; do
    read -s -p "Password: " Pass1
    echo
    read -s -p "Confirm: " Pass2
    echo
    if [[ "${Pass1}" == "${Pass2}" ]] ; then
      break
    fi
    echo "WARNING: passwords do not match, try again"
  done

  echo "${Pass1}" > /dev/null 2>&1 && return 0

  return 1

}

function path_add {

  # Add direcory to $PATH

  if [[ -z "$(echo "${PATH}" | grep "${1}" 2> /dev/null)" && -d "${1}" ]] ; then
    export PATH="${PATH}:${1}"
  fi

  return 0

}

function path_remove {

  # Remove directory from $PATH

  if [[ -n "$(echo "${PATH}" | grep "${1}" 2> /dev/null)" ]] ; then
    export PATH=`echo -n $PATH | awk -v RS=: -v ORS=: '$0 != "'$1'"' | sed 's/:$//'`
  fi

  return 0

}

function path_bin {

  # Finds the path to the binary

  if [[ $# -ne 1 ]] ; then
    return 2
  fi

  path_has_bin "${1}" > /dev/null 2>&1 || return 1

  whence -p "${1}" |
  awk '{ print $3 ; exit }' || return 1

  return 0

}

function path_bin_abs {

  # Resolves the absolute path of the binary

  local Bin

  Bin="$(whereis -b ${1} 2> /dev/null | awk '{ print $2 ; exit }')"

  [[ -n "${Bin}" ]] || return 1

  echo "${Bin}"

  return 0

}

function path_has_bin {

  # Test to see if a binary exists in the path

  [[ $# -ne 1 ]] && return 2

  whence -p "${1}" > /dev/null 2>&1 || return 1

  return 0

}

function path_has_bin_err {

  path_has_bin "${1}" || {
    err_error "\`${1}' is not installed" "$(err_call_stack)"
    return 1
  }

  return 0

}

function proc_exists {

  # Checks to see if the process is running

  if [[ $# -ne 1 ]] ; then
    return 1
  fi

  kill -0 "${1}" > /dev/null 2>&1

}

function proc_pid_file {

  # Checks the pidfile to see if the process is running

  if [[ -f "${1}" ]] ; then
  	proc_exists "$(cat ${1} 2> /dev/null)"
  fi

}

function run_quiet {

  # Start an application in the background

  path_has_bin "${1}" || return 1

  local Pid

  Pid="$(pgrep ${1})"

  if [[ -z "${Pid}" ]] ; then
  	$@ > /dev/null 2>&1 || return 1
  fi

  return 0

}

function shell {

  # Returns the shell executing the current script

  local Lshell
  local Lproc

  Lproc="$(ps hp $$ | grep "$$")"

  # Workaround for su spawned shells
  if [[ -n "$(echo "${Lproc}" | grep '\-su')" ]] ; then
    Lshell="$(
      basename "$(
        echo "${Lproc}" |
        sed 's/^.*(\([^)]*\)).*$/\1/'
      )"
    )"
  else
    Lshell="$(
      basename "$(
        echo "${Lproc}" |
        sed 's/-//' |
        awk '{ print $5 ; exit }'
      )"
    )"
  fi

  # Resolve symlinked shells
  Lshell="$(
    basename "$(
      readlink -f "$(
        path_bin_abs "${Lshell}"
      )"
    )"
  )"

  # Remove appended major version
  Lshell="$(
    echo "${Lshell}" |
    sed 's/^\([a-z]*\).*/\1/'
  )"

  Lshell="$(
    to_lower "${Lshell}"
  )"

  echo "${Lshell}"

}

function sudo_wrap {

  # Wraps the command in sudo if sudo exists and runs it

  if path_has_bin 'sudo' ; then
    sudo $@
  else
    $@
  fi

  return 0

}

function store_as_var {

  # Stores the output of the command into a variable without a subshell

  local Var
  local Tmp
  local Ret

  Var="${1}" ; shift
  Tmp="$(mktemp 2> /dev/null)" || {
    Tmp="$(mktemp -t tmp 2> /dev/null)" || return 128
  }
  $@ > "${Tmp}"
  Ret=$?
  read "${Var}" < "${Tmp}"
  rm "${Tmp}"

  return ${Ret}

}

function symlink {

  # Create a symbolic link $1 -> $2

  ensure_dir_exists "$(dirname "${2}")"
  if [[ "$(readlink -f "${2}")" != "${1}" ]] ; then
    rm -rf "${2}"
    if [[ -e "${1}" ]] ; then
      ln -sf "${1}" "${2}" || return 1
    else
      err_error "file does not exist: \`${1}'"
      return 1
    fi
  fi

  return 0

}

function to_lower {

  echo $@ | tr '[A-Z]' '[a-z]'

  return 0

}

function to_upper {

  echo $@ | tr '[a-z]' '[A-Z]'

  return 0

}

function y_or_n {

  # Ask a yes or no question

  local Answer
  local Default
  local Prompt

  Default=2

  case "${2}" in
    '')
      Default=2
      Prompt='(y/n)'
      ;;
    'y')
      Default=0
      Prompt='(Y/n)'
      ;;
    'n')
      Default=1
      Prompt='(y/N)'
      ;;
    *)
      Default=2
      Prompt='(y/n)'
      ;;
  esac

  while true ; do
    read -p "${1} ${Prompt}: " Answer

    Answer="$(to_lower ${Answer})"

    case "${Answer}" in
      '')
        if [ ! ${Default} -eq 2 ] ; then
          return ${Default}
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
