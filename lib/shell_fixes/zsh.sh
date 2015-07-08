#!/usr/bin/env zsh

# Tests to see if a binary exists in the path
path_hasbin () {

  [ "$#" -ne "1" ] && return 2

  whence -p "$1" >/dev/null 2>&1

}
