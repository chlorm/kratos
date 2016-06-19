# This file is part of Kratos.
# Copyright (c) 2014-2016, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

History::Shell

# Show history
case "${HIST_STAMPS}" in
  'mm/dd/yyyy')
    alias history='fc -fl 1'
    ;;
  'dd.mm.yyyy')
    alias history='fc -El 1'
    ;;
  'yyyy-mm-dd')
    alias history='fc -il 1'
    ;;
  *)
    alias history='fc -l 1'
    ;;
esac

alias h='history'
alias hs='History::Command'
alias hsi='hs -i'
