# This file is part of Kratos.
# Copyright (c) 2014-2015, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

# TODO:
# + Add a fallback to use the ~/.cache directory and delete the directory on logout
# + Only setup tmp.dir during init, add function for returning the current tmp.dir

function DirCache { # Get the path to the temporary directory

  local DIR
  local CACHEDIR
  local CACHEDIRS

  CACHEDIRS=(
    "${ROOT}/dev/shm"
    "${ROOT}/run/shm"
    "${ROOT}/tmp"
    "${ROOT}/var/tmp"
  )

  for DIR in "${CACHEDIRS[@]}" ; do

    if [[ -n "$(mount | grep '\(tmpfs\|ramfs\)' |
                grep "${DIR}" 2> /dev/null)" ]] ; then
      CACHEDIR="${DIR}/${USER}"
      break
    fi

  done

  if [[ -z "${CACHEDIR}" ]] ; then
    ErrError 'Failed to find a tmp directory'
    return 1
  fi

  if [[ ! -d "${CACHEDIR}" ]] ; then
    EnsureDirExists "${CACHEDIR}" || return 1
    chmod 0700 "${CACHEDIR}" || return 1
  fi

  EnsureDirDestroy "${HOME}/.cache" || return 1

  symlink "${CACHEDIR}" "${HOME}/.cache" || return 1

  # Create dotfiles session directory
  EnsureDirExists "${CACHEDIR}/dotfiles" || return 1

  return 0

}
