# This file is part of Kratos.
# Copyright (c) 2014-2015, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

# TODO: Find a way to return the executing function
# ZSH: $funcsourcetrace and $funcfiletrace. requires 5.0

function ErrError {

  if [ -n "${2}" ] ; then
    echo "Kratos: ERROR in \`${2}': ${1}"
  else
    echo "Kratos: ERROR in \`${FUNCNAME[1]}': ${1}"
  fi

  return 0

}

function ErrWarn {

  if [ -n "${2}" ] ; then
    echo "Kratos: WARNING in \`${2}': ${1}"
  else
    echo "Kratos: WARNING in \`${FUNCNAME[1]}': ${1}"
  fi

  return 0

}
