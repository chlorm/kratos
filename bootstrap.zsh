# This file is part of Kratos.
# Copyright (c) 2014-2016, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

export KRATOS_DIR="$(readlink -f "$(dirname "$(readlink -f "${0}")")")"
export DOTFILES_DIR="${HOME}/.dotfiles"

if [[ -z "$KRATOS_DIR" ]] ; then
  echo "ERROR: kratos remote repo origin is not set"
  exit 1
fi

source "${KRATOS_DIR}/init/interactive.zsh"

KRATOS::Lib:load.all 'main' || exit 1

# TODO: Check for previous Kratos installation, and test installation if
#  one exists for errors.

KRATOS::Modules:kratos.command 'update'
