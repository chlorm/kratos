# This file is part of Kratos.
# Copyright (c) 2014-2015, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

function ArchiveUsage {
  echo
}

function archive {

  case "${1}" in
    '-c')
      ;;
    '-e')
      ;;
    '-l')
      ;;
  esac

}

function ArchiveExtract {
if [ -z "${1}" ] ; then
  ErrError 'no input provided'
  exit 1
elif [ -f "${1}" ] ; then
  case "${1}" in
    *'.tar')
      PathHasBinErr 'tar' || return 1
      tar xf "${1}"
      ;;
    *'.tar.bz2')
      PathHasBinErr 'tar' || return 1
      tar xjf "${1}"
      ;;
    *'.tbz2')
      PathHasBinErr 'tar' || return 1
      tar xjf "${1}"
      ;;
    *'.bz2')
      PathHasBinErr 'bunzip2' || return 1
      bunzip2 "${1}"
      ;;
    *'.tar.gz')
      PathHasBinErr 'tar' || return 1
      tar xzf "${1}"
      ;;
    *'.tgz')
      PathHasBinErr 'tar' || return 1
      tar xzf "${1}"
      ;;
    *'.gz')
      PathHasBinErr 'gunzip' || return 1
      gunzip "${1}"
      ;;
    *'.tar.xz')
      PathHasBinErr 'tar' || return 1
      tar xJf "${1}"
      ;;
    *'.txz')
      PathHasBinErr 'tar' || return 1
      tar xJf "${1}"
      ;;
    *'.rar')
      PathHasBinErr 'unrar' || return 1
      unrar e "${1}"
      ;;
    *'.zip')
      PathHasBinErr 'unzip' || return 1
      unzip "${1}"
      ;;
    *'.Z')
      PathHasBinErr 'uncompress' || return 1
      uncompress "${1}"
      ;;
    *'.7z')
      PathHasBinErr '7z' || return 1
      7z x "${1}"
      ;;
    *)
      ErrError "\`${1}' is not a supported file type"
      ;;
    esac
else
  ErrError "\`${1}' is not a file"
fi
}
