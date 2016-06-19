# This file is part of Kratos.
# Copyright (c) 2014-2016, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

# Find any available user-agents
UserAgent::KnownExecutables() {
  local Executable
  local -a Executables

  Executables=(
    'gpg-agent'
    'ssh-agent'
  )

  # find installed editors
  for Executable in "${Executables[@]}" ; do
    if Path::Check "${Executable}" ; then
      # gpg-agent requires pinentry
      if [[ "${Executable}" == 'gpg-agent' && \
            -z "$(UserAgent::PinentryExecutables)" ]] ; then
        continue
      fi
      echo "${Executable}"
      return 0
    fi
  done

  Error::Message 'no user agent installed'
  return 1

  return 0
}

# Find preferred user-agent if one is available
UserAgent::Preferred() {
  local PreferredUserAgent

  if [ -n "${KRATOS_USER_AGENT_PREFERENCE[@]}" ] ; then
    for PreferredUserAgent in "${KRATOS_USER_AGENT_PREFERENCE[@]}" ; do
      if Path::Check "${PreferredUserAgent}" ; then
        echo "KRATOS_PREFERRED_USER_AGENT=\"${PreferredUserAgent}\"" >> \
          "${HOME}/.local/share/kratos/preferences"
        return 0
      fi
    done
  fi

  Error::Message 'no preferred user agent found'
  return 1
}

# Find any available pinentry programs
UserAgent::PinentryExecutables() {
  local Executable
  local -a Executables

  Executables=(
    'pinentry'
    'pinentry-qt'
    'pinentry-curses'
    'pinentry-gtk'
  )

  # find installed pinentry programs
  for Executable in "${Executables[@]}" ; do
    if Path::Check "${Executable}" ; then
      echo "${Executable}"
      return 0
    fi
  done

  Error::Message 'no pinentry program installed'
  return 1
}

# Find location of pcsc driver if available
UserAgent::PcscDriver() {
  local PcscInPath
  local PcscPath
  local -a PcscPaths

  PcscPaths=(
    '/run/current-system/sw/lib/'
    "${HOME}/.nix-profile/lib/"
    '/usr/local/lib/'
    '/usr/lib64/'
    '/lib64/'
    '/usr/lib/'
    '/lib/'
  )

  # find installed editors
  for PcscPath in "${PcscPaths[@]}" ; do
    PcscInPath="$(
      find "${PcscPath}" -name libpcsclite.so\* 2> /dev/null |
        head -n 1
    )"
    if [ -n "${PcscPath}" ] ; then
      echo "${PcscPath}"
      return 0
    fi
  done

  Error::Message 'no pcsc driver installed'
  return 1

  return 0
}

# Build gpg-agent configuration
UserAgent::GpgAgent() {
  # TODO: add support for appending to Kratos managed gpg config files

  # These configs are always built on startup to ensure that paths point
  # to executables that exist.

  File::Remove "${HOME}/.cache/kratos/scdaemon.conf"
  File::Create "${HOME}/.cache/kratos/scdaemon.conf"
  File::Remove "${HOME}/.gnupg/scdaemon.conf"
  Symlink::Create \
    "${HOME}/.cache/kratos/scdaemon.conf" \
    "${HOME}/.gnupg/scdaemon.conf"
  echo "pcsc-driver $(UserAgent::PcscDriver)" >> \
    "${HOME}/.gnupg/scdaemon.conf"
  echo "card-timeout 5" >> "${HOME}/.gnupg/scdaemon.conf"
  echo "disable-ccid" >> "${HOME}/.gnupg/scdaemon.conf"

  File::Remove "${HOME}/.cache/kratos/gpg-agent.conf"
  File::Create "${HOME}/.cache/kratos/gpg-agent.conf"
  File::Remove "${HOME}/.gnupg/gpg-agent.conf"
  Symlink::Create \
    "${HOME}/.cache/kratos/gpg-agent.conf" \
    "${HOME}/.gnupg/gpg-agent.conf"
  echo "pinentry-program $(UserAgent::PinentryExecutables)" >> \
    "${HOME}/.gnupg/gpg-agent.conf"
}

# Additional commandline arguments for specific user-agents
UserAgent::DefaultArgs() {
  local DefaultArgs
  local UserAgent

  if [ -n "${KRATOS_PREFERRED_USER_AGENT}" ] ; then
    UserAgent="${KRATOS_PREFERRED_USER_AGENT}"
  else
    UserAgent="$(UserAgent::KnownExecutables)"
  fi

  case "${UserAgent}" in
    'gpg-agent')
      echo '--daemon --enable-ssh-support'
      ;;
  esac

  return 0
}

UserAgent::Command() {
  if [ -z "${KRATOS_PREFERRED_USER_AGENT}" ] ; then
    KRATOS_PREFERRED_USER_AGENT="$(UserAgent::KnownExecutables)"
  fi

  if [ -z "${KRATOS_USER_AGENT_ARGS}" ] ; then
    KRATOS_USER_AGENT_ARGS="$(UserAgent::DefaultArgs)"
  fi

  if [ "${KRATOS_PREFERRED_USER_AGENT}" == 'gpg-agent' ] ; then
    if [[ ! -f "${HOME}/.gnupg/gpg-agent.conf" || \
          ! -f "${HOME}/.gnupg/scdaemon.conf" ]] ; then
      UserAgent::GpgAgent
    fi
  fi

  if [ ! -f "${HOME}/.cache/kratos/user_agent" ] ; then
    Directory::Create "${HOME}/.cache/kratos"
    echo "${KRATOS_PREFERRED_USER_AGENT}${KRATOS_USER_AGENT_ARGS:+ ${KRATOS_USER_AGENT_ARGS}} > /dev/null" > \
      "${HOME}/.cache/kratos/user_agent"
  fi
}

# Make sure the running user agent is the correct one
UserAgent::Proper() {
  local CurrentUserAgent
  local ProperUserAgent
  local Pid
  local -a Pids
  local UserAgent

  UserAgent="${1}"

  if [ ! -f "${HOME}/.cache/kratos/user_agent" ] ; then
    killall ssh-agent 2> /dev/null
    killall gpg-agent 2> /dev/null
    unset SSH_AGENT_PID
    unset SSH_AUTH_SOCK
    UserAgent::Command
    (source "${HOME}/.cache/kratos/user_agent")
    export SSH_AUTH_SOCK
    export GPG_AGENT_INFO
    export GNOME_KEYRING_CONTROL
    export GNOME_KEYRING_PID
  else
    CurrentUserAgent="$(
      cat "${HOME}/.cache/kratos/user_agent" 2> /dev/null |
        awk '{ print $1 ; exit }' |
        xargs basename 2> /dev/null
    )"
    ProperUserAgent="$(
      echo "${UserAgent}" |
        awk '{ print $1 ; exit }' |
        xargs basename 2> /dev/null
    )"
    if [[ -n "${CurrentUserAgent}" && \
          "${CurrentUserAgent}" != "${ProperUserAgent}" ]] ; then
      Pids=($(ps ux | grep "${CurrentUserAgent}" | awk '{print $2}'))
      for Pid in ${Pids[@]} ; do
        kill ${Pid}
      done
      unset SSH_AGENT_PID
      unset SSH_AUTH_SOCK
    fi
  fi
}

UserAgent::Auto() {
  UserAgent::Proper || return 1

  # Make sure a user-agent was started
  if ssh-add -L 2> /dev/null ; then
    return 0
  else
    return 1
  fi
}
