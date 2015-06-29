#!/usr/bin/env bash

# This file is part of Kratos.
# Copyright (c) 2014-2015, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

# Test for an interactive shell
[[ $- != *i* ]] && return

if shopt -q login_shell ; then
  . "$(readlink -f $(dirname $(readlink -f $HOME/.bashrc))/../)/login-shell.sh"
fi

# Load shell configuration loader
. "$(readlink -f $(dirname $(readlink -f $HOME/.bashrc))/../)/loader.sh"

# Load the local config
if [ -f "$HOME/.bashrc.local" ] ; then
  . "$HOME/.bashrc.local"
fi

# Prevent GUI password dialog
unset SSH_ASKPASS
