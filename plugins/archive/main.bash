# This file is part of Kratos.
# Copyright (c) 2014-2016, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

Archive::Extract() {
  if [ -z "$@" ] ; then
    Debug::Message 'error' 'no input provided'
    return 1
  elif [ -f "$@" ] ; then
    case "$@" in
      *'.tar')
        Path::Check 'tar'
        tar xvf "$@"
        ;;
      *'.tar.bz2')
        Path::Check 'tar'
        tar xjvf "$@"
        ;;
      *'.tbz2')
        Path::Check 'tar'
        tar xjvf "$@"
        ;;
      *'.bz2')
        Path::Check 'bunzip2'
        bunzip2 "$@"
        ;;
      *'.tar.gz')
        Path::Check 'tar'
        tar xzvf "$@"
        ;;
      *'.tgz')
        Path::Check 'tar'
        tar xzvf "$@"
        ;;
      *'.gz')
        Path::Check 'gunzip'
        gunzip "$@"
        ;;
      *'.tar.xz')
        Path::Check 'tar'
        tar xJvf "$@"
        ;;
      *'.txz')
        Path::Check 'tar'
        tar xJvf "$@"
        ;;
      *'.rar')
        Path::Check 'unrar'
        unrar e "$@"
        ;;
      *'.zip')
        Path::Check 'unzip'
        unzip "$@"
        ;;
      *'.Z')
        Path::Check 'uncompress'
        uncompress "$@"
        ;;
      *'.7z')
        Path::Check '7z'
        7z x "$@"
        ;;
      *)
        Debug::Message 'error' "'$@' is not a supported file type"
        ;;
      esac
  else
      Debug::Message 'error' "'$@' is not a file"
  fi
}
