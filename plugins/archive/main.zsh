# This file is part of Kratos.
# Copyright (c) 2014-2016, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

KRATOS::Plugins:archive.extract() {
  if [[ -z "$@" ]] ; then
    KRATOS::Lib:err.error 'no input provided'
    return 1
  elif [[ -f "$@" ]] ; then
    case "$@" in
      *'.tar')
        KRATOS::Lib:path.has_bin tar || return 1
        tar xvf "$@" || return 2
        ;;
      *'.tar.bz2')
        KRATOS::Lib:path.has_bin tar || return 1
        tar xjvf "$@" || return 2
        ;;
      *'.tbz2')
        KRATOS::Lib:path.has_bin tar || return 1
        tar xjvf "$@" || return 2
        ;;
      *'.bz2')
        KRATOS::Lib:path.has_bin bunzip2 || return 1
        bunzip2 "$@" || return 2
        ;;
      *'.tar.gz')
        KRATOS::Lib:path.has_bin tar || return 1
        tar xzvf "$@" || return 2
        ;;
      *'.tgz')
        KRATOS::Lib:path.has_bin tar || return 1
        tar xzvf "$@" || return 2
        ;;
      *'.gz')
        KRATOS::Lib:path.has_bin gunzip || return 1
        gunzip "$@" || return 2
        ;;
      *'.tar.xz')
        KRATOS::Lib:path.has_bin tar || return 1
        tar xJvf "$@" || return 2
        ;;
      *'.txz')
        KRATOS::Lib:path.has_bin tar || return 1
        tar xJvf "$@" || return 2
        ;;
      *'.rar')
        KRATOS::Lib:path.has_bin unrar || return 1
        unrar e "$@" || return 2
        ;;
      *'.zip')
        KRATOS::Lib:path.has_bin unzip || return 1
        unzip "$@" || return 2
        ;;
      *'.Z')
        KRATOS::Lib:path.has_bin uncompress || return 1
        uncompress "$@" || return 2
        ;;
      *'.7z')
        KRATOS::Lib:path.has_bin 7z || return 1
        7z x "$@" || return 2
        ;;
      *)
        KRATOS::Lib:err.error "'$@' is not a supported file type"
        ;;
      esac
  else
      KRATOS::Lib:err.error "'$@' is not a file"
  fi
}
