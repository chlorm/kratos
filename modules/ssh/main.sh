# This file is part of Kratos.
# Copyright (c) 2014-2015, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

function SshAuto {

  # Make sure that we have the required binaries
  PathHasBin 'ssh-keygen' || return 1
  PathHasBin 'openssl' || return 1

  # Makes sure the ssh directory exists
  EnsureDirExists "${HOME}/.ssh" || return 1

  # Makes sure the client configuration is installed
  [ -f "${HOME}/.ssh/config" ] || return 1

  ssh-keygen -H > /dev/null 2>&1 || return 1
  EnsureFileDestroy "${HOME}/.ssh/known_hosts.old" || return 1

  # Populates the authorized_keys file
  EnsureFileDestroy "${HOME}/.ssh/authorized_keys" || return 1
  local POP_KEYS=($(find ${DOTFILES_DIR}/ssh -type f | grep -v 'config$' | grep '.pub$'))
  if [ ${#POP_KEYS[@]} -ge 1 ] ; then
    for POP_KEY in "${POP_KEYS[@]}" ; do
      cat "${POP_KEY}" >> "${HOME}/.ssh/authorized_keys" || return 1
    done
  fi

  if [[ ! -f "${HOME}/.ssh/id_rsa.pub" && ! -f "${HOME}/.ssh/id_ed25519.pub" ]] ; then
    # Creates new ssh keys with the provided password
    local PASS="$(PasswordConfirmation)"
    EnsureFileDestroy "${HOME}/.ssh/id_rsa" || return 1
    ssh-keygen -N "${PASS}" -f "${HOME}/.ssh/id_rsa" -t rsa -b 4096 || return 1
    EnsureFileDestroy "${HOME}/.ssh/id_ed25519" || return 1
    ssh-keygen -N "${PASS}" -f "${HOME}/.ssh/id_ed25519" -t ed25519 || return 1
  fi

  ssh-add "${HOME}/.ssh/id_rsa" > /dev/null 2>&1 || return 1

  return 0

}
