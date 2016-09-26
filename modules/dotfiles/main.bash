# This file is part of Kratos.
# Copyright (c) 2014-2016, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

Dotfiles::GenerateHook.pre() {
  if [ -f "${1}.generate-pre" ] ; then
    source "${1}.generate-pre"
  fi
}

Dotfiles::GenerateHook() {
  local -r Dotfile="${1}"
  local -A CommandSubstitutions
  local -a CommandSubstitutionsUnevaled
  local CommandSubstitution
  local OutputDirRel
  local OutputFile
  local TMPDIR
  local Variable
  local VariableValue
  local -a Variables

  TMPDIR=`mktemp -d`

  # Find all variables in dotfile (e.g. `@{var}@')
  Variables=($(
    cat "${Dotfile}" |
      # Parse out variables between `@{' & `}@'
      grep -o -P '(?<=@{)[a-zA-Z0-9_]*(?=}@)' |
      # sed g already takes care of multiple instances
      uniq
  ))

  # Find all command substitutions in dotfile (e.g. `@(command --args)@')
  mapfile -t CommandSubstitutionsUnevaled < <(
    cat "${Dotfile}" | grep -o -P '(?<=@\().*(?=\)@)' | uniq
  )
  # Add add command substitutions and their evaluated strings to an
  # associative array;
  for CommandSubstitution in "${CommandSubstitutionsUnevaled[@]}" ; do
    # Evaluate command substitution
    CommandSubstitutionResult="$(${CommandSubstitution})"

    CommandSubstitutions=(
      ["${CommandSubstitution}"]="${CommandSubstitutionResult}"
    )
  done

  OutputName="$(echo "$(basename "${Dotfile}")" | sed -e 's/.generate//')"
  OutputDirRel="$(dirname "${Dotfile}" | sed -e "s|${DOTFILES_DIR}\/||")"

  cp "${Dotfile}" "${TMPDIR}/${OutputName}"

  # Replace variables with the contents of their shell equivalents
  # e.g. $USER == bob
  # replace all instances of `@{USER}@' with `bob')
  for Variable in "${Variables[@]}" ; do
    eval VariableValue="\"\$${Variable}\""
    # XXX: will fail if variable contains pipes (e.g. |) or sed
    #      special characters/escapes.
    sed -i "${TMPDIR}/${OutputName}" \
      -e "s|\(@{\)${Variable}\(}@\)|${VariableValue}|g"
  done

  # Replace command substitutions with the contents of their
  # evaluated strings.
  # e.g. $(uname -s) == Linux
  # replace all instances of `@(uname -a)@' with `Linux')
  for CommandSubstitution in "${!CommandSubstitutions[@]}" ; do
    # XXX: will fail if variable contains pipes (e.g. |) or sed
    #      special characters/escapes.
    sed -i "${TMPDIR}/${OutputName}" \
      -e "s|\(@(\)${CommandSubstitution}\()@\)|${CommandSubstitutions["${CommandSubstitution}"]}|g"
  done

  # Store the generated file in ~/.local/share for easy removal rather
  # than polluting the filesystem & symlink to target.
  Directory::Create "${HOME}/.local/share/kratos/generated/${OutputDirRel}"
  cp "${TMPDIR}/${OutputName}" \
    "${HOME}/.local/share/kratos/generated/${OutputDirRel}/${OutputName}"
  Symlink::Create \
    "${HOME}/.local/share/kratos/generated/${OutputDirRel}/${OutputName}" \
    "${HOME}/.${OutputDirRel}/${OutputName}"
}

Dotfiles::GenerateHook.post() {
  if [ -f "${1}.generate-post" ] ; then
    source "${1}.generate-post"
  fi
}

Dotfiles::InstallHook.pre() {
  if [ -f "${1}.install-pre" ] ; then
    source "${1}.install-pre"
  fi
}

Dotfiles::InstallHook() {
  if [ -f "${1}.install" ] ; then
    source "${1}.install"
  fi
}

Dotfiles::InstallHook.post() {
  if [ -f "${1}.install-post" ] ; then
    source "${1}.install-post"
  fi
}

Dotfiles::UninstallHook.pre() {
  if [ -f "${1}.uninstall-pre" ] ; then
    source "${1}.uninstall-pre"
  fi
}

Dotfiles::UninstallHook() {
  if [ -f "${1}.uninstall" ] ; then
    source "${1}.uninstall"
  fi
}

Dotfiles::UninstallHook.post() {
  if [ -f "${1}.uninstall-post" ] ; then
    source "${1}.uninstall-post"
  fi
}

Dotfiles::Hook() {
  local Dotfile
  local -a Dotfiles
  local Uninstall
  local IgnoreItem
  local -a IgnoreList
  local IgnoreStatus

  Uninstall=false
  if [ "${1}" == 'uninstall' ] ; then
    Uninstall=true
  fi

  Dotfiles=()
  # Respect filenames with spaces
  mapfile -t Dotfiles < <(
    find "${DOTFILES_DIR}" -type f -not -iwholename '*.git*'
  )

  IgnoreList=()
  if [[ -f "${DOTFILES_DIR}/.kratosignore" ]] ; then
    IgnoreList+=($(cat "${DOTFILES_DIR}/.kratosignore"))
  fi
  # TODO: Add systemd support
  IgnoreList+=("${HOME}/.config/systemd")

  # Respect .kratosignore file
  if [ -f "${DOTFILES_DIR}/.kratosignore" ] ; then
    IgnoreList+=($(cat "${DOTFILES_DIR}/.kratosignore"))
  fi

  for Dotfile in "${Dotfiles[@]}" ; do

    # Catch potential errors where paths are split into multiple array elements
    #  caused by spaces in the path.
    if [[ -n ${Dotfile} && ! -e ${Dotfile} ]] ; then
      Log::Message 'error' "invalid file: ${Dotfile}"
    fi

    # Ignore hidden files
    if [[ "$(basename "${Dotfile}")" =~ "^\." ]] ; then
      continue
    fi
    # Make sure file exists
    if [ ! -e "${Dotfile}" ] ; then
      continue
    fi

    # Ignore kratos hooks; these are only invoked under special conditions.
    case "${Dotfile##*.}" in
      'install-pre'|\
      'install'|\
      'install-post'|\
      'generate-pre'|\
      'generate-post'|\
      'uninstall-pre'|\
      'uninstall'|\
      'uninstall-post')
        continue
        ;;
    esac

    # Respect .kratosignore
    IgnoreStatus=false
    for IgnoreItem in "${IgnoreList[@]}" ; do
      # Respect ignoring files within ignore directories
      if [[ -n "$(echo "${Dotfile}" | grep "${IgnoreItem}")" ]] ; then
        IgnoreStatus=true
        break
      fi
    done
    if ${IgnoreStatus} ; then
      continue
    fi

    # PRE-(Un)Install
    if ${Uninstall} ; then
      Dotfiles::UninstallHook.pre "${Dotfile}"
    else
      Dotfiles::InstallHook.pre "${Dotfile}"
    fi

    # (Un)Install
    if ${Uninstall} ; then
      if [ -f "${Dotfile}.uninstall" ] ; then
        Dotfiles::UninstallHook "${Dotfile}"
      else
        echo "uninstall"
      fi
    else
      if [ -f "${Dotfile}.install" ] ; then
        Dotfiles::InstallHook "${Dotfile}"
      else
        if [[ "${Dotfile##*.}" == 'generate' ]] ; then
          printf "Generating: ${Dotfile}"\\n
          Dotfiles::GenerateHook.pre "${Dotfile}"
          Dotfiles::GenerateHook "${Dotfile}"
          Dotfiles::GenerateHook.post "${Dotfile}"
        else
          if [ ! -e "${HOME}/.$(echo "${Dotfile}" | \
                   sed -e "s|${DOTFILES_DIR}\/||")" ] ; then
            printf "Installing: ${Dotfile}"\\n
          fi

          # TODO: add logic to prevent from following symlinked directory paths,
          #       may not be necessary
          File::Remove \
            "${HOME}/.$(echo "${Dotfile}" | sed -e "s|${DOTFILES_DIR}\/||")"

          # Symlink DOTFILE
          Symlink::Create \
            "${Dotfile}" "${HOME}/.$(
              echo "${Dotfile}" | sed -e "s|${DOTFILES_DIR}\/||"
            )"
        fi
      fi
    fi

    # POST-(Un)Install
    if ${Uninstall} ; then
      Dotfiles::UninstallHook.post "${Dotfile}"
    else
      Dotfiles::InstallHook.post "${Dotfile}"
    fi

  done
}
