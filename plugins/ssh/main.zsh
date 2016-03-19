# This file is part of Kratos.
# Copyright (c) 2014-2016, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

KRATOS::Plugins:ssh.auto() {
  KRATOS::Plugins:ssh.requires
  KRATOS::Plugins:ssh.generate_keys
  KRATOS::Plugins:ssh.authorized_keys
  KRATOS::Plugins:ssh.known_hosts

  # TODO: handle with user-agent
  ssh-add "${HOME}/.ssh/id_rsa" > /dev/null 2>&1 || return 1

  return 0
}

KRATOS::Plugins:ssh.requires() {
  # Makes sure the ssh directory exists
  KRATOS::Lib:ensure.dir_exists "${HOME}/.ssh" || return 1
  # Makes sure the client configuration is installed
  [[ -f "${HOME}/.ssh/config" ]] || return 1
  # Make sure that we have the required binaries
  ${PathHasBinSSH_KEYGEN} || return 1
  ${PathHasBinOPENSSL} || return 1
  return 0
}

KRATOS::Plugins:ssh.generate_keys() {
  local Pass
  if ([[ ! -f "${HOME}/.ssh/id_rsa.pub" && ! -f "${HOME}/.ssh/id_ed25519.pub" ]]) \
      || [[ "${1}" == 'force' ]] ; then
    # Creates new ssh keys with the provided password
    Pass="$(KRATOS::Lib:password_confirmation)"
    KRATOS::Lib:ensure.file_destroy "${HOME}/.ssh/id_rsa" || return 1
    ssh-keygen -N "${Pass}" -f "${HOME}/.ssh/id_rsa" -t rsa -b 4096 || return 1
    KRATOS::Lib:ensure.file_destroy "${HOME}/.ssh/id_ed25519" || return 1
    ssh-keygen -N "${Pass}" -f "${HOME}/.ssh/id_ed25519" -t ed25519 || return 1
  fi
  return 0
}

KRATOS::Plugins:ssh.authorized_keys() {
  local Key
  local PopKeys
  # Populates the authorized_keys file
  KRATOS::Lib:ensure.file_destroy "${HOME}/.ssh/authorized_keys" || return 1
  PopKeys=($(
    find ${DOTFILES_DIR}/ssh/authorized-keys -type f -name '*.pub'
  )) || return 1
  if [[ ${#PopKeys[@]} -ge 1 ]] ; then
    for Key in "${PopKeys[@]}" ; do
      cat "${Key}" >> "${HOME}/.ssh/authorized_keys" || return 1
    done
  fi
  return 0
}

KRATOS::Plugins:ssh.known_hosts() {
  ssh-keygen -H > /dev/null 2>&1 || return 1
  KRATOS::Lib:ensure.file_destroy "${HOME}/.ssh/known_hosts.old" || return 1
  return 0
}
