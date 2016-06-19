# This file is part of Kratos.
# Copyright (c) 2014-2016, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

# Get the path to the temporary directory
Cache::Find() {
  local Dir
  local CacheDirs

  CacheDirs=(
    "${ROOT}/dev/shm"
    "${ROOT}/run/shm"
    "${ROOT}/tmp"
    "${ROOT}/var/tmp"
  )

  for Dir in "${CacheDirs[@]}" ; do
    if [ -n "$(mount | grep '\(tmpfs\|ramfs\)' |
                grep "${Dir}" 2> /dev/null)" ] ; then
      echo "${Dir}/${USER}"
      return 0
    fi
  done

  Error::Message 'could not find tmpfs'
  return 1
}

Cache::Mount() {
  local CacheDir

  CacheDir="$(Cache::Find)"

  # Fallback to a local directory if tmpfs is not found.
  if [ -z "${CacheDir}" ] ; then
    CacheDir="${HOME}/.cache"
  fi

  # Make sure cache is cleared on start
  Directory::Remove "${HOME}/.cache"

  if [ ! -d "${CacheDir}" ] ; then
    Directory::Create "${CacheDir}"
    chmod 0700 "${CacheDir}"
  fi

  # Make sure to wipe the cache directory incase it was not previously
  # on tmpfs.
  if [ "${CacheDir}" != "${HOME}/.cache" ] ; then
    Directory::Remove "${HOME}/.cache"
  fi

  # Make sure the symlink still points to the correct location.
  if [ "${CacheDir}" != "${HOME}/.cache" ] ; then
    Symlink::Create "${CacheDir}" "${HOME}/.cache"
  fi

  # Create the kratos tmp directory
  Directory::Create "${HOME}/.cache/kratos"
}
