# This file is part of Kratos.
# Copyright (c) 2014-2016, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

KRATOS::Plugins:ssh.auto() {

  local Key
  local PopKeys
  local Pass

  # Make sure that we have the required binaries
  ${PathHasBinSSH_KEYGEN} || return 1
  ${PathHasBinOPENSSL} || return 1

  # Makes sure the ssh directory exists
  KRATOS::Lib:ensure.dir_exists "${HOME}/.ssh" || return 1

  # Makes sure the client configuration is installed
  [[ -f "${HOME}/.ssh/config" ]] || return 1

  ssh-keygen -H > /dev/null 2>&1 || return 1
  KRATOS::Lib:ensure.file_destroy "${HOME}/.ssh/known_hosts.old" || return 1

  # Populates the authorized_keys file
  KRATOS::Lib:ensure.file_destroy "${HOME}/.ssh/authorized_keys" || return 1
  PopKeys=($(
    find ${DOTFILES_DIR}/ssh -type f |
      grep -v 'config$' |
      grep '.pub$'
  ))
  if [[ ${#PopKeys[@]} -ge 1 ]] ; then
    for Key in "${PopKeys[@]}" ; do
      cat "${Key}" >> "${HOME}/.ssh/authorized_keys" || return 1
    done
  fi

  if [[ ! -f "${HOME}/.ssh/id_rsa.pub" && ! -f "${HOME}/.ssh/id_ed25519.pub" ]] ; then
    # Creates new ssh keys with the provided password
    Pass="$(password_confirmation)"
    ensure_file_destroy "${HOME}/.ssh/id_rsa" || return 1
    ssh-keygen -N "${Pass}" -f "${HOME}/.ssh/id_rsa" -t rsa -b 4096 || return 1
    EnsureFileDestroy "${HOME}/.ssh/id_ed25519" || return 1
    ssh-keygen -N "${Pass}" -f "${HOME}/.ssh/id_ed25519" -t ed25519 || return 1
  fi

  # TODO: handle with user-agent
  ssh-add "${HOME}/.ssh/id_rsa" > /dev/null 2>&1 || return 1

  return 0

}
