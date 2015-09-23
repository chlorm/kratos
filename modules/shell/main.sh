# This file is part of Kratos.
# Copyright (c) 2014-2015, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

# http://en.wikipedia.org/wiki/Comparison_of_command_shells

function ShellPreferred {

  local _SHELL

  for _SHELL in "${SHELLS_PREFERENCE[@]}" ; do
    if PathHasBin "${_SHELL}" ; then
      echo "PREFERRED_SHELL=\"${_SHELL}\"" >> "$HOME/.local/share/kratos/preferences"
      return 0
    fi
  done

  ErrWarn 'no preferred shells found'

  return 1

}
