path_hasbin() { # Test to see if a binary exists in the path

  [ "$#" -ne "1" ] && return 2

  if [ "$(shell)" == 'bash' ] ; then
    type "$1" > /dev/null 2>&1 || return 1
  else
    whence -p "$1" > /dev/null 2>&1 || return 1
  fi

  return 0

}
