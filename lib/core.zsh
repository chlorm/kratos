# This file is part of Kratos.
# Copyright (c) 2014-2016, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

# Return CPU architecture without endianness or address space size
KRATOS::Lib:cpu.architecture() {
  # Do NOT use `uname -m' to achieve this functionality.

  local Architecture

  case "$(KRATOS::Lib:os.kernel)" in
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
    KRATOS::Lib:err.error 'failed to detect cpu architecture'
    return 1
  fi

  echo "${Architecture}"

  return 0
}

# Find CPU adress space size (ie. 32bit/64bit)
KRATOS::Lib:cpu.address_space() {
  local AddressSpace

  AddressSpace=$(
    getconf LONG_BIT |
    grep --max-count 1 --word-regexp --only-matching "\(8\|16\|32\|64\|\128\)" |
    grep --only-matching -p '[0-9]+'
  ) || return 1

  [[ -z "${AddressSpace}" ]] || {
    KRATOS::Lib:err.error 'could not determine cpu address space size'
    return 1
  }

  echo "${AddressSpace}"

  return 0
}

KRATOS::Lib:cpu.sockets() {
  local Sockets

  case "$(KRATOS::Lib:os.kernel)" in
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

# Find number of physical cpu cores
KRATOS::Lib:cpu.physical() {
  # Assumes all sockets are identical, only some arm platforms
  # won't work with this logic.

  local CpuCores

  case "$(KRATOS::Lib:os.kernel)" in
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
    CpuCores=$(( ${CpuCores} * $(KRATOS::Lib:cpu.sockets) ))
  fi

  echo "${CpuCores}"

  return 0
}

# Find number of logical cpu cores
KRATOS::Lib:cpu.logical() {
  # Assumes all sockets are identical, only some arm platforms won't
  # work with this logic

  local CpuThreads

  case $(KRATOS::Lib:os.kernel) in
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
    CpuThreads=$(KRATOS::Lib:cpu.physical)
  else
    CpuThreads=$(( ${CpuThreads} * $(cpu_sockets) ))
  fi

  echo "${CpuThreads}"

  return 0
}

# Find download utility on system
KRATOS::Lib:download() {
  if KRATOS::Lib:path.has_bin 'curl' ; then
      curl -sOL $@ && return 0
  elif KRATOS::Lib:path.has_bin 'wget' ; then
      wget $@ && return 0
  elif KRATOS::Lib:path.has_bin 'fetch' ; then
      fetch $@ && return 0
  else
    KRATOS::Lib:err.error 'no download utility found'
    return 1
  fi

  KRATOS::Lib:err.error 'unable to download file'
  return 1
}

KRATOS::Lib:ensure.dir_destroy() {
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

KRATOS::Lib:ensure.dir_exists() {
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

KRATOS::Lib:ensure.file_destroy() {
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

KRATOS::Lib:ensure.file_exists() {
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

KRATOS::Lib:err.call_stack() {
  echo "${funcstack[3]}"

  return 0
}

KRATOS::Lib:err.error() {
  if [[ -n "${2}" ]] ; then
    echo "Kratos: ERROR in \`${2}': ${1}" > /dev/stderr
  else
    echo "Kratos: ERROR in \`$(KRATOS::Lib:err.call_stack)': ${1}" > /dev/stderr
  fi

  return 0
}

KRATOS::Lib:err.warn() {
  if [[ -n "${2}" ]] ; then
    echo "Kratos: WARNING in \`${2}': ${1}" > /dev/stderr
  else
    echo "Kratos: WARNING in \`$(KRATOS::Lib:err.call_stack)': ${1}" > /dev/stderr
  fi

  return 0
}

# Determine if the user is root
KRATOS::Lib:is_root() {
  [[ $(id -u) -eq 0 ]] || return 1

  return 0
}

# Source specified init file
KRATOS::Lib:load.one() {
  if [[ -n "$(echo "${1}" | grep '\(~$\|^#\)')" ]] ; then
    return 0
  fi

  source "${1}" || {
    KRATOS::Lib:err.error "Failed to load: ${1}"
    return 1
  }

  return 0
}

# Load all of specified init type
KRATOS::Lib:load.all() {
  local Completion
  local -a Completions
  local Init
  local -a Inits
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

  # Interactive shells
  if [[ "${1}" == 'interactive' ]] ; then
    # Completions
    unset Plugin
    # Find module completions
    Completions=($(find "${KRATOS_DIR}/modules" -type f -name "_*"))
    # Find plugin completions
    for Plugin in "${KRATOS_PLUGINS[@]}" ; do
      Completions+=($(
        find ${KRATOS_DIR}/plugins \
          -type f -name "_*" -iwholename "*${Plugin}*" -print0
      ))
      for Completion in "${Completions[@]}" ; do
        if [[ -f "${Completion}" ]] ; then
          # Appending to the array (e.g. +=) breaks fpath
          fpath=("$(dirname "${Completion}")" $fpath)
        fi
      done
      unset Completion
      unset Completions
      Completions=()
    done

    # Color scheme
    KRATOS::Lib:load.one \
      "${KRATOS_DIR}/themes/color-schemes/${KRATOS_COLOR_SCHEME}.color-scheme.zsh"

    # Prompt theme
    KRATOS::Lib:load.one \
      "${KRATOS_DIR}/themes/prompts/${KRATOS_PROMPT}.prompt.zsh"
  fi



  for Init in "${Inits[@]}" ; do
    KRATOS::Lib:load.one "${Init}"
  done

  return 0
}

# Find host os kernel
KRATOS::Lib:os.kernel() {
  KRATOS::Lib:os.kernel_ostype() {
    echo "${OSTYPE}" > /dev/null 2>&1
  }

  KRATOS::Lib:os.kernel_uname() {
    uname -s 2> /dev/null
  }

  local Kernel

  Kernel=$(
    KRATOS::Lib:to_lower "$(KRATOS::Lib:os.kernel_ostype) $(KRATOS::Lib:os.kernel_uname)" |
    grep --max-count 1 --word-regexp --only-matching \
      '\(cygwin\|darwin\|freebsd\|linux\)'
  )

  if [[ -z "${Kernel}" ]] ; then
    KRATOS::Lib:err.error 'not a supported operating system'
    return 1
  fi

  echo "${Kernel}"

  return 0
}

# Take first result of linux os name match
KRATOS::Lib:os.linux() {
  KRATOS::Lib:os.linux_release() {
    # Finds linux distro via /etc/*-release
    cat ${ROOT}/etc/*-release 2> /dev/null
  }

  KRATOS::Lib:os.linux_uname() {
    # Finds linux distro via uname -a
    uname -a 2> /dev/null
  }

  KRATOS::Lib:os.linux_lsb() {
    # Find linux distro via linux standard base
    lsb_release -a 2> /dev/null
  }

  [[ "$(KRATOS::Lib:os.kernel)" == 'linux' ]] || return 1

  local Linux

  Linux="$(
    KRATOS::Lib:to_lower "$(KRATOS::Lib:os.linux_release) $(KRATOS::Lib:os.linux_uname) $(KRATOS::Lib:os.linux_lsb)" |
    grep --max-count 1 --word-regexp --only-matching \
      '\(arch\|centos\|debian\|fedora\|gentoo\|nixos\|opensuse\|red\ hat\|suse\|triton\|ubuntu\)'
  )"

  if [[ -z "${Linux}" ]] ; then
    KRATOS::Lib:err.error "not a supported linux operating system: ${Linux}"
    return 1
  fi

  echo "${Linux}"

  return 0
}

KRATOS::Lib:password_confirmation() {
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

# Add direcory to $PATH
KRATOS::Lib:path.add() {
  if [[ -z "$(echo "${PATH}" | grep "${1}" 2> /dev/null)" && -d "${1}" ]] ; then
    export PATH="${PATH}:${1}"
  fi

  return 0
}

# Remove directory from $PATH
KRATOS::Lib:path.remove() {
  if [[ -n "$(echo "${PATH}" | grep "${1}" 2> /dev/null)" ]] ; then
    export PATH=`echo -n $PATH | awk -v RS=: -v ORS=: '$0 != "'$1'"' | sed 's/:$//'`
  fi

  return 0
}

# Finds the path to the binary
KRATOS::Lib:bin.path() {
  if [[ $# -ne 1 ]] ; then
    return 2
  fi

  KRATOS::Lib:path.has_bin "${1}" > /dev/null 2>&1 || return 1

  whence -p "${1}" |
  awk '{ print $3 ; exit }' || return 1

  return 0
}

# Resolves the absolute path of the binary
KRATOS::Lib:bin.abs_path() {
  local Bin

  Bin="$(whereis -b ${1} 2> /dev/null | awk '{ print $2 ; exit }')"

  [[ -n "${Bin}" ]] || return 1

  echo "${Bin}"

  return 0
}

# Test to see if a binary exists in the path
KRATOS::Lib:path.has_bin() {
  [[ $# -ne 1 ]] && return 2

  whence -p "${1}" > /dev/null 2>&1 || {
    KRATOS::Lib:err.error "\`${1}' is not installed"
    return 1
  }

  return 0
}

# Checks to see if the process is running
KRATOS::Lib:proc.exists() {
  if [[ $# -ne 1 ]] ; then
    return 1
  fi

  kill -0 "${1}" > /dev/null 2>&1
}

# Checks the pidfile to see if the process is running
KRATOS::Lib:proc.pid_file() {
  if [[ -f "${1}" ]] ; then
  	KRATOS::Lib:proc.exists "$(cat ${1} 2> /dev/null)"
  fi
}

# Start an application in the background
KRATOS::Lib:run_quiet() {
  KRATOS::Lib:path.has_bin "${1}" || return 1

  local Pid

  Pid="$(pgrep ${1})"

  if [[ -z "${Pid}" ]] ; then
  	$@ > /dev/null 2>&1 || return 1
  fi

  return 0
}

# Returns the shell executing the current script
KRATOS::Lib:shell() {
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
        KRATOS::Lib:bin.abs_path "${Lshell}"
      )"
    )"
  )"

  # Remove appended major version
  Lshell="$(
    echo "${Lshell}" |
    sed 's/^\([a-z]*\).*/\1/'
  )"

  Lshell="$(
    KRATOS::Lib:to_lower "${Lshell}"
  )"

  echo "${Lshell}"
}

# Wraps the command in sudo if sudo exists and runs it
KRATOS::Lib:sudo_wrap() {
  if KRATOS::Lib:path.has_bin 'sudo' ; then
    sudo $@
  else
    $@
  fi

  return 0
}

# Stores the output of the command into a variable without a subshell
KRATOS::Lib:store_as_var() {
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

# Create a symbolic link $1 -> $2
KRATOS::Lib:symlink() {
  KRATOS::Lib:ensure.dir_exists "$(dirname "${2}")"
  if [[ "$(readlink -f "${2}")" != "${1}" ]] ; then
    rm -rf "${2}"
    if [[ -e "${1}" ]] ; then
      ln -sf "${1}" "${2}" || return 1
    else
      KRATOS::Lib:err.error "file does not exist: \`${1}'"
      return 1
    fi
  fi

  return 0
}

KRATOS::Lib:to_lower() {
  echo $@ | tr '[A-Z]' '[a-z]'

  return 0
}

KRATOS::Lib:to_upper() {
  echo $@ | tr '[a-z]' '[A-Z]'

  return 0
}

# Ask a yes or no question
KRATOS::Lib:y_or_n() {
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

    Answer="$(KRATOS::Lib:to_lower ${Answer})"

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
