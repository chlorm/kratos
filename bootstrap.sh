# This file is part of Kratos.
# Copyright (c) 2014-2015, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

# TODO:
# + Bootstrap kratos installation, afterwards all everything should be controlled
#    by the kratos module.





# Check to see if reqired applications are installed
#  systemd, gitv2, /usr/bin/env

# Make sure executing shell is supported

# Check to see if kratos directory exists, if not, clone kratos

# Install shell rc files

# Respawn shell or source ~/.profile which will handle doing so

export KRATOS_DIR="$(readlink -f "$(dirname "$(readlink -f "${0}")")")/"
export DOTFILES_DIR="${HOME}/.dotfiles"

if [ -z "$KRATOS_DIR" ] ; then
  echo "ERROR: kratos remote repo origin is not set"
  exit 1
fi

. "${KRATOS_DIR}/lib/core.sh"

LoadAll 'modules' || exit 1

#PathHasBinErr '/usr/bin/env' || exit 1
PathHasBinErr 'git' || exit 1
# Find git version and make sure at least 2.0

kratos 'update'
