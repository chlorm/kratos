# This file is part of Kratos.
# Copyright (c) 2014-2016, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

export KRATOS_DIR="$(readlink -f "$(dirname "$(readlink -f "${0}")")")"
export DOTFILES_DIR="${HOME}/.dotfiles"

if [ -z "${KRATOS_DIR}" ] ; then
  echo "ERROR: kratos remote repo origin is not set"
  exit 1
fi

source "$(lib-bash)"
source "${KRATOS_DIR}/lib/core.bash"
source "${KRATOS_DIR}/lib/DEFAULTS.bash"

Loader::All 'main' || exit 1

# TODO: Check for previous Kratos installation, and test installation if
#  one exists for errors.

Kratos::Command 'update' || exit 1

if type bash > /dev/null ; then
  exec bash -i
  exit $?
fi
