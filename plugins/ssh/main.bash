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
  SSH::FixPermissions

  # TODO: handle with user-agent
  ssh-add "${HOME}/.ssh/id_rsa" > /dev/null 2>&1
}

SSH::Requires() {
  # Makes sure the ssh directory exists
  Directory::Create "${HOME}/.ssh"
  # Makes sure the client configuration is installed
  [ -f "${HOME}/.ssh/config" ] || {
    Log::Message 'error' 'ssh config is not installed'
    return 1
  }
  # Make sure that we have the required binaries
  Path::Check 'ssh-keygen'
  Path::Check 'openssl'
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

# (Re)Populates the authorized_keys file
SSH::AuthorizedKeys() {
  local Key

  File::Remove "${HOME}/.ssh/authorized_keys"

  while read Key ; do
    if [ -z "${Key}" ] ; then
      continue
    fi
    cat "${Key}" >> "${HOME}/.ssh/authorized_keys"
  done < <(find ${DOTFILES_DIR}/ssh/authorized-keys -type f -name '*.pub')
}

# Make sure all directories and files have the correct permissions
# to make sure everything works with StrictModes enabled.
SSH::FixPermissions() {
  local IsPrivateKey
  local PubKey
  local SshFile
  local -a SshFiles

  mapfile -t SshFiles < <(find "${HOME}/.ssh" -type f)

  for SshFile in "${SshFiles[@]}" ; do
    IsPrivateKey="$(cat "${SshFile}" | grep -o -m 1 'PRIVATE KEY-----')"

    if [ "${IsPrivateKey}" == 'PRIVATE KEY-----' ] ; then
      # Private keys should never be readable by other users
      chmod 0600 "${SshFile}"
    else
      # All files other than private keys need to be readable by root
      chmod 0644 "${SshFile}"
    fi
  done
}

SSH::KnownHosts() {
  ssh-keygen -H > /dev/null 2>&1
  File::Remove "${HOME}/.ssh/known_hosts.old"
}
