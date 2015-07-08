# This file is part of Kratos.
# Copyright (c) 2014-2015, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

# Returns the shell executing the current script
shell() {

  local LSHELL=
  local LPROC="$(ps hp $$ | grep "$$")"

  # Workaround for su spawned shells
  if [ -n "$(echo "$LPROC" | grep '\-su')" ] ; then
    LSHELL="$(basename "$(echo "$LPROC" | sed 's/^.*(\([^)]*\)).*$/\1/')")"
  else
    LSHELL="$(basename "$(echo "$LPROC" | sed 's/-//' | awk '{print $5}')")"
  fi

  # Resolve symlinked shells
  LSHELL="$(basename "$(readlink -f "$(path_abs "$LSHELL")")")"

  # Remove appended major version
  LSHELL="$(echo "$LSHELL" | sed 's/^\([a-z]*\).*/\1/')"

  LSHELL="$(tolower "$LSHELL")"

  echo "$LSHELL"

}

# Deprecated
shell_nov() { shell ; }
