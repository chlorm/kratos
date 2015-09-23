# This file is part of Kratos.
# Copyright (c) 2014-2015, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

# TODO:
# Figure out what should be spawned by login shells
# - Automatic Updater
# - Tmp directory
# - Create a method to determine if login.sh has been run, otherwise run it from
#   init/shell.sh, before executing the contents of shell.sh

LoadAll 'main'
LoadAll 'login'