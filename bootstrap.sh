# This file is part of Kratos.
# Copyright (c) 2014-2015, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

export KRATOS_DIR="$(readlink -f "$(dirname "$(readlink -f "${0}")")")"
export DOTFILES_DIR="${HOME}/.dotfiles"

if [ -z "$KRATOS_DIR" ] ; then
  echo "ERROR: kratos remote repo origin is not set"
  exit 1
fi

. "${KRATOS_DIR}/lib/core.sh"

LoadAll 'modules' || exit 1

# TODO: make sure shell is supported before continuing if it hasn't failed
#  before this point.  Spawn one if it isn't.

# TODO: Add check for supported shell as default shell and change it if not.

# TODO: Check for previous Kratos installation, and test installation if
#  found for errors.

#PathHasBinErr '/usr/bin/env' || exit 1
PathHasBinErr 'git' || exit 1
# TODO: Make sure git is at least version 2.0.

kratos 'update'
