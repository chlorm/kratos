# This file is part of Kratos.
# Copyright (c) 2014-2016, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

KRATOS::Plugins:git.branch() {

  local Branch
  local GitStatus

  GitStatus="$(git status 2>&1)" || return 1

  Branch="$(
    echo "${GitStatus}" |
    grep -m 1 'On branch' |
    awk '{for(i=3;i<=NF;++i)print $i}'
  )"

  echo "${Branch}"

  return 0

}

KRATOS::Plugins:git.status() {

  local GitStatus
  local Status

  GitStatus="$(git status 2>&1)" || return 1

  Status="$(
    if [[ -z "$(echo ${GitStatus} |
      grep -m 1 -w -o 'working directory clean')" ]] ; then
      echo "*"
    fi
  )"

  echo "${Status}"

  return 0

}
