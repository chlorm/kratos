# This file is part of Kratos.
# Copyright (c) 2014-2016, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

# untracked files
# additions
# deletions
# modifications
# read to commit
# tag
# branch
# rebase
# stash
# detached head
# sha1
# diverged
# commits behind
# commits ahead
# can push
# working copy / remotes
# local branch
# remote branch

Git::Branch() {
  local Branch
  local GitStatus

  GitStatus="$(git status 2>&1)"

  Branch="$(
    echo "${GitStatus}" |
      grep -m 1 'On branch' |
      awk '{for(i=3;i<=NF;++i)print $i}'
  )"

  echo "${Branch}"
}

Git::Status() {
  local GitStatus
  local Status

  GitStatus="$(git status 2>&1)"

  GitStatus="$(echo ${GitStatus} | grep -m 1 -w -o 'working directory clean')"

  Status="$(
    if [[ -z "${GitStatus}" ]] ; then
      echo "*"
    fi
  )"

  echo "${Status}"
}
