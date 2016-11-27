# This file is part of Kratos.
# Copyright (c) 2016, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

function triton_clear_env {
  # Clear environment variables in user environment used
  # by Triton's makeWrapper.

  unset GDK_PIXBUF_MODULE_FILE
  unset GI_TYPELIB_PATH
  unset GIO_EXTRA_MODULES
  unset GRL_PLUGIN_PATH
  unset GST_PLUGIN_SYSTEM_PATH_1_0
  unset GSETTINGS_SCHEMAS_PATH
  unset XDG_DATA_DIRS
  unset XDG_ICON_DIRS
}

function Triton::RemoveReferences {
  local Path
  local SearchPath="${1}"

  [ -d "${SearchPath}" ]

  while read Path ; do
    PathDir="$(dirname "${Path}")"
    if [ -f "${PathDir}/.git/config" ] && \
       [ -n "$(cat ${PathDir}/.git/config | grep 'triton')" ] ; then
      rm "${Path}"
    fi
  done < <(find -L "${SearchPath}" -xtype l -name "result*")
}

function Triton::CopyClosures {
  local -a Closures
  local -a EnvNames
  local -r Target="${1}"

  Var::Type.string "${Target}" || return 1

  mapfile -t EnvNames < <(
    awk 'c&&!--c;!/^.*\/\*/ && /buildEnv/ {c=1}' "${HOME}/.nixpkgs/config.nix" |
      grep -o -P '(?<=").*(?=")' || :
  )

  for i in "${EnvNames[@]}" ; do
    Closures+=($(find /nix/store -name "*${i}*"))
  done

  Closures+=($(find /nix/store -name "*$(hostname)*"))

  for i in "${Closures[@]}" ; do
    nix-copy-closure --to "${Target}" "${i}" || :
  done
}

function Triton::Rebuild {
  local -r Target="${1}"

  sudo nixos-rebuild "${Target}" \
    -I "nixos-config=/etc/nixos/configuration.nix" \
    -I "nixpkgs=${HOME}/Projects/triton"

}

function Triton::RebuildEnvs {
  local -a ConcurrentArgs
  local CONCURRENT_LIMIT=1
  local -a EnvAttrNames

  mapfile -t EnvAttrNames < <(
    awk '!/^.*\/\*/ && /buildEnv/ {print $1}' "${HOME}/.nixpkgs/config.nix"
  )

  # qt5 fails to parallel build when invoked by nix-env or when concurrently
  # building with another package.  In the meantime build it seperately.
  ConcurrentArgs+=('-' 'building-qt5' "nix-build -A qt5 ${HOME}/Projects/triton")

  for i in "${EnvAttrNames[@]}" ; do
    if [ -n "${i}" ] ; then
      ConcurrentArgs+=(
        '-' "${i}" "nix-env -iA ${i} -f ${HOME}/Projects/triton -k"
      )
    fi
  done

  concurrent ${ConcurrentArgs[@]}
}
