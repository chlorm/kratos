# This file is part of Kratos.
# Copyright (c) 2014-2015, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

# Default aliases

alias proj="cd ${HOME}/Projects"

alias root="SudoWrap su -"
alias nixpaste="curl -F 'text=<-' http://nixpaste.noip.me"
alias youtube="youtube-dl --max-quality --no-check-certificate --prefer-insecure --console-title"
alias music="ncmpcpp"
alias tarxz="tar cjvf"
# Btrfs
alias defragmentroot="sudo btrfs filesystem defragment -r -v /"
alias defragmenthome="sudo btrfs filesystem defragment -r -v /home"