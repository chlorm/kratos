# This file is part of Kratos.
# Copyright (c) 2014-2015, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

# TODO:
# + Add a fallback to use the ~/.cache directory and delete the directory on logout
# + Only setup tmp.dir during init, add function for returning the current tmp.dir

function TmpDir { # Get the path to the temporary directory

  local DIR
  local TMPDIR
  local TMPDIRS=("${ROOT}/dev/shm" "${ROOT}/run/shm" "${ROOT}/tmp" "${ROOT}/var/tmp")

  for DIR in "${TMPDIRS[@]}" ; do

    if [ -n "$(mount | grep '\(tmpfs\|ramfs\)' | grep "${DIR}" 2> /dev/null)" ] ; then
      TMPDIR="${DIR}/${USER}"
      break
    fi

  done

  if [ -z "${TMPDIR}" ] ; then
    ErrError 'Failed to find a tmp directory'
    return 1
  fi

  if [ ! -d "${TMPDIR}" ] ; then
    EnsureDirExists "${TMPDIR}" || return 1
    chmod 0700 "${TMPDIR}" || return 1
  fi

  symlink "${TMPDIR}" "${HOME}/.tmp" || return 1

  EnsureDirDestroy "${HOME}/.cache" || return 1
  EnsureDirExists "${TMPDIR}/cache" || return 1
  symlink "${TMPDIR}/cache" "${HOME}/.cache" || return 1

  # Create dotfiles session directory
  if [ ! -d "${TMPDIR}/dotfiles" ] ; then
    mkdir -p "${TMPDIR}/dotfiles" || return 1
  fi

  # Deprecated
  EnsureFileDestroy "${HOME}/.local/share/kratos/tmpdir"

  return 0

}
