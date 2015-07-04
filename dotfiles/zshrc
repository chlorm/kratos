#!/usr/bin/env zsh

# This file is part of Kratos.
# Copyright (c) 2014-2015, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

[[ -o interactive ]] || return

setopt PROMPT_SUBST

if [[ -o login ]] ; then
  . "$(readlink -f $(dirname $(readlink -f $HOME/.zshrc))/../)/login-shell.sh"
fi

# Load shell configuration loader
. "$(readlink -f $(dirname $(readlink -f $HOME/.zshrc))/../)/loader.sh"

alias sudo="nocorrect sudo"

# Load the local config
if [ -f "$HOME/.zshrc.local" ] ; then
  . "$HOME/.zshrc.local"
fi
