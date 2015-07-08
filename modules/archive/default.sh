# This file is part of Kratos.
# Copyright (c) 2014-2015, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

function archive {

  case "$1" in
    '-c')
      ;;
    '-e')
      ;;
    '-l')
      ;;
  esac

}

function asdfakdjsfj {
if [ -z "$1" ] ; then
  echo "ERROR: no input provided"
  exit 1
elif [ -f "$1" ] ; then
  case "$1" in
    *'.tar')
      path_hasbin tar || return 1
      tar xf "$1"
      ;;
    *'.tar.bz2')
      path_hasbin tar || return 1
      tar xjf "$1"
      ;;
    *'.tbz2')
      path_hasbin tar || return 1
      tar xjf "$1"
      ;;
    *'.bz2')
      path_hasbin bunzip2 || return 1
      bunzip2 "$1"
      ;;
    *'.tar.gz')
      path_hasbin tar || return 1
      tar xzf "$1"
      ;;
    *'.tgz')
      path_hasbin tar || return 1
      tar xzf "$1"
      ;;
    *'.gz')
      path_hasbin gunzip || return 1
      gunzip "$1"
      ;;
    *'.tar.xz')
      path_hasbin tar || return 1
      tar xJf "$1"
      ;;
    *'.txz')
      path_hasbin tar || return 1
      tar xJf "$1"
      ;;
    *'.rar')
      path_hasbin unrar || return 1
      unrar e "$1"
      ;;
    *'.zip')
      path_hasbin unzip || return 1
      unzip "$1"
      ;;
    *'.Z')
      path_hasbin uncompress || return 1
      uncompress "$1"
      ;;
    *'.7z')
      path_hasbin 7z || return 1
      7z x "$1"
      ;;
    *)
      echo "'$1' is not a file type supported by extract()"
      ;;
    esac
else
    echo "'$1' is not a file"
fi
}
