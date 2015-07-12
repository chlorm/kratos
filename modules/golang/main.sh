# This file is part of Kratos.
# Copyright (c) 2014-2015, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

function golang {
  if [[ -n "$GOPATH" && "$GOPATH" != "$HOME/Dev/go" ]] ; then
    # Probably need to sanitize $GOPATH in case if contains multiple PATHs
    # Output paths to an array and iterate throught the array elements
    path.add "$GOPATH/bin"
    export GOPATH="$GOPATH"
  elif [ -d "$HOME/Dev/go" ] ; then
    path.add "$HOME/Dev/go/bin"
    export GOPATH="$HOME/Dev/go"
  fi
}
