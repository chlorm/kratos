# This file is part of Kratos.
# Copyright (c) 2014-2016, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

SSH::Auto() {
  SSH::Requires
  SSH::GenerateKeys
  SSH::AuthorizedKeys
  SSH::KnownHosts

  # TODO: handle with user-agent
  ssh-add "${HOME}/.ssh/id_rsa" > /dev/null 2>&1
}

SSH::Requires() {
  # Makes sure the ssh directory exists
  Directory::Create "${HOME}/.ssh"
  # Makes sure the client configuration is installed
  [ -f "${HOME}/.ssh/config" ]
  # Make sure that we have the required binaries
  ${PathHasBinSSH_KEYGEN}
  ${PathHasBinOPENSSL}
}

SSH::GenerateKeys() {
  local Pass
  if ([ ! -f "${HOME}/.ssh/id_rsa.pub" ] && \
      [ ! -f "${HOME}/.ssh/id_ed25519.pub" ]) || \
     [ "${1}" == 'force' ] ; then
    # Creates new ssh keys with the provided password
    Pass="$(Prompt::PasswordConfirmation)"
    File::Remove "${HOME}/.ssh/id_rsa"
    ssh-keygen -N "${Pass}" -f "${HOME}/.ssh/id_rsa" -t rsa -b 4096
    File::Remove "${HOME}/.ssh/id_ed25519"
    ssh-keygen -N "${Pass}" -f "${HOME}/.ssh/id_ed25519" -t ed25519
  fi
}

SSH::AuthorizedKeys() {
  local Key
  local -a PopKeys
  # Populates the authorized_keys file
  File::Remove "${HOME}/.ssh/authorized_keys"
  PopKeys=($(
    find ${DOTFILES_DIR}/ssh/authorized-keys -type f -name '*.pub'
  ))
  if [[ ${#PopKeys[@]} -ge 1 ]] ; then
    for Key in "${PopKeys[@]}" ; do
      cat "${Key}" >> "${HOME}/.ssh/authorized_keys"
    done
  fi
}

SSH::KnownHosts() {
  ssh-keygen -H > /dev/null 2>&1
  File::Remove "${HOME}/.ssh/known_hosts.old"
}
