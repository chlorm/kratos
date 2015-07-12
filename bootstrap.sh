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

load.module() { # Source Modules

  . "${HOME}/.kratos/modules/${1}/default.sh" || {
    echo "Failed to load module $1"
    return 1
  }

  return 0

}

load.module 'path' || exit 1
load.module 'shell' || exit 1
load.module 'error' || exit 1

path.hasbin.err '/usr/bin/env' || exit 1
path.hasbin.err 'systemctl' || exit 1
path.hasbin.err 'git' || exit 1
# Find git version and make sure at least 2.0