# This file is part of Kratos.
# Copyright (c) 2014-2016, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

# TODO:
# + Add a fallback to use the ~/.cache directory and delete the directory on logout
# + Only setup tmp.dir during init, add function for returning the current tmp.dir

KRATOS::Modules:cache.directory() { # Get the path to the temporary directory
  local Dir
  local CacheDir
  local CacheDirs

  CacheDirs=(
    "${ROOT}/dev/shm"
    "${ROOT}/run/shm"
    "${ROOT}/tmp"
    "${ROOT}/var/tmp"
  )

  for Dir in "${CacheDirs[@]}" ; do

    if [[ -n "$(mount | grep '\(tmpfs\|ramfs\)' |
                grep "${Dir}" 2> /dev/null)" ]] ; then
      CacheDir="${Dir}/${USER}"
      break
    fi

  done

  if [[ -z "${CacheDir}" ]] ; then
    KRATOS::Lib:err.error 'Failed to find a tmp directory'
    return 1
  fi

  if [[ ! -d "${CacheDir}" ]] ; then
    KRATOS::Lib:ensure.dir_exists "${CacheDir}" || return 1
    chmod 0700 "${CacheDir}" || return 1
  fi

  KRATOS::Lib:ensure.dir_destroy "${HOME}/.cache" || return 1

  KRATOS::Lib:symlink "${CacheDir}" "${HOME}/.cache" || return 1

  # Create dotfiles session directory
  KRATOS::Lib:ensure.dir_exists "${CacheDir}/dotfiles" || return 1

  return 0
}
