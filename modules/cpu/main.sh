# This file is part of Kratos.
# Copyright (c) 2014-2015, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

function cpu.architecture { # Return CPU architecture without endianness or register size

  # Do NOT use `uname -m'. This returns the kernels arch, and on system like
  # Darwin it returns a hard-coded arch string that is invalid.  Only use
  # utilities that return the cpu's actual arch.  Kernel arch is handled
  # by `kernel_architecture'.

  # TODO: use sysctl on Darwin

  local architecture=

  case "$(os.kernel)" in
    'linux')
      architecture="$(lscpu | grep -m 1 -w -o "\(arm\|i686\|x86_64\)")"
      ;;
  esac

  if [ -z "$architecture" ] ; then
    err.error "failed to detect cpu architecture"
    return 1
  fi

  echo "$architecture" && return 0

  return 1

}

function cpu.register_size { # Find CPU register size (ie. 32bit/64bit)

  local register_size

  register_size=$(getconf LONG_BIT | grep -m 1 -w -o "\(8\|16\|32\|64\|\128\)" | grep -op '[0-9]+')

  [ -z "$register_size" ] || {
    err.error "could not determine cpu register size"
    return 1
  }

  echo "$register_size"

  return 0

}

function cpu.sockets {

  local SOCKETS=

  case "$(os.kernel)" in
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

function cpu.physical { # Find number of physical cpu cores

  # Assumes all sockets are identical, only some arm platforms won't
  # work with this logic

  local cpucores

  case $(os.kernel) in
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
    cpucores=$(($cpucores * $(cpu.sockets)))
  fi

  echo "$cpucores"

  return 0

}

function cpu.logical { # Find number of logical cpu cores

  # Assumes all sockets are identical, only some arm platforms won't
  # work with this logic

  local cputhreads

  case $(os.kernel) in
    'linux'|'freebsd')
      # Finds number of logical threads per physical core
      cputhreads=$(lscpu | grep -m 1 'Thread(s) per core:' | grep -oP '[0-9]+')
      if [ -n "$cputhreads" ] ; then
        # Convert to number of threads per cpu
        cputhreads=$(($cputhreads * $(cpu.physical)))
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
    cputhreads="$(cpu.physical)"
  else
    cpu.logical=$(($cputhreads * $(cpu.sockets)))
  fi

  echo "$cputhreads"

  return 0

}
