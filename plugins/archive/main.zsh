# This file is part of Kratos.
# Copyright (c) 2014-2015, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

KRATOS::Plugins:archive.usage() {
  echo
}

KRATOS::Plugins:archive.command() {
  case "$1" in
    '-c')
      ;;
    '-e')
      ;;
    '-l')
      ;;
  esac
}

KRATOS::Plugins:archive.extract() {
  if [[ -z "$1" ]] ; then
    KRATOS::Lib:err.error "no input provided"
    exit 1
  elif [[ -f "$1" ]] ; then
    case "$1" in
      *'.tar')
        KRATOS::Lib:path.has_bin tar || return 1
        tar xf "$1"
        ;;
      *'.tar.bz2')
        KRATOS::Lib:path.has_bin tar tar || return 1
        tar xjf "$1"
        ;;
      *'.tbz2')
        KRATOS::Lib:path.has_bin tar tar || return 1
        tar xjf "$1"
        ;;
      *'.bz2')
        KRATOS::Lib:path.has_bin tar bunzip2 || return 1
        bunzip2 "$1"
        ;;
      *'.tar.gz')
        KRATOS::Lib:path.has_bin tar tar || return 1
        tar xzf "$1"
        ;;
      *'.tgz')
        KRATOS::Lib:path.has_bin tar tar || return 1
        tar xzf "$1"
        ;;
      *'.gz')
        KRATOS::Lib:path.has_bin tar gunzip || return 1
        gunzip "$1"
        ;;
      *'.tar.xz')
        KRATOS::Lib:path.has_bin tar tar || return 1
        tar xJf "$1"
        ;;
      *'.txz')
        KRATOS::Lib:path.has_bin tar tar || return 1
        tar xJf "$1"
        ;;
      *'.rar')
        KRATOS::Lib:path.has_bin tar unrar || return 1
        unrar e "$1"
        ;;
      *'.zip')
        KRATOS::Lib:path.has_bin tar unzip || return 1
        unzip "$1"
        ;;
      *'.Z')
        KRATOS::Lib:path.has_bin tar uncompress || return 1
        uncompress "$1"
        ;;
      *'.7z')
        KRATOS::Lib:path.has_bin tar 7z || return 1
        7z x "$1"
        ;;
      *)
        KRATOS::Lib:err.error "'$1' is not a supported file type"
        ;;
      esac
  else
      KRATOS::Lib:err.error "'$1' is not a file"
  fi
}
