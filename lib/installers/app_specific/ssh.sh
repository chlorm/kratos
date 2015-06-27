# This file is part of Kratos.
# Copyright (c) 2014-2015, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

ssh_auth_one() {

  cat "$1" >> "$HOME/.ssh/authorized_keys"

}

ssh_auth_keys() { # Populates the authorized_keys file

  [ -f "$HOME/.ssh/authorized_keys" ] && { rm -f "$HOME/.ssh/authorized_keys" ; }

  local KEYS

  array_from_str KEYS "$(find $DOTFILES_DIR/dotfiles/ssh -type f | grep -v 'config$' | grep '.pub$')"
  array_forall KEYS ssh_auth_one

}

ssh_gen_keys() { # Creates new ssh keys with the provided password

  local pass=$(password_confirmation)

  rm -f "$HOME/.ssh/id_rsa" 2> /dev/null
  rm -f "$HOME/.ssh/id_ed25519" 2> /dev/null

  ssh-keygen -N "$pass" -f "$HOME/.ssh/id_rsa" -t rsa -b 4096
  ssh-keygen -N "$pass" -f "$HOME/.ssh/id_ed25519" -t ed25519

}

ssh_repo_key_one() {

  if [ -f "$CPFX$1" ] ; then
    symlink "$CPFX$1" "$LPFX$1"
    return $?
  fi

  return 0

}

ssh_repo_keys() { # Create the keys from the git repo

  local CPFX="$DOTFILES_DIR/dotfiles/ssh/default_"
  local LPFX="$HOME/.ssh/id_"
  local KEYS
  
  array_from_str KEYS "rsa rsa.pub ed25519 ed25519.pub"
  array_forall KEYS ssh_repo_key_one

}

app_ssh_installed() {

  path_hasbin "ssh" || return 1
  path_hasbin "ssh-keygen" || return 1
  path_hasbin "openssl" || return 1

  return 0

}

app_ssh_cleanup() {

  return 0

}

app_ssh_configure() {

  app_ssh_installed || return 2

  exist -dc "$HOME/.ssh" || return 1

  dotfile_ln "ssh/config" || return 1

  # ??? remove old known hosts or something
  ssh-keygen -H > /dev/null 2>&1
  rm -f "$HOME/.ssh/known_hosts.old"

  ssh_auth_keys || { echo "Failed to update authorized_keys" >&2 ; return 1 ; }

  if [ ! -f "$HOME/.ssh/id_rsa.pub" ] && [ ! -f "$HOME/.ssh/id_ed25519.pub" ] ; then
    if [ -n "$DISPLAY" ] ; then
      ssh_repo_keys || { echo "Failed to populate client keys" >&2 ; return 1 ; }
    else
      ssh_gen_keys "" || { echo "Failed to generate client keys" >&2 ; return 1 ; }
    fi
  fi

  return 0

}
