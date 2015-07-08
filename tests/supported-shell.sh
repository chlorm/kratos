# This file is part of Kratos.
# Copyright (c) 2014-2015, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

# This should include tests for anything used that is not part of the POSIX spec
# to test shell compatibility with Kratos.

# BASH style arrays are used throughout Kratos
shell_array_test() {

  local TEST_FOR_ARRAY_SUPPORT=("823")

  if [ "${TEST_FOR_ARRAY_SUPPORT[0]}" -eq 823 ] ; then
    return 0
  else
    return 1
  fi

}
shell_array_test

# Kratos uses the `function <function name>' method to declare functions
# instead of the Bourne/POSIX `<function name>()' method
function function_definition_test {

  return 0

}
function_definition_test
