# This file is part of Kratos.
# Copyright (c) 2014-2015, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

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
