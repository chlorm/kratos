# This file is part of Kratos.
# Copyright (c) 2014-2016, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

# Source specified init file
Loader::One() {
  if [ -n "$(echo "${1}" | grep '\(~$\|^#\)')" ] ; then
    return 0
  fi

  source "${1}" || {
    Debug::Message 'error' "Failed to load: ${1}"
    return 1
  }
}

# Load all of specified init type
Loader::All() {
  local Completion
  local -a Completions
  local Init
  local -a Inits
  local Plugin
  local PluginLoaderExists

  if [ -f "${HOME}/.cache/kratos/cache-init-${1}" ] ; then
    source "${HOME}/.cache/kratos/cache-init-${1}"
  else
    Inits=(
      # Modules
      $(find "${KRATOS_DIR}/modules" -type f -name "${1}.bash")
      # Active plugins
      $(for Plugin in "${KRATOS_PLUGINS[@]}" ; do
        PluginLoaderExists="$(
          find ${KRATOS_DIR}/plugins \
            -type f -name "${1}.bash" -iwholename "*${Plugin}*"
        )"
        if [ -f "${PluginLoaderExists}" ] ; then
          echo "${PluginLoaderExists}"
        fi
      done)
    )
  fi

  # Interactive shells
  if [ "${1}" == 'interactive' ] ; then
    # Completions
    unset Plugin
    # Find module completions
    #Completions=($(find "${KRATOS_DIR}/modules" -type f -name "_*"))
    ## Find plugin completions
    #for Plugin in "${KRATOS_PLUGINS[@]}" ; do
    #  Completions+=($(
    #    find ${KRATOS_DIR}/plugins \
    #      -type f -name "_*" -iwholename "*${Plugin}*" -print0
    #  ))
    #  for Completion in "${Completions[@]}" ; do
    #    if [[ -f "${Completion}" ]] ; then
    #      # Appending to the array (e.g. +=) breaks fpath
    #      fpath=("$(dirname "${Completion}")" $fpath)
    #    fi
    #  done
    #  unset Completion
    #  unset Completions
    #  Completions=()
    #done

    # Color scheme
    Loader::One \
      "${KRATOS_DIR}/themes/color-schemes/${KRATOS_COLOR_SCHEME}.color-scheme.bash"

    # Prompt theme
    Loader::One \
      "${KRATOS_DIR}/themes/prompts/${KRATOS_PROMPT}.prompt.bash"
  fi

  for Init in "${Inits[@]}" ; do
    Loader::One "${Init}"
  done

  # Cache inits for subsequent runs to prevent unnecessary forking
  if [[ -d "${HOME}/.cache/kratos" && \
      ! -f "${HOME}/.cache/kratos/cache-init-${1}" ]] ; then
    echo "Inits=(${Inits[@]})" > "${HOME}/.cache/kratos/cache-init-${1}"
  fi
}

# Returns the shell executing the current script
shell() {
  local Lshell
  local Lproc

  Lproc="$(ps hp $$ | grep "$$")"

  # Workaround for su spawned shells
  if [ -n "$(echo "${Lproc}" | grep '\-su')" ] ; then
    Lshell="$(
      basename "$(
        echo "${Lproc}" |
        sed 's/^.*(\([^)]*\)).*$/\1/'
      )"
    )"
  else
    Lshell="$(
      basename "$(
        echo "${Lproc}" |
        sed 's/-//' |
        awk '{ print $5 ; exit }'
      )"
    )"
  fi

  # Resolve symlinked shells
  Lshell="$(
    basename "$(
      Path::Bin.abs "${Lshell}"
    )"
  )"

  # Remove appended major version
  Lshell="$(
    echo "${Lshell}" |
      sed 's/^\([a-z]*\).*/\1/'
  )"

  Lshell="$(
    String::LowerCase "${Lshell}"
  )"

  echo "${Lshell}"
}

KRATOS::Lib:sudo_wrap() {
  if Path::Check 'sudo' ; then
    sudo $@
  else
    $@
  fi
}
