#!/usr/bin/env zsh

array_from_str () { # Creates an array from the name of the variable and values

  {[ "$#" -lt "1" ] || [ "$#" -gt "2" ]} && return 1

  ##[read in the array data]
  local DATA

  if [ "$#" -eq "1" ] ; then
    DATA="$(cat -)"
  else
    DATA="$2"
  fi

  # Convert the data into an array
  eval "$1=($DATA)"

}

array_new () { # Unique array functions with indicies starting at 0

  unset "$1"
  declare -a "$1"

}

array_at () {

  eval "echo \${$1[$(expr $2 + 1)]}"

}

array_append () {

  eval "$1+=(\"$2\")"

}

array_size () {

  eval "echo \${#$1}"

}

path_hasbin () { # Tests to see if a binary exists in the path

  [ "$#" -ne "1" ] && return 2
  whence -p $1 >/dev/null 2>&1 || \
  { echo "  '$1' not installed" ; return 1 ; }

}
