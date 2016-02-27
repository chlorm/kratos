# This file is part of Kratos.
# Copyright (c) 2016, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

alias btrfs-defrag='KRATOS::Lib:sudo_wrap btrfs filesystem defragment -r -v -c lzo'
alias btrfs-errors='KRATOS::Plugins:btrfs.list-errors'
alias btrfs-scrub='KRATOS::Lib:sudo_wrap btrfs scrub start'
alias btrfs-status='KRATOS::Lib:sudo_wrap btrfs scrub status'
