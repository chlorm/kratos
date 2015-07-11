# This file is part of Kratos.
# Copyright (c) 2014-2015, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

os.kernel() { # Find host os kernel

  local KERNEL=$(tolower $(uname -s) $(echo ${OSTYPE}) |
    grep -m 1 -w -o '\(cygwin\|darwin\|dragonfly\|freebsd\|linux\|netbsd\|openbsd\)')

  if [ -z "$KERNEL" ] ; then
    err.error "not a supported operating system"
    return 1
  fi

  echo "$KERNEL"

  return 0

}

os.linux() { # Take first result of linux os name match

  os.linux.release() { # Finds linux distro via /etc/*-release

    cat $ROOT/etc/*-release 2> /dev/null

  }

  os.linux.uname() { # Finds linux distro via uname -a

    uname -a 2> /dev/null

  }

  os.linux.lsb() { # Find linux distro via linux standard base

    lsb_release -a 2> /dev/null

  }

  [ "$(os.kernel)" = 'linux' ] || return 1

  local LINUX

  LINUX=$(tolower "$(os.linux.release) $(os.linux.uname) $(os.linux.lsb)" |
    grep -m 1 -w -o '\(arch\|centos\|debian\|fedora\|gentoo\|nixos\|opensuse\|red\ hat\|suse\|ubuntu\)')

  if [ -z "$LINUX" ] ; then
    err.error "not a supported linux operating system"
    return 1
  fi

  echo "$LINUX"

  return 0

}
