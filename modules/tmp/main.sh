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
    ErrError "Failed to find a tmp directory"
    return 1
  fi

  if [ ! -d "${TMPDIR}" ] ; then
    mkdir "${TMPDIR}" || return 1
    chmod 0700 "${TMPDIR}" || return 1
  fi

  ln -sf "${TMPDIR}" "${HOME}/.tmp" || return 1

  exist -dx "${HOME}/.cache" || return 1
  mkdir -p "${TMPDIR}/cache" || return 1
  ln -sf "${TMPDIR}/cache" "${HOME}/.cache" || return 1

  # Create dotfiles session directory
  if [ ! -d "${TMPDIR}/dotfiles" ] ; then
    mkdir -p "${TMPDIR}/dotfiles" || return 1
  fi

  exist -dc "${HOME}/.local/share/kratos"
  exist -fx "${HOME}/.local/share/kratos/tmpdir"
  touch "${HOME}/.local/share/kratos/tmpdir"
  echo "TMPLOCAL=\"${HOME}/.tmp\"" >> "${HOME}/.local/share/kratos/tmpdir"

  return 0

}
